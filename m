Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZFXGoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZFXGoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZFXGoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:44:06 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:35943 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZFXGoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:44:01 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_LP78dORrJ4g5/jqY0TuXgg)"
Date: Wed, 24 Jun 2009 02:43:52 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI & driver patches for 2.6.31-rc0
Message-id: <alpine.LFD.2.00.0906240241050.32742@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_LP78dORrJ4g5/jqY0TuXgg)
Content-type: TEXT/PLAIN; charset=ISO-8859-7
Content-transfer-encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.30/acpi-release-20090521-2.6.30.diff.gz

 Documentation/kernel-parameters.txt     |    8 -
 Documentation/laptops/thinkpad-acpi.txt |   47 ++-
 MAINTAINERS                             |   15 +-
 arch/ia64/kernel/acpi-processor.c       |   12 +
 arch/x86/include/asm/acpi.h             |    1 +
 arch/x86/include/asm/pci_x86.h          |    3 +
 arch/x86/kernel/acpi/boot.c             |   80 +----
 arch/x86/kernel/acpi/cstate.c           |   16 +-
 arch/x86/kernel/acpi/processor.c        |   13 +
 arch/x86/pci/mmconfig-shared.c          |   65 ++++-
 drivers/acpi/ac.c                       |   20 +-
 drivers/acpi/battery.c                  |   34 +--
 drivers/acpi/blacklist.c                |   16 +
 drivers/acpi/bus.c                      |   91 ++----
 drivers/acpi/glue.c                     |   40 --
 drivers/acpi/osl.c                      |   25 +-
 drivers/acpi/pci_bind.c                 |  313 ++--------------
 drivers/acpi/pci_irq.c                  |   17 +-
 drivers/acpi/pci_root.c                 |  297 +++++++++-------
 drivers/acpi/power.c                    |   28 +--
 drivers/acpi/processor_core.c           |   45 ++-
 drivers/acpi/processor_idle.c           |   47 ++--
 drivers/acpi/scan.c                     |   69 ++--
 drivers/acpi/video.c                    |   61 +++-
 drivers/acpi/video_detect.c             |    9 +-
 drivers/gpu/drm/i915/i915_opregion.c    |    2 +-
 drivers/pci/hotplug/acpi_pcihp.c        |   40 +--
 drivers/pci/hotplug/acpiphp_glue.c      |   27 +-
 drivers/platform/x86/Kconfig            |   34 ++-
 drivers/platform/x86/Makefile           |    1 +
 drivers/platform/x86/acerhdf.c          |  602 +++++++++++++++++++++++++++++++
 drivers/platform/x86/asus-laptop.c      |  111 +++----
 drivers/platform/x86/asus_acpi.c        |   30 +-
 drivers/platform/x86/dell-wmi.c         |   56 +++-
 drivers/platform/x86/eeepc-laptop.c     |  126 ++++++-
 drivers/platform/x86/hp-wmi.c           |   87 +++--
 drivers/platform/x86/thinkpad_acpi.c    |  411 +++++++++++++++++++--
 drivers/pnp/pnpacpi/rsparser.c          |   46 +++-
 include/acpi/acpi_bus.h                 |    7 +-
 include/acpi/acpi_drivers.h             |   13 +-
 include/acpi/processor.h                |    1 +
 include/acpi/video.h                    |    4 +-
 include/linux/acpi.h                    |    6 +-
 include/linux/pci_hotplug.h             |    1 -
 init/main.c                             |    6 +-
 45 files changed, 1926 insertions(+), 1057 deletions(-)
 create mode 100644 drivers/platform/x86/acerhdf.c

through these commits:

Alex Chiang (2):
      ACPI: acpi_device_register() should call device_register()
      ACPI: clean up whitespace in drivers/acpi/scan.c

Alexander Chiang (12):
      ACPI: make acpi_pci_bind() static
      ACPI: Introduce acpi_is_root_bridge()
      ACPI: Introduce acpi_get_pci_dev()
      ACPI: rearrange acpi_pci_bind/acpi_pci_unbind in pci_bind.c
      ACPI: eviscerate pci_bind.c
      ACPI: simplify acpi_pci_irq_add_prt() API
      ACPI: simplify acpi_pci_irq_del_prt() API
      ACPI: acpi_pci_unbind should clean up properly after acpi_pci_bind
      PCI Hotplug: acpiphp: convert to acpi_get_pci_dev
      ACPI: kill acpi_get_pci_id
      ACPI: video: convert to acpi_get_pci_dev
      ACPI: kill acpi_get_physical_pci_device()

Bjorn Helgaas (20):
      ACPI: use LNXCPU, not ACPI_CPU, for Linux-specific processor _HID
      ACPI: processor: check for synthetic _HID, default to "Device" declaration
      ACPI: processor: move device _HID into driver
      PNPACPI: parse Extended Address Space Descriptors
      ACPI: don't check power state after _ON/_OFF
      ACPI: allow drivers to request both device and system notify events
      ACPI: ac: use .notify method instead of installing handler directly
      ACPI: battery: use .notify method instead of installing handler directly
      ACPI: asus-laptop: use .notify method instead of installing handler directly
      ACPI: asus-acpi: use .notify method instead of installing handler directly
      ACPI: eeepc-laptop: use .notify method instead of installing handler directly
      ACPI: simplify notification debug messages
      ACPI: remove unused "status_changed" return value from Check Device handling
      ACPI: remove unused return values from Bus Check & Device Check handling
      ACPI: use handle, not device, in system notification path
      ACPI: pci_root: check _CRS, then _BBN for downstream bus number
      ACPI: pci_root: simplify acpi_pci_root_add() control flow
      ACPI: pci_root: use driver data rather than list lookup
      ACPI: pci_root: simplify list traversals
      ACPI: pci_root: remove unused dev/fn information

Corentin Chary (7):
      asus-laptop: platform dev as parent for led and backlight
      acpi4asus: update MAINTAINER and KConfig links
      asus_acpi: Deprecate in favor of asus-laptop
      eeepc-laptop: sync eeepc-laptop with asus_acpi
      eeepc-laptop: cpufv updates
      asus-laptop: use pr_fmt and pr_<level>
      asus-laptop: remove EXPERIMENTAL dependency

Henrique de Moraes Holschuh (7):
      thinkpad-acpi: store fw version with strict checking
      thinkpad-acpi: add quirklist engine
      thinkpad-acpi: fix BEEP ACPI handler warnings
      thinkpad-acpi: enhance led support
      thinkpad-acpi: silence bogus warning when ACPI video is disabled
      thinkpad-acpi: forbid the use of HBRV on Lenovo ThinkPads
      thinkpad-acpi: support the second fan on the X61

Len Brown (7):
      ACPI: delete acpi.power_nocheck from kernel-parameters.txt
      ACPI: delete dead acpi_disabled setting code
      ACPI, PCI, x86: move MCFG parsing routine from ACPI to PCI file
      ACPI: move declaration acpi_early_init() to acpi.h
      ACPI: #define acpi_disabled 1 for CONFIG_ACPI=n
      ACPI: battery: fix CONFIG_ACPI_PROCFS_POWER=n build warning
      ACPI: idle: rename lapic timer workaround routines

Mario Limonciello (2):
      dell-wmi: mask off upper bytes of event response
      dell-wmi: add additional keyboard events

Matthew Garrett (2):
      dell-wmi: don't generate errors on empty messages
      hp-wmi: Add support for reporting tablet state

Olivier Berger (1):
      ACPI: Remove Asus P4B266 from blacklist

Pallipadi, Venkatesh (2):
      ACPI: Disable ARB_DISABLE on platforms where it is not needed
      ACPI: pdc init related memory leak with physical CPU hotplug

Pekka Enberg (1):
      eeepc-laptop: enable camera by default

Peter Feuerer (1):
      acerhdf: Acer Aspire One fan control

Zhang Rui (5):
      Show the physical device node of backlight class device.
      ACPI: fix a deadlock in hotplug case
      ACPI: DMI to disable Vista compatibility on some Sony laptops
      ACPI: run ACPI device hot removal in kacpi_hotplug_wq
      ACPI: video: DMI workaround broken Acer 7720 BIOS enabling display brightness

Zhao Yakui (3):
      ACPI: increase size of acpi_bus_id[]
      ACPI: Add the reference count to avoid unloading ACPI video bus twice
      ACPI: Rename ACPI processor device bus ID

with this log:

commit 21ab01e2fcbfcc0d1faba2b7336b3c0f7f3c1ac8
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Jun 19 14:52:11 2009 +0200

    asus-laptop: remove EXPERIMENTAL dependency
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2fcc23da5522b89677fb0af6043a88e88fdd09a2
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Jun 19 14:52:03 2009 +0200

    asus-laptop: use pr_fmt and pr_<level>
    
    Convert the unusual printk(ASUS_<level> uses to
    the more standard pr_fmt and pr_<level>(.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b31d0fde89c905673ceed0404d5ae24f2261d7c7
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Jun 16 19:28:56 2009 +0000

    eeepc-laptop: cpufv updates
    
    Limit cpufv input to acceptables values.
    Add an available_cpufv file to show available
    presets.
    Change cpufv ouput format from %d to %#x, it won't
    break compatibility with existing userspace tools, but
    it provide a more human readable output.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b7b700d4a473d56103e87e341ad555e8a7cce06d
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Jun 16 19:28:52 2009 +0000

    eeepc-laptop: sync eeepc-laptop with asus_acpi
    
    In the default Eee PC distribution, there is a modified
    asus_acpi driver. eeepc-laptop is a cleaned version of this
    driver. Sync ASL enum and getter/setters with asus_acpi.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6122af3743a48dddae19810626dd7c9c8e6c1df8
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Jun 16 19:28:48 2009 +0000

    asus_acpi: Deprecate in favor of asus-laptop
    
    asus-laptop have been merged in the kernel two years ago,
    it is now stable and used by most distribution instead of
    the old asus_acpi driver.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 76593d6fb0a51cb0d666f37d91a990e36c068365
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Jun 16 19:28:47 2009 +0000

    acpi4asus: update MAINTAINER and KConfig links
    
    The bug tracker have moved from sourceforge to
    http://dev.iksaif.net . The homepage of the project
    is now http://acpi4asus.sf.net with links to the new
    bug tracker. No change for the mailing list.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 116bf2e010a0600371aede450351973821dfd9e2
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Jun 16 19:28:46 2009 +0000

    asus-laptop: platform dev as parent for led and backlight
    
    Makes asus-laptop platform device the parent device of
    backlight and led classes.
    
    With this patch, leds and backlight are also available in
    /sys/devices/platform/asus-laptop/ like thinkpad_acpi.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cede2cb6ee9b0ddaa3dbc9939418ff177a831600
Author: Pekka Enberg <penberg@cs.helsinki.fi>
Date:   Tue Jun 16 19:28:45 2009 +0000

    eeepc-laptop: enable camera by default
    
    If we leave the camera disabled by default, userspace programs (e.g.
    Skype, Cheese) leave the user out in the cold saying that the machine
    "has no camera." Therefore, it's better to enable camera by default and
    let people who really don't want it just disable the thing.
    
    To reduce power usage you should enable USB autosuspend:
    echo -n auto > /sys/bus/usb/drivers/uvcvideo/*:*/../power/level
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 57599cc997b81a7c4f764693a7316886a72067fe
Merge: fbe8cdd 586caae
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jun 24 01:22:20 2009 -0400

    Merge branch 'bjorn-notify' into release
    
    Conflicts:
    	drivers/platform/x86/eeepc-laptop.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fbe8cddd2d85979d273d7937a2b8a47498694d91
Merge: 4e8a237 e86435e 7fe2a6c 0705495 35a7c64 152a4e6 86e437f c8d72a5 7a04b84 ee1ca48 9eccbc2 7e275cc 7b768f0 8cb24c8 113b3a2 d737724 056c308 871043b
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jun 24 01:19:50 2009 -0400

    Merge branches 'acerhdf', 'acpi-pci-bind', 'bjorn-pci-root', 'bugzilla-12904', 'bugzilla-13121', 'bugzilla-13396', 'bugzilla-13533', 'bugzilla-13612', 'c3_lock', 'hid-cleanups', 'misc-2.6.31', 'pdc-leak-fix', 'pnpacpi', 'power_nocheck', 'thinkpad_acpi', 'video' and 'wmi' into release

commit 7a04b8491a077471a34938b8ca060c37220953be
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Jun 24 11:46:44 2009 +0800

    ACPI: Rename ACPI processor device bus ID
    
    Some BIOS re-use the same processor bus id
    in different scope:
    
    	\_SB.SCK0.CPU0
    	\_SB.SCK1.CPU0
    
    But the (deprecated) /proc/acpi/ interface
    assumes the bus-id's are unique, resulting in an OOPS
    when the processor driver is loaded:
    
    WARNING: at fs/proc/generic.c:590 proc_register+0x148/0x180()
    Hardware name: Sunrise Ridge
    proc_dir_entry 'processor/CPU0' already registered
    Call Trace:
     [<ffffffff8023f7ef>] warn_slowpath+0xb1/0xe5
     [<ffffffff8036243b>] ? ida_get_new_above+0x190/0x1b1
     [<ffffffff803625a8>] ? idr_pre_get+0x5f/0x75
     [<ffffffff8030b2f6>] proc_register+0x148/0x180
     [<ffffffff8030b4ff>] proc_mkdir_mode+0x3d/0x52
     [<ffffffff8030b525>] proc_mkdir+0x11/0x13
     [<ffffffffa0014b89>] acpi_processor_start+0x755/0x9bc [processor]
    
    Rename the processor device bus id. And the new bus id will be
    generated as the following format:
    	CPU+ CPU ID
    
    For example: If the cpu ID is 5, then the bus ID will be "CPU5".
    	If the CPU ID is 10, then the bus ID will be "CPUA".
    
    Yes, this will change the directory names seen
    in /proc/acpi/processor/* on some systems.
    Before this patch, those directory names where
    totally arbitrary strings based on the interal AML device strings.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13612
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e86435eb91b2bff114c5a02e46e16ce21b647ebe
Author: Peter Feuerer <peter@piie.net>
Date:   Sun Jun 21 18:53:03 2009 +0200

    acerhdf: Acer Aspire One fan control
    
    Acerhdf is a driver for Acer Aspire One netbooks. It allows
    to access the temperature sensor and to control the fan.
    
    Signed-off-by: Peter Feuerer <peter@piie.net>
    Signed-off-by: Andreas Mohr <andi@lisas.de>
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 152a4e630f7ffdd7ff64427c4ba488dc0bce76af
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Jun 22 11:31:18 2009 +0800

    ACPI: video: DMI workaround broken Acer 7720 BIOS enabling display brightness
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13121
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c8d72a5e76988140bfdfd8722f2228d94e7fa10f
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Jun 22 11:31:16 2009 +0800

    ACPI: run ACPI device hot removal in kacpi_hotplug_wq
    
    Now that new interface is available,
    convert to using it rather than creating a new kernel thread.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 86e437f077c68112edcb6854ec036ed7e3f9a7f3
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Jun 16 11:23:13 2009 +0800

    ACPI: Add the reference count to avoid unloading ACPI video bus twice
    
    Sometimes both acpi video and i915 driver are compiled as modules.
    And there exists the strict dependency between the two drivers.
    The acpi video bus will be unloaded in course of unloading the i915 driver.
    If we unload the acpi video driver, then the kernel oops will be triggered.
    
    Add the reference count to avoid unloading the ACPI video bus twice.
    The reference count should be checked before unregistering the acpi video bus.
    If the reference count is already zero, it won't unregister it again.
    And after the acpi video bus is already unregistered, the reference count
    will be set to zero.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13396
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 35a7c64fbc77bab4ca8ae477e8ab278ccd679ce2
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Jun 22 11:31:17 2009 +0800

    ACPI: DMI to disable Vista compatibility on some Sony laptops
    
    Linux claims Vista compatibility to the BIOS for a number of
    reasons, but this brings hard lockup on some Sony laptops.
    
    Disable Vista compatibility via DMI for these laptops unless
    we can figure out what Vista is doing for this platform.
    http://bugzilla.kernel.org/show_bug.cgi?id=12904
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c02256be79a1a3557332ac51e653d574a2a7d2b5
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Jun 23 10:20:29 2009 +0800

    ACPI: fix a deadlock in hotplug case
    
    we used to run the hotplug code in keventd_wq.
    But when hot removing the ACPI battery device,
    power_supply_unregister invokes flush_scheduled_work.
    This causes a deadlock. i.e
    1. When dock is unplugged, all the hotplug code is run on kevent_wq.
    2. the hotplug code removes all the child devices of dock device.
    3. removing the child device may invoke flush_scheduled_work
    4. flush_scheduled_work waits until all the work on kevent_wq to be
       finished, while this will never be true because the hotplug code
       is running on keventd_wq...
    
    Introduce a new workqueue for hotplug in this patch.
    http://bugzilla.kernel.org/show_bug.cgi?id=13533
    
    Tested-by: Paul Martin <pm@debian.org>
    Tested-by: Vojtech Gondzala <vojtech.gondzala@gmail.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 056c308d3e4859334b519033d62ef050f0e0e261
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Jun 22 11:31:14 2009 +0800

    Show the physical device node of backlight class device.
    
    Create symbol link from backlight class device to ACPI video device.
    
    More and more laptops are shipped with multiple ACPI
    video devices, while we export only one of them to userspace.
    
    With this patch applied, we can know which ACPI video device
    is used by "cat /sys/class/backlight/acpi_video0/device/path".
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7b768f07dce463a054c9dd84862d15ccc3d2b712
Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Date:   Fri Jun 19 17:14:59 2009 -0700

    ACPI: pdc init related memory leak with physical CPU hotplug
    
    arch_acpi_processor_cleanup_pdc() in x86 and ia64 results in memory allocated
    for _PDC objects that is never freed and will cause memory leak in case of
    physical CPU remove and add. Patch fixes the memory leak by freeing the
    objects soon after _PDC is evaluated.
    
    Reported-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0705495d9010048e293013d9d129cf723363a0a8
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jun 18 14:47:07 2009 -0600

    ACPI: pci_root: remove unused dev/fn information
    
    We never use the PCI device & function number, so remove it to make
    it clear that it's not needed.  Many PCI host bridges don't even
    appear in config space, so it's meaningless to look at stuff from
    _ADR, which doesn't exist in that case.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c1aec8341627dad5d63cc24aa6746dc077f5b706
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jun 18 14:47:02 2009 -0600

    ACPI: pci_root: simplify list traversals
    
    Using list_for_each_entry() makes traversing the root list easier.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit caf420c68afe01acd7c458ce40b85b3db5330ff5
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jun 18 14:46:57 2009 -0600

    ACPI: pci_root: use driver data rather than list lookup
    
    There's no need to search the list to find the acpi_pci_root
    structure.  We saved it as device->driver_data when we added
    the device.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f5eebbe119a861b5e4f5c67c886eab0937c686ed
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jun 18 14:46:52 2009 -0600

    ACPI: pci_root: simplify acpi_pci_root_add() control flow
    
    By looking up the segment & bus number earlier, we don't have to
    worry about cleaning up if it fails.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fbe2b31b4b6dfa790cbc88e00631f3112c4fc54e
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jun 18 14:46:47 2009 -0600

    ACPI: pci_root: check _CRS, then _BBN for downstream bus number
    
    To find a host bridge's downstream bus number, we currently look at _BBN
    first.  If _BBN returns a bus number we've already seen, we conclude that
    _BBN was wrong and look for a bus number in _CRS.
    
    However, the spec[1] (figure 5-5 and the example in sec 9.12.1) and an ACPI
    FAQ[2] suggest that the OS should use _CRS to discover the bus number
    range, and that _BBN is really intended to bootstrap _CRS methods that
    reference PCI opregions.
    
    This patch makes us always look at _CRS first.  If _CRS doesn't supply a
    bus number, we look at _BBN.  If _BBN doesn't exist, we default to zero.
    This makes the behavior consistent regardless of device discovery order.
    Previously, if A and B had duplicate _BBNs and we found A first, we'd only
    look at B's _CRS, whereas if we found B first, we'd only look at A's _CRS.
    
    I'm told that Windows discovers host bridge bus numbers using _CRS, so
    it should be fairly safe to rely on this BIOS functionality.
    
    This patch also removes two misleading messages: we printed the "Wrong _BBN
    value, reboot and use option 'pci=noacpi'" message before looking at _CRS,
    so we would likely find the bus number in _CRS, the system would work fine,
    and the user would be confused.  The "PCI _CRS %d overrides _BBN 0" message
    incorrectly assumes _BBN was zero, and it's useless anyway because we
    print the segment/bus number a few lines later.
    
    References:
        [1] http://www.acpi.info/DOWNLOADS/ACPIspec30b.pdf
        [2] http://www.acpi.info/acpi_faq.htm _BBN/_CRS discussion
        http://download.microsoft.com/download/9/8/f/98f3fe47-dfc3-4e74-92a3-088782200fe7/TWAR05005_WinHEC05.ppt (slide 17)
        http://bugzilla.kernel.org/show_bug.cgi?id=1662 ASUS PR-DLS
        http://bugzilla.kernel.org/show_bug.cgi?id=1127 ASUS PR-DLSW
        http://bugzilla.kernel.org/show_bug.cgi?id=1741 ASUS PR-DLS533
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Alex Chiang <achiang@hp.com>
    CC: Shaohua Li <shaohua.li@intel.com>
    CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d73772474f6ebbacbe820c31c0fa1cffa7160246
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Thu Jun 18 00:40:17 2009 -0300

    thinkpad-acpi: support the second fan on the X61
    
    Support reading the tachometer of the auxiliary fan of a X60/X61.
    
    It was found out by sheer luck, that bit 0 of EC register 0x31
    (formely HBRV) selects which fan is active for tachometer readings
    through EC 0x84/0x085: 0 for fan1, 1 for fan2.
    
    Many thanks to Christoph Kl??nter, to Whoopie, and to weasel, who
    helped confirm that behaviour.
    
    Fan control through EC HFSP applies to both fans equally, regardless
    of the state of bit 0 of EC 0x31.  That matches the way the DSDT uses
    HFSP.
    
    In order to better support the secondary fan, export a second
    tachometer over hwmon, and add defensive measures to make sure we are
    reading the correct tachometer.
    
    Support for the second fan is whitelist-based, as I have not found
    anything obvious to look for in the DSDT to detect the presence of
    the second fan.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d7880f10c5d42ba182a97c1fd41d41d0b8837097
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Thu Jun 18 00:40:16 2009 -0300

    thinkpad-acpi: forbid the use of HBRV on Lenovo ThinkPads
    
    Forcing thinkpad-acpi to do EC-based brightness control (HBRV) on a
    X61 has very... interesting effects, instead of doing nothing (since
    it doesn't have EC-based backlight control), it causes "weirdness" in
    the fan tachometer readings, for example.
    
    This means the EC register that used to be HBRV has been reused by
    Lenovo for something else, but they didn't remove it from the DSDT.
    
    Make sure the documentation reflects this data, and forbid the user
    from forcing the driver to access HBRV on Lenovo ThinkPads.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7e275cc4e8e20f82740bf40ae2f5695e9e35ff09
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 15 02:08:44 2009 -0400

    ACPI: idle: rename lapic timer workaround routines
    
    cosmetic only.  The lapic_timer workaround routines
    are specific to the lapic_timer, and are not acpi-generic.
    
    old:
    
    acpi_timer_check_state()
    acpi_propagate_timer_broadcast()
    acpi_state_timer_broadcast()
    
    new:
    
    lapic_timer_check_state()
    lapic_timer_propagate_broadcast()
    lapic_timer_state_broadcast()
    
    also, simplify the code in acpi_processor_power_verify()
    so that lapic_timer_check_state() is simply called
    from one place for all valid C-states, including C1.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 586caae36cece718ff46b3a59b88af79e9f7a2e0
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jun 18 00:38:27 2009 -0400

    ACPI: battery: fix CONFIG_ACPI_PROCFS_POWER=n build warning
    
    drivers/acpi/battery.c:841: warning: label ¡end¢ defined but not used
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ff754e2e85557ed7244385f0f2053c80e8ac9948
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri May 22 11:43:56 2009 -0600

    ACPI: use handle, not device, in system notification path
    
    This patch changes the global system notification path so it uses the
    acpi_handle, not the acpi_device.
    
    System notifications often deal with device presence and status change.
    In these cases, we may not have an acpi_device.  For example, we may
    get a Device Check notification on an object that previously was not
    present.  Since the object was not present, we would not have had an
    acpi_device for it.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cdd5b8ca122cc4239375dee7fcdc658315c119e4
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri May 22 11:43:51 2009 -0600

    ACPI: remove unused return values from Bus Check & Device Check handling
    
    Remove return values from acpi_bus_check_device() and acpi_bus_check_scope()
    since nobody looks at them.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aa8a149c0cc822e3886eb85b95cb2f7d67e5b7e6
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri May 22 11:43:46 2009 -0600

    ACPI: remove unused "status_changed" return value from Check Device handling
    
    Remove "status_changed" return from acpi_bus_check_device().  Nobody
    does anything useful based on its value.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 02c37bd8d0737c31caaed9a65bd7cb80aefb4c9a
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri May 22 11:43:41 2009 -0600

    ACPI: simplify notification debug messages
    
    This replaces several messages that depend on the acpi_device struct
    with a single message that uses just the acpi_handle.  We should be
    able to deal with notifications to objects that do not yet have an
    acpi_device struct.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d9b9bd7b4a579ff0340d29c2547b952a920639e6
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Apr 30 09:36:03 2009 -0600

    ACPI: eeepc-laptop: use .notify method instead of installing handler directly
    
    This patch adds a .notify() method.  The presence of .notify() causes
    Linux/ACPI to manage event handlers and notify handlers on our behalf,
    so we don't have to install and remove them ourselves.
    
    This driver relies on seeing system notify events, not device-specific
    ones (because it used ACPI_SYSTEM_NOTIFY).  We use the
    ACPI_DRIVER_ALL_NOTIFY_EVENTS driver flag to request all events, then
    just ignore any device events we get.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    CC: Corentin Chary <corentincj@iksaif.net>
    CC: acpi4asus-user@lists.sourceforge.net
    CC: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 352fa202c3320ac4844cd38fa72c7a91d7c4cfea
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Apr 30 09:35:58 2009 -0600

    ACPI: asus-acpi: use .notify method instead of installing handler directly
    
    This patch adds a .notify() method.  The presence of .notify() causes
    Linux/ACPI to manage event handlers and notify handlers on our behalf,
    so we don't have to install and remove them ourselves.
    
    This driver relies on seeing system notify events, not device-specific
    ones (because it used ACPI_SYSTEM_NOTIFY).  We use the
    ACPI_DRIVER_ALL_NOTIFY_EVENTS driver flag to request all events, then
    just ignore any device events we get.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    CC: Corentin Chary <corentincj@iksaif.net>
    CC: Karol Kozimor <sziwan@users.sourceforge.net>
    CC: acpi4asus-user@lists.sourceforge.net
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 586ed1604fd6137cae1e8ede8143c3b8897306fd
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Apr 30 09:35:53 2009 -0600

    ACPI: asus-laptop: use .notify method instead of installing handler directly
    
    This patch adds a .notify() method.  The presence of .notify() causes
    Linux/ACPI to manage event handlers and notify handlers on our behalf,
    so we don't have to install and remove them ourselves.
    
    This driver apparently relies on seeing ALL notify events, not just
    device-specific ones (because it used ACPI_ALL_NOTIFY).  We use the
    ACPI_DRIVER_ALL_NOTIFY_EVENTS driver flag to request all events.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    CC: Corentin Chary <corentincj@iksaif.net>
    CC: acpi4asus-user@lists.sourceforge.net
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d94066910943837558d2a461c6766da981260bf0
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Apr 30 09:35:47 2009 -0600

    ACPI: battery: use .notify method instead of installing handler directly
    
    This patch adds a .notify() method.  The presence of .notify() causes
    Linux/ACPI to manage event handlers and notify handlers on our behalf,
    so we don't have to install and remove them ourselves.
    
    This driver apparently relies on seeing ALL notify events, not just
    device-specific ones (because it used ACPI_ALL_NOTIFY).  We use the
    ACPI_DRIVER_ALL_NOTIFY_EVENTS driver flag to request all events.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    CC: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 48fe112744d1ff2e899a6491633ac58a3229aabf
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Apr 30 09:35:42 2009 -0600

    ACPI: ac: use .notify method instead of installing handler directly
    
    This patch adds a .notify() method.  The presence of .notify() causes
    Linux/ACPI to manage event handlers and notify handlers on our behalf,
    so we don't have to install and remove them ourselves.
    
    This driver apparently relies on seeing ALL notify events, not just
    device-specific ones (because it used ACPI_ALL_NOTIFY).  We use the
    ACPI_DRIVER_ALL_NOTIFY_EVENTS driver flag to request all events.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    CC: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6d2781310036a8d3fa2b590a6f83a298010fd64a
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Apr 30 09:35:37 2009 -0600

    ACPI: allow drivers to request both device and system notify events
    
    System notify events (0x00-0x7f) are common across all device types
    and should be handled in Linux/ACPI, not in drivers.  However, some
    BIOSes use system notify events in device-specific ways that require
    the driver to be involved.
    
    This patch adds a ACPI_DRIVER_ALL_NOTIFY_EVENTS driver flag.  When a
    driver sets this flag and supplies a .notify method, Linux/ACPI calls
    the .notify method for ALL notify events on the device, not just the
    device-specific (0x80-0xff) events.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 871043bc463e7d191e7b5b00436a8852921dd833
Author: Matthew Garrett <mjg@redhat.com>
Date:   Mon Jun 1 15:25:45 2009 +0100

    hp-wmi: Add support for reporting tablet state
    
    HP tablets send a WMI event when a tablet state change occurs, but use the
    same method as is used for reporting docking and undocking. The same query
    is used to obtain the state of the hardware. Bit 0 indicates the docking
    state, while bit 2 indicates the tablet state. This patch breaks these out
    and sends separate input events for tablet and dock state changes. An
    additional sysfs file is added to report the tablet state.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit db18b040af6571a7eeed9e1adc2e92c9c87e4b1a
Author: Matthew Garrett <mjg@redhat.com>
Date:   Wed Jun 10 19:40:48 2009 +0000

    dell-wmi: don't generate errors on empty messages
    
    There's no point in generating kernel messages if we didn't receive a
    parsable keyboard event - only do so if there appeared to be a scancode.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5cab0098171712a9fd51399b06181c8dfdebe9c9
Author: Mario Limonciello <mario_limonciello@dell.com>
Date:   Wed Jun 10 19:40:47 2009 +0000

    dell-wmi: add additional keyboard events
    
    Upcoming Dell hardware will send more keyboard events via WMI.  Add
    support for them.
    
    Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 75d71c40dde5a9474c09ee291df22d50a1215bef
Author: Mario Limonciello <mario_limonciello@dell.com>
Date:   Wed Jun 10 19:40:46 2009 +0000

    dell-wmi: mask off upper bytes of event response
    
    In debugging with some future machines that actually contain BIOS level
    support for dell-wmi, I've determined that the upper half of the data that
    comes back from wmi_get_event_data may sometimes contain extra information
    that isn't currently relevant when pulling scan codes out of the data.
    This causes dell-wmi to improperly respond to these events.
    
    Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7fe2a6c275a5bcec52fb3ef643daaf8265b7af0d
Author: Alexander Chiang <achiang@hp.com>
Date:   Wed Jun 10 19:56:05 2009 +0000

    ACPI: kill acpi_get_physical_pci_device()
    
    acpi_get_pci_dev() is (hopefully) better, and all callers have been
    converted, so let's get rid of this duplicated functionality.
    
    Cc: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1e4cffe78e1decd937c7b78410eec87da6b87954
Author: Alexander Chiang <achiang@hp.com>
Date:   Wed Jun 10 19:56:00 2009 +0000

    ACPI: video: convert to acpi_get_pci_dev
    
    Now that acpi_get_pci_dev is available, let's use it instead of
    acpi_get_physical_pci_device()
    
    Cc: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 80ffdedf6020a77adcd06c01cfe6c488312b28f8
Author: Alexander Chiang <achiang@hp.com>
Date:   Wed Jun 10 19:55:55 2009 +0000

    ACPI: kill acpi_get_pci_id
    
    acpi_get_pci_dev() is better, and all callers have been converted, so
    eliminate acpi_get_pci_id().
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d6aa484c1c0cd39ff3a42f4050b55d2a5b285ef5
Author: Alexander Chiang <achiang@hp.com>
Date:   Wed Jun 10 19:55:50 2009 +0000

    PCI Hotplug: acpiphp: convert to acpi_get_pci_dev
    
    Now that acpi_get_pci_dev is available, let's use it instead of
    acpi_get_pci_id.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 97719a8726fe8d3ea12a85fbf4f514a915ba30ec
Author: Alexander Chiang <achiang@hp.com>
Date:   Wed Jun 10 19:55:45 2009 +0000

    ACPI: acpi_pci_unbind should clean up properly after acpi_pci_bind
    
    In acpi_pci_bind, we set device->ops.bind and device->ops.unbind, but
    never clear them out.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d9efae3688addb15994c9ad9761dada6f988bc14
Author: Alexander Chiang <achiang@hp.com>
Date:   Wed Jun 10 19:55:40 2009 +0000

    ACPI: simplify acpi_pci_irq_del_prt() API
    
    There is no need to pass a segment/bus tuple to this API, as the callsite
    always has a struct pci_bus. We can derive segment/bus from the
    struct pci_bus, so let's take this opportunit to simplify the API and
    make life easier for the callers.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 859a3f86ca83346f4097e956d0b27d96aa7a1cff
Author: Alexander Chiang <achiang@hp.com>
Date:   Wed Jun 10 19:55:35 2009 +0000

    ACPI: simplify acpi_pci_irq_add_prt() API
    
    A PCI domain cannot change as you descend down subordinate buses, which
    makes the 'segment' argument to acpi_pci_irq_add_prt() useless.
    
    Change the interface to take a struct pci_bus *, from whence we can derive
    the bus number and segment. Reducing the number of arguments makes life
    simpler for callers.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 499650de6906722184b639989b47227a362b62f8
Author: Alexander Chiang <achiang@hp.com>
Date:   Wed Jun 10 19:55:30 2009 +0000

    ACPI: eviscerate pci_bind.c
    
    Now that we can dynamically convert an ACPI CA handle to a
    struct pci_dev at runtime, there's no need to statically bind
    them during boot.
    
    acpi_pci_bind/unbind are vastly simplified, and are only used
    to evaluate _PRT methods on P2P bridges and non-bridge children.
    
    This patch also changes the time-space tradeoff ever so slightly.
    
    Looking up the ACPI-PCI binding is never in the performance path, and by
    eliminating this caching, we save 24 bytes for each _ADR device in the
    ACPI namespace.
    
    This patch lays further groundwork to eventually eliminate
    the acpi_driver_ops.bind callback.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c22d7f5a389dad15de448b142f44e4000b3426f0
Author: Alexander Chiang <achiang@hp.com>
Date:   Wed Jun 10 19:55:25 2009 +0000

    ACPI: rearrange acpi_pci_bind/acpi_pci_unbind in pci_bind.c
    
    This is a pure code movement patch that does $subject in order
    to make the following patch easier to read and review.
    
    No functional change.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2f7bbceb5b6aa938024bb4dad93c410fa59ed3b9
Author: Alexander Chiang <achiang@hp.com>
Date:   Wed Jun 10 19:55:20 2009 +0000

    ACPI: Introduce acpi_get_pci_dev()
    
    Convert an ACPI CA handle to a struct pci_dev.
    
    Performing this lookup dynamically allows us to get rid of the
    ACPI-PCI binding code, which:
    
    	- eliminates struct acpi_device vs struct pci_dev lifetime issues
    	- lays more groundwork for eliminating .start from acpi_device_ops
    	  and thus simplifying ACPI drivers
    	- whacks out a lot of code
    
    This change lays the groundwork for eliminating much of pci_bind.c.
    
    Although pci_root.c may not be the most logical place for this
    change, putting it here saves us from having to export acpi_pci_find_root.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 275582031f9b3597a1b973f3ff617adfe639faa2
Author: Alexander Chiang <achiang@hp.com>
Date:   Wed Jun 10 19:55:14 2009 +0000

    ACPI: Introduce acpi_is_root_bridge()
    
    Returns whether an ACPI CA node is a PCI root bridge or not.
    
    This API is generically useful, and shouldn't just be a hotplug function.
    
    The implementation becomes much simpler as well.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ce597bb42aa84bc73db80509b7c37e7fbc0b75c4
Author: Alexander Chiang <achiang@hp.com>
Date:   Wed Jun 10 19:55:09 2009 +0000

    ACPI: make acpi_pci_bind() static
    
    acpi_pci_root_add() explicitly assigns device->ops.bind, and later
    calls acpi_pci_bind_root(), which also does the same thing.
    
    We don't need to repeat ourselves; removing the explicit assignment
    allows us to make acpi_pci_bind() static.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0c526d96a5bd86c70507b7d9372e6a26a1e3ea43
Author: Alex Chiang <achiang@hp.com>
Date:   Thu May 14 08:31:37 2009 -0600

    ACPI: clean up whitespace in drivers/acpi/scan.c
    
    Align labels in column 0, adjust spacing in 'if' statements, eliminate
    trailing and superfluous whitespaces.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8b12b922ed5b9b6bfc345d3d6c6de56b2982af7f
Author: Alex Chiang <achiang@hp.com>
Date:   Thu May 14 08:31:32 2009 -0600

    ACPI: acpi_device_register() should call device_register()
    
    There is no apparent reason for acpi_device_register() to manually
    register a new device in two steps (initialize then add).
    
    Just call device_register() directly.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8bf3d4c535c2b9689c2979b281c24e9f59c2f4ad
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat May 30 13:25:09 2009 -0300

    thinkpad-acpi: silence bogus warning when ACPI video is disabled
    
    Make use of acpi_video_backlight_support() also in hotkey_init, to make
    sure this doesn't happen:
    
    thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness
                   control, supported by the ACPI video driver
    thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
    thinkpad_acpi: Standard ACPI backlight interface not available,
                   thinkpad_acpi native brightness control enabled
    thinkpad_acpi: detected a 16-level brightness capable ThinkPad
    
    Note that this is purely cosmetic, there is absolutely _no_ change in
    behaviour.  Those events are sometimes enabled at runtime by userspace, but
    the driver never enables them by itself unless someone messed with the
    default keymaps.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Reported-by: Jochen Schulz <jrschulz@well-adjusted.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f21179a47ff8d1046a61c1cf5920244997a4a7bb
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat May 30 13:25:08 2009 -0300

    thinkpad-acpi: enhance led support
    
    Add support for extra LEDs on recent ThinkPads, and avoid registering
    with the led class the LEDs which are not available for a given
    ThinkPad model.
    
    All non-restricted LEDs are always available through the procfs
    interface, as the firmware doesn't care if an attempt is made to
    access an invalid LED.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 60201732f03c1231742e5872abe55a3bf59849a5
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat May 30 13:25:07 2009 -0300

    thinkpad-acpi: fix BEEP ACPI handler warnings
    
    Some ThinkPads want two arguments for BEEP, while others want just
    one, causing ACPICA to log warnings like this:
    
    ACPI Warning (nseval-0177): Excess arguments - method [BEEP] needs 1,
    found 2 [20080926]
    
    Deal with it.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7d95a3d564901e88ed42810f054e579874151999
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat May 30 13:25:06 2009 -0300

    thinkpad-acpi: add quirklist engine
    
    Add a quirklist engine suitable for matching ThinkPad firmware,
    and change the code to use it.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 050df107c408a3df048524b3783a5fc6d4dccfdb
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat May 30 13:25:05 2009 -0300

    thinkpad-acpi: store fw version with strict checking
    
    Extend the thinkpad model and firmware identification data with the
    release serial number for the BIOS and firmware (when available), as
    that is easier to parse and compare than the version strings.
    
    We're going to greatly extend the use of the ThinkPad DMI data through
    quirk lists, so it is best to be quite strict and make sure what we
    get from DMI is exactly what we expect, otherwise quirk matching may
    result in quite insane things.
    
    IBM (and Lenovo, at least for the ThinkPad line) uses this schema for
    firmware versioning and model:
    
    Firmware model: Two digits, [0-9A-Z]
    
    Firmware version: AABBCCDD, where
      AA = firmware model, see above
      BB = "ET" for BIOS, "HT" for EC
      CC = release version, two digits, [0-9A-Z],
           "00" < "09" < "0A" < "10" < "A0" < "ZZ"
      DD = "WW"
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ab46feae865c5b96dbf5e261be8638165932bfb1
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jun 12 20:47:50 2009 -0400

    ACPI: #define acpi_disabled 1 for CONFIG_ACPI=n
    
    SFI will need to test acpi_disabled no matter
    the value of CONFIG_ACPI.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4a7a16dc061e4c57bf288150f51bd4c2ace33723
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jun 12 20:42:08 2009 -0400

    ACPI: move declaration acpi_early_init() to acpi.h
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c4bf2f372db09ef8d16a25a60d523bfa1c50f7b5
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jun 11 23:53:55 2009 -0400

    ACPI, PCI, x86: move MCFG parsing routine from ACPI to PCI file
    
    Move
    arch/x86/kernel/acpi/boot.c: acpi_parse_mcfg()
    to
    arch/x86/pci/mmconfig-shared.c: pci_parse_mcfg()
    where it is used, and make it static.
    
    Move associated globals and helper routine with it.
    
    No functional change.
    
    This code move is in preparation for SFI support,
    which will allow the PCI code to find the MCFG table
    on systems which do not support ACPI.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 24c5c4c2f506bf87ef2343669fb892c944c3fdde
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu May 21 16:25:35 2009 +0800

    ACPI: increase size of acpi_bus_id[]
    
    Previously [5], now [8].
    
    sprintf(acpi_device_bid(device), "CPU%X", cpu_id)
    now looks better on systems with more than 0xFF processors.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d023e49118b9c93bbab9aaf798b25f78f1a5803c
Author: Olivier Berger <oberger@ouvaton.org>
Date:   Thu May 21 16:07:38 2009 +0200

    ACPI: Remove Asus P4B266 from blacklist
    
    See http://marc.info/?l=linux-acpi&m=124068823904429&w=2 for discussion
    
    Signed-off-by: Olivier Berger <oberger@ouvaton.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c636f753b5b943f08fb3490e7f1a9b47aa5cc7d3
Author: Len Brown <len.brown@intel.com>
Date:   Tue May 19 23:47:38 2009 -0400

    ACPI: delete dead acpi_disabled setting code
    
    Testing CONFIG_ACPI inside boot.c is a waste of text,
    since boot.c is built only when CONFIG_ACPI=y
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ee1ca48fae7e575d5e399d4fdcfe0afc1212a64c
Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Date:   Thu May 21 17:09:10 2009 -0700

    ACPI: Disable ARB_DISABLE on platforms where it is not needed
    
    ARB_DISABLE is a NOP on all of the recent Intel platforms.
    
    For such platforms, reduce contention on c3_lock
    by skipping the fake ARB_DISABLE.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 113b3a2b901573961509e81a28e9546cf9defef0
Author: Len Brown <len.brown@intel.com>
Date:   Wed May 27 21:46:11 2009 -0400

    ACPI: delete acpi.power_nocheck from kernel-parameters.txt
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bdf43bbf2e19952d82995a50e00cb4b66afa4f0c
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu May 21 17:28:53 2009 -0600

    ACPI: don't check power state after _ON/_OFF
    
    We used to evaluate _STA to check the power state of a device after
    running _ON or _OFF.  But as far as I can tell, there's no benefit
    to evaluating _STA, and sometimes we trip over bugs when BIOSes don't
    implement _STA correctly.
    
    Yakui says Windows XP doesn't evaluate _STA during power transition.
    So let's skip it in Linux, too.  It's conceivable that we'll need to
    check _STA in the future for some reason, but until we do, I don't
    see a reason to clutter this code path.
    
    References:
        http://bugzilla.kernel.org/show_bug.cgi?id=13243
        http://marc.info/?l=linux-acpi&m=124166053803753&w=2
        http://marc.info/?l=linux-acpi&m=124175761408256&w=2
        http://marc.info/?l=linux-acpi&m=124210593114061&w=2
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-by: Matthew Garrett <mjg59@srcf.ucam.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8cb24c8fd70ea8431744de1ca0ca34ab45fbbdaa
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu May 21 15:49:59 2009 -0600

    PNPACPI: parse Extended Address Space Descriptors
    
    Extended Address Space Descriptors are new in ACPI 3.0 and allow the
    BIOS to communicate device resource cacheability attributes (write-back,
    write-through, uncacheable, etc) to the OS.
    
    Previously, PNPACPI ignored these descriptors, so if a BIOS used them,
    a device could be responding at addresses the OS doesn't know about.
    This patch adds support for these descriptors in _CRS and _PRS.  We
    don't attempt to encode them for _SRS (just like we don't attempt to
    encode the existing 16-, 32-, and 64-bit Address Space Descriptors).
    
    Unfortunately, I don't have a way to test this.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9eccbc2f67efd0d19c47f40182abf2965c287add
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 27 16:33:46 2009 -0600

    ACPI: processor: move device _HID into driver
    
    The ACPI0007 _HID used for processor "Device" objects in the namespace
    is not needed outside the processor driver, so move it there.  Also, the
    #define is only used once, so just remove it and hard-code "ACPI0007".
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6cc73b4806c07b4207780f6d85c456b4c5b29d71
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 27 16:33:41 2009 -0600

    ACPI: processor: check for synthetic _HID, default to "Device" declaration
    
    This patch inverts the logic that distinguishes "Processor" statements
    from "Device" statements, so we now check explicitly for "Processor" and
    default to "Device".  This removes the only real use of ACPI_PROCESSOR_HID,
    so we can then remove the #define.  It also has the theoretical advantage
    that if a new processor _HID were ever added, we wouldn't have to change
    the code here.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b9417f84e17b93a6976a8a88b38bf9567975cb38
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 27 16:33:36 2009 -0600

    ACPI: use LNXCPU, not ACPI_CPU, for Linux-specific processor _HID
    
    ACPI_PROCESSOR_OBJECT_HID is a synthetic _HID that Linux generates
    for "Processor" definitions.  Unlike "Device" definitions, "Processor"
    definitions do not have a _HID in the namespace, so we generate a
    fake _HID.  By convention, all these fake _HIDs begin with "LNX".
    
    This does change the user-visible _HID for "Processor" objects --
    previously, we used "ACPI_CPU" and this changes that to "LNXCPU",
    which starts with "LNX" as do all the other made-up _HIDs.  This
    change is visible in processor filenames and "hid" files under
    /sys/devices/LNXSYSTM:00/.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

--Boundary_(ID_LP78dORrJ4g5/jqY0TuXgg)--
