Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXGYQjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXGYQjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764836AbXGYQi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:38:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:35234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764000AbXGYQi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:38:57 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCH] ACPI patches for 2.6.23-rc1
Date: Wed, 25 Jul 2007 12:38:50 -0400
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251238.50218.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Fixes regressions -- a build failure, an oops, some dmesg spam.
Also fixes some D-state issues and adds ACPI module auto-loading.
Yes, I'd hoped to get the last two in before rc1.
I'm hopeful that a couple-days into rc2 is sufficiently early for them.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.23/acpi-release-20070126-2.6.23-rc1.diff.gz

 arch/i386/kernel/acpi/Makefile      |    2 
 arch/i386/kernel/setup.c            |    2 
 arch/i386/mm/init.c                 |    2 
 arch/ia64/kernel/acpi.c             |   19 ++
 arch/x86_64/kernel/acpi/Makefile    |    2 
 arch/x86_64/kernel/acpi/sleep.c     |    4 
 arch/x86_64/kernel/head.S           |    2 
 arch/x86_64/kernel/setup.c          |    2 
 drivers/acpi/Kconfig                |   64 +++------
 drivers/acpi/ac.c                   |    9 +
 drivers/acpi/acpi_memhotplug.c      |    8 +
 drivers/acpi/asus_acpi.c            |   11 +
 drivers/acpi/battery.c              |    9 +
 drivers/acpi/button.c               |   12 +
 drivers/acpi/container.c            |   10 +
 drivers/acpi/ec.c                   |    8 -
 drivers/acpi/events/evrgnini.c      |    2 
 drivers/acpi/fan.c                  |    8 +
 drivers/acpi/namespace/nsxfeval.c   |    2 
 drivers/acpi/pci_link.c             |    9 +
 drivers/acpi/pci_root.c             |    9 +
 drivers/acpi/power.c                |    8 +
 drivers/acpi/processor_core.c       |    8 +
 drivers/acpi/processor_throttling.c |   59 ++++++--
 drivers/acpi/sbs.c                  |   10 +
 drivers/acpi/scan.c                 |  156 ++++++++++++++++-------
 drivers/acpi/sleep/Makefile         |    4 
 drivers/acpi/sleep/main.c           |  162 +++++++++++++++++++-----
 drivers/acpi/sleep/poweroff.c       |    2 
 drivers/acpi/sleep/proc.c           |   20 ++
 drivers/acpi/sleep/wakeup.c         |    2 
 drivers/acpi/thermal.c              |    8 +
 drivers/acpi/utilities/uteval.c     |    4 
 drivers/acpi/video.c                |    8 +
 drivers/char/hpet.c                 |    8 +
 drivers/input/misc/atlas_btns.c     |    9 +
 drivers/misc/asus-laptop.c          |   41 ++++--
 drivers/misc/sony-laptop.c          |   21 ++-
 drivers/misc/thinkpad_acpi.c        |   20 ++
 drivers/misc/thinkpad_acpi.h        |    2 
 drivers/pci/pci-acpi.c              |   28 +++-
 drivers/pci/pci.c                   |    8 -
 drivers/pci/pci.h                   |    2 
 drivers/pnp/driver.c                |    5 
 drivers/pnp/pnpacpi/core.c          |   33 +++-
 include/acpi/acpi_bus.h             |    7 -
 include/acpi/acpi_drivers.h         |   25 +--
 include/acpi/actypes.h              |    6 
 include/acpi/acutils.h              |    4 
 include/asm-i386/acpi.h             |   23 +--
 include/asm-i386/suspend.h          |    2 
 include/asm-ia64/acpi.h             |    5 
 include/asm-x86_64/acpi.h           |   22 +--
 include/asm-x86_64/suspend.h        |    2 
 include/linux/acpi.h                |    1 
 include/linux/mod_devicetable.h     |    6 
 include/linux/pnp.h                 |    4 
 kernel/sysctl.c                     |    2 
 scripts/mod/file2alias.c            |   12 +
 59 files changed, 668 insertions(+), 277 deletions(-)

through these commits:

Al Viro (1):
      ACPI: asus-laptop: Fix failure exits

Len Brown (5):
      ACPI: Kconfig: CONFIG_ACPI_PROCFS now defaults to N
      ACPI: Kconfig: fold /proc/acpi/sleep under CONFIG_ACPI_PROCFS
      ACPI: Kconfig: always enable CONFIG_ACPI_SLEEP on X86
      ACPI: quiet ACPI Exceptions due to no _PTC or _TSS
      ACPI: Kconfig: remove CONFIG_ACPI_SLEEP from source

Luming Yu (1):
      ACPI: fix oops due to typo in new throttling code

Rafael J. Wysocki (2):
      ACPI: Implement the set_target() callback from pm_ops
      ACPI: Remove references to ACPI_STATE_S2 from acpi_pm_enter

Shaohua Li (4):
      ACPI: Add acpi_pm_device_sleep_state helper routine
      ACPI, PNP: hook ACPI D-state to PNP suspend/resume
      ACPI: Use ACPI methods to select PCI device suspend state
      ACPI: ignore _PSx method for hotplugable PCI devices

Thomas Renninger (3):
      ACPI: autoload modules - ACPICA modifications
      ACPI: autoload modules - Create ACPI alias interface
      ACPI: autoload modules - Create __mod_acpi_device_table symbol for all ACPI drivers

with this log:

commit 323ef30af3a0da47cc761b04b262d98d0fe79126
Merge: cb3e0c1... 1ba90e3...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jul 25 01:36:53 2007 -0400

    Pull auto-load-modules into release branch

commit cb3e0c107bebc6cf3e7158f7aa54c32017c7d4c4
Merge: 1e1f3f2... 50ad147...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jul 25 01:36:31 2007 -0400

    Pull d-states into release branch
    
    Conflicts:
    
    	drivers/acpi/sleep/main.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1e1f3f24cdbc53e67acd7b2e37e6cf0cb11bd13c
Merge: c30c620... e8b2fd0...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jul 25 01:35:25 2007 -0400

    Pull kconfig into release branch

commit e8b2fd01228f690c3e0cb3f14facfa8d93d4adae
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jul 24 22:26:33 2007 -0400

    ACPI: Kconfig: remove CONFIG_ACPI_SLEEP from source
    
    As it was a synonym for (CONFIG_ACPI && CONFIG_X86),
    the ifdefs for it were more clutter than they were worth.
    
    For ia64, just add a few stubs in anticipation of future
    S3 or S4 support.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c30c620ee1cc351bcc149c4280e1166998df0064
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jul 25 00:57:46 2007 -0400

    ACPI: quiet ACPI Exceptions due to no _PTC or _TSS
    
    ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
    ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
    
    These methods are optional, so Linux should not
    alarm users when they are not found.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8802
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Acked-by: Luming Yu <luming.yu@intel.com>

commit 50ad147aa09c829cd452fae6ca99396c0b5b0695
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jul 24 11:58:39 2007 +0200

    ACPI: Remove references to ACPI_STATE_S2 from acpi_pm_enter
    
    Remove references to ACPI_STATE_S2, introduced by
    acpi-implement-the-set_target-callback-from-pm_ops.patch, from acpi_pm_enter().
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7c5aa6642fa26641ebf286966a165aec71c91991
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jul 24 02:25:03 2007 -0400

    ACPI: Kconfig: always enable CONFIG_ACPI_SLEEP on X86
    
    The SMP dependency on HOTPLUG_CPU and SUSPEND_SMP
    caused more harm than good -- making ACPI sleep
    support vanish for configs missing those options.
    So simply select them on the (ACPI && SMP && X86) systems
    that need them.
    
    Also, remove the prompt for ACPI_SLEEP,
    virtually nobody (intentionally) enables ACPI without it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 43532c8a46ae313c2da3baa7598a1de4d403ba83
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jul 24 02:16:50 2007 -0400

    ACPI: Kconfig: fold /proc/acpi/sleep under CONFIG_ACPI_PROCFS
    
    /proc/acpi/sleep has had its own "default n" option,
    ACPI_SLEEP_PROC_SLEEP, for many months.
    Time to delete ACPI_SLEEP_PROC_SLEEP.
    
    Users that still need /proc/acpi/sleep can still get it
    along with the other deprecated /proc/acpi files
    by enabling CONFIG_ACPI_PROCFS.
    
    Also delete ACPI_SLEEP_PROC_FS, which was an umbrella
    for /proc/acpi/sleep, wakeup, alarm, because it was
    effectively just a synonym for ACPI_SLEEP.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fb804714560463534ebcb538a3b0a3c687a830ec
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jul 24 01:50:46 2007 -0400

    ACPI: Kconfig: CONFIG_ACPI_PROCFS now defaults to N
    
    delete "default y" from CONFIG_ACPI_PROCFS
    (effectively making the default 'N')
    
    List exactly what /proc files this option controls,
    and clarify that it doesn't change non-deprecated files.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1ba90e3a87c46500623afdc3898573e4a5ebb21b
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Jul 23 14:44:41 2007 +0200

    ACPI: autoload modules - Create __mod_acpi_device_table symbol for all ACPI drivers
    
    modpost is going to use these to create e.g. acpi:ACPI0001
    in modules.alias.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 29b71a1ca74491fab9fed09e9d835d840d042690
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Jul 23 14:43:51 2007 +0200

    ACPI: autoload modules - Create ACPI alias interface
    
    Modify modpost (file2alias.c) to add acpi*:XYZ0001: alias in modules.alias
    like:
    grep acpi /lib/modules/2.6.22-rc4-default/modules.alias
    alias acpi*:SNY5001:* sony_laptop
    alias acpi*:SNY6001:* sony_laptop
    for e.g. the sony_laptop module.
    This module matches against all ACPI devices with a HID or CID of SNY5001
    or SNY6001
    
    Export an uevent and modalias sysfs file containing the string:
    [MODALIAS=]acpi:PNP0C0C:
    additional CIDs are concatenated at the end.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8c8eb78f673c07b60f31751e1e47ac367c60c6b7
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Jul 23 14:43:32 2007 +0200

    ACPI: autoload modules - ACPICA modifications
    
    Define standardized HIDs - Rename current acpi_device_id to acpica_device_id
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b0d71170d37878bbb1203ebc3f92e36d6151a80
Author: Al Viro <viro@ftp.linux.org.uk>
Date:   Mon Jul 23 11:21:34 2007 +0100

    ACPI: asus-laptop: Fix failure exits
    
    > Subject         : drivers/misc/asus-laptop.c:*: error: 'struct led_classdev' has no member named 'class_dev'
    > References      : http://lkml.org/lkml/2007/7/22/299
    > Submitter       : Gabriel C <nix.or.die@googlemail.com>
    
    Fallout from f8a7c6fe14f556ca8eeddce258cb21392d0c3a2f.  However, looking
    at it shows that checks done in ASUS_LED_UNREGISTER() can't trigger
    at all (we never get to asus_led_exit() if registration fails) and
    if that registration fails, we actually leak stuff.  IOW, it's worse
    than just replacing class_dev with dev in there - the tests themselves
    had been papering over the lousy cleanup logics.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3cc2649b879f0e83fd51b14c82bad5f8f208591e
Author: Luming Yu <luming.yu@gmail.com>
Date:   Mon Jul 23 12:39:28 2007 -0400

    ACPI: fix oops due to typo in new throttling code
    
    Signed-off-by: Luming Yu <luming.yu@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 10b3dcae0f275e2546e55303d64ddbb58cec7599
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Fri Jul 20 10:03:25 2007 +0800

    ACPI: ignore _PSx method for hotplugable PCI devices
    
    If the ACPI device has _EJ0, ignore the device.
    _PSx will set power for the slot,
    and the hotplug driver will take care of _PSx.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ab826ca4cf2fe8ebcfd21189ca8bfeb47ca88359
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Fri Jul 20 10:03:22 2007 +0800

    ACPI: Use ACPI methods to select PCI device suspend state
    
    applied after Rafel's 'PM: Update global suspend and hibernation
    operations framework' patch set
    
    Signed-off-by: Shaohua Li<shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fc30e68e88baf463683bde43347756889ba2ffae
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Fri Jul 20 10:03:20 2007 +0800

    ACPI, PNP: hook ACPI D-state to PNP suspend/resume
    
    applied after Rafel's 'PM: Update global suspend and hibernation operations framework' patch set
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fd4aff1a28eecbd729b409bf7d3eff5948f20414
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Tue Jul 17 22:40:25 2007 +0200

    ACPI: Add acpi_pm_device_sleep_state helper routine
    
    Based on the David Brownell's patch at
    http://marc.info/?l=linux-acpi&m=117873972806360&w=2
    updated by: Rafael J. Wysocki <rjw@sisk.pl>
    
    Add a helper routine returning the lowest power (highest number) ACPI device
    power state that given device can be in while the system is in the sleep state
    indicated by acpi_target_sleep_state .
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e9b3aba887f47f9cd64de20fec9c333a932b70dc
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jul 17 22:40:06 2007 +0200

    ACPI: Implement the set_target() callback from pm_ops
    
    In the future some drivers may need to use ACPI to determine the low power
    states in which to place their devices, but to provide the drivers with this
    information the ACPI core needs to know what sleep state the system is going to
    enter.  Namely, the device's state should not be too high power for given system
    sleep state and, if the device is supposed to be able to wake up the system, its
    state should not be too low power for the wake up to be possible).  For this
    purpose, the ACPI core needs to implement the set_target() method in 'struct
    pm_ops' and store the target system sleep state passed by the PM core in a
    variable.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Acked-by: David Brownell <david-b@pacbell.net>
    Signed-off-by: Len Brown <len.brown@intel.com>
