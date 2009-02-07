Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZBGG76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZBGG76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 01:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZBGG7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 01:59:47 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:20642 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZBGG7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 01:59:45 -0500
Date: Sat, 07 Feb 2009 01:59:36 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull] ACPI patches for 2.6.29-rc3
Message-id: <alpine.LFD.2.00.0902070148440.26256@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

...A couple of regression fixes, a couple of cleanups,
and a couple of patches that I meant to send earlier.

Nothing too Earth-shaking.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.29/acpi-release-20090123-2.6.29-rc3.diff.gz

 Documentation/cpu-freq/user-guide.txt   |   16 -
 arch/x86/kernel/acpi/sleep.c            |    4 +-
 arch/x86/kernel/cpu/cpufreq/Kconfig     |   11 -
 drivers/acpi/Kconfig                    |    3 +-
 drivers/acpi/acpica/tbutils.c           |    7 +-
 drivers/acpi/acpica/uteval.c            |   21 +-
 drivers/acpi/container.c                |    5 +-
 drivers/acpi/dock.c                     |   14 +-
 drivers/acpi/ec.c                       |    2 +-
 drivers/acpi/glue.c                     |    8 +-
 drivers/acpi/osl.c                      |   54 +++-
 drivers/acpi/pci_link.c                 |    2 +-
 drivers/acpi/processor_idle.c           |  667 +------------------------------
 drivers/acpi/processor_perflib.c        |  105 -----
 drivers/acpi/sleep.c                    |   53 ++--
 drivers/acpi/tables.c                   |    7 +-
 drivers/acpi/video.c                    |   16 +-
 drivers/platform/x86/Kconfig            |    1 +
 drivers/platform/x86/asus-laptop.c      |  176 ++++++++-
 drivers/platform/x86/asus_acpi.c        |   16 +-
 drivers/platform/x86/eeepc-laptop.c     |  164 +++++++-
 drivers/platform/x86/panasonic-laptop.c |    2 +-
 include/acpi/pdc_intel.h                |    2 +
 kernel/power/main.c                     |   26 +-
 24 files changed, 481 insertions(+), 901 deletions(-)

through these commits:

Corentin Chary (7):
      eeepc-laptop: split eeepc_backlight_exit()
      asus_acpi: Add R1F support
      asus-laptop: use generic netlink interface
      asus-laptop: hotkeys via the generic input interface
      asus-laptop: update Kconfig for input layer
      asus-laptop: fix label indentation
      eeepc-laptop: use netlink interface

Darren Salt (1):
      eeepc-laptop: fix oops when changing backlight brightness during eeepc-laptop init

Frank Seidel (1):
      ACPI: add missing KERN_* constants to printks

Holger Macht (1):
      ACPI: dock: Don't eval _STA on every show_docked sysfs read

Kay Sievers (1):
      ACPI: struct device - replace bus_id with dev_name(), dev_set_name()

Len Brown (6):
      ACPI: remove locking from PM1x_STS register reads
      ACPI: remove BM_RLD access from idle entry path
      ACPICA: add debug dump of BIOS _OSI strings
      ACPI: make some IO ports off-limits to AML
      ACPI: delete CPU_IDLE=n code
      ACPI: disable ACPI cleanly when bad RSDP found

Matthew Garrett (3):
      eeepc-laptop: Add support for extended hotkeys
      eeepc-laptop: Check return values from rfkill_register
      eeepc-laptop: Implement rfkill hotplugging in eeepc-laptop

Myron Stowe (1):
      ACPICA: Fix table entry truncation calculation

Pallipadi, Venkatesh (1):
      ACPI: Enable bit 11 in _PDC to advertise hw coord

Rafael J. Wysocki (2):
      PM: Fix compilation warning in kernel/power/main.c
      ACPI suspend: Fix compilation warnings in drivers/acpi/sleep.c

Roel Kluin (1):
      panasonic-laptop: fix X[ ARRAY_SIZE(X) ]

Tero Roponen (1):
      ACPI: Fix crash on ASUS laptops

Thierry Vignaud (1):
      ACPI: Kconfig text - Fix the ACPI_CONTAINER module name according to the real module name.

Thomas Renninger (1):
      ACPI: cpufreq: Remove deprecated /proc/acpi/processor/../performance proc entries

Zhao Yakui (2):
      ACPI: Skip the first two elements in the _BCL package
      ACPI: proc_dir_entry 'video/VGA' already registered

with this log:

commit 2d29c6a075787f2c1bc49b86a084d2b878f72fc4
Merge: 2b25c9f... 0a3db1c... 9fdd54f... 5ec5d38... 4312495... 370154b... 4d93915... 62663ea...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 7 01:34:56 2009 -0500

    Merge branches 'release', 'asus', 'bugzilla-12450', 'cpuidle', 'debug', 'ec', 'misc', 'printk' and 'processor' into release

commit 370154bbefb627cb5f987f5646284755c7684bc8
Author: Thierry Vignaud <tvignaud@mandriva.com>
Date:   Sat Feb 7 01:12:19 2009 -0500

    ACPI: Kconfig text - Fix the ACPI_CONTAINER module name according to the real module name.
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7695fb04aca62e2d8a7ca6ede50f6211e1d71e53
Author: Darren Salt <linux@youmustbejoking.demon.co.uk>
Date:   Sat Feb 7 01:02:07 2009 -0500

    eeepc-laptop: fix oops when changing backlight brightness during eeepc-laptop init
    
    I got the following oops while changing the backlight brightness during
    startup.  When it happens, it prevents use of the hotkeys, Fn-Fx, and the
    lid button.
    
    It's a clear use-before-init, as I verified by testing with an
    appropriately-placed "else printk".
    
    BUG: unable to handle kernel NULL pointer dereference at 00000000
    *pde = 00000000
    Oops: 0002 [#1] PREEMPT SMP
    Pid: 160, comm: kacpi_notify Not tainted (2.6.28.1-eee901 #4) 901
    EIP: 0060:[<c0264e68>]  [<c0264e68>] eeepc_hotk_notify+26/da
    EFLAGS: 00010246 CPU: 1
    Using defaults from ksymoops -t elf32-i386 -a i386
    EAX: 00000009 EBX: 00000000 ECX: 00000009 EDX: f70dbf64
    ESI: 00000029 EDI: f7335188 EBP: c02112c9 ESP: f70dbf80
     DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
     f70731e0 f73acd50 c02164ac f7335180 f70aa040 c02112e6 f733518c c012b62f
     f70aa044 f70aa040 c012bdba f70aa04c 00000000 c012be6e 00000000 f70bdf80
     c012e198 f70dbfc4 f70dbfc4 f70aa040 c012bdba 00000000 c012e0c9 c012e091
    Call Trace:
     [<c02164ac>] ? acpi_ev_notify_dispatch+4c/55
     [<c02112e6>] ? acpi_os_execute_deferred+1d/25
     [<c012b62f>] ? run_workqueue+71/f1
     [<c012bdba>] ? worker_thread+0/bf
     [<c012be6e>] ? worker_thread+b4/bf
     [<c012e198>] ? autoremove_wake_function+0/2b
     [<c012bdba>] ? worker_thread+0/bf
     [<c012e0c9>] ? kthread+38/5f
     [<c012e091>] ? kthread+0/5f
     [<c0103abf>] ? kernel_thread_helper+7/10
    Code: 00 00 00 00 c3 83 3d 60 5c 50 c0 00 56 89 d6 53 0f 84 c4 00 00 00 8d 42
    e0 83 f8 0f 77 0f 8b 1d 68 5c 50 c0 89 d8 e8 a9 fa ff ff <89> 03 8b 1d 60 5c
    50 c0 89 f2 83 e2 7f 0f b7 4c 53 10 8d 41 01
    
    Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 386e4a8358239f90275e1f93d5ad11cdc93c6453
Author: Myron Stowe <myron.stowe@hp.com>
Date:   Fri Jan 30 15:44:53 2009 -0700

    ACPICA: Fix table entry truncation calculation
    
    During early boot, ACPI RSDT/XSDT table entries are gathered into the
    'initial_tables[]' array.  This array is currently statically defined (see
    ./drivers/acpi/tables.c).  When there are more table entries than can be
    held in the 'initial_tables[]' array, the message "Truncating N table
    entries!" is output.  As currently implemented, this message will always
    erroneously calculate N as 0.
    
    This patch fixes the calculation that determines how many table entries
    will be missing (truncated).
    
    This modification may be used under either the GPL or the BSD-style
    license used for Intel ACPI CA code.
    
    Signed-off-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d96f94c604453f87fe24154b87e1e9a3a72511f8
Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Date:   Mon Feb 2 11:57:18 2009 -0800

    ACPI: Enable bit 11 in _PDC to advertise hw coord
    
    Bit 11 in intel PDC definitions is meant for OS capability to handle
    hardware coordination of P-states. In Linux we have always supported
    hwardware coordination of P-states. Just let the BIOSes know that we
    support it, by setting this bit.
    
    Some BIOSes use this bit to choose between hardware or software coordination
    and without this change below, BIOSes switch to software coordination, which
    is not very optimal in terms of power consumption and extra wakeups from idle.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit db1461ad431f0fd21afcd8ea6594ae38fdc57759
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Sun Jan 25 23:40:56 2009 +0100

    ACPI: struct device - replace bus_id with dev_name(), dev_set_name()
    
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4d9391557b68475b118ec7626607c37b14ae8c16
Author: Frank Seidel <frank@f-seidel.de>
Date:   Wed Feb 4 17:03:07 2009 +0100

    ACPI: add missing KERN_* constants to printks
    
    According to kerneljanitors todo list all printk calls (beginning
    a new line) should have an according KERN_* constant.
    Those are the missing peaces here for the acpi subsystem.
    
    Signed-off-by: Frank Seidel <frank@f-seidel.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fc5a9f8841ee87d93376ada5d73117d4d6a373ea
Author: Holger Macht <hmacht@suse.de>
Date:   Tue Jan 20 12:18:24 2009 +0100

    ACPI: dock: Don't eval _STA on every show_docked sysfs read
    
    Some devices trigger a DEVICE_CHECK on every evalutation of _STA. This
    can also be seen in commit 8b59560a3baf2e7c24e0fb92ea5d09eca92805db
    (ACPI: dock: avoid check _STA method).  If an undock is processed, the
    dock driver sends a uevent and userspace might read the show_docked
    property in sysfs. This causes an evaluation of _STA of the particular
    device which causes the dock driver to immediately dock again.
    
    In any case, evaluation of _STA (show_docked) does not necessarily mean
    that we are docked, so check with the internal device structure.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=12360
    
    Signed-off-by: Holger Macht <hmacht@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9e3a9d1ed8cc8db93e5c53e9a5b09065bd95de8b
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 6 14:00:56 2009 -0500

    ACPI: disable ACPI cleanly when bad RSDP found
    
    When ACPI is disabled in the BIOS of this VIA C3 box,
    it invalidates the RSDP, which Linux notices:
    
    ACPI Error (tbxfroot-0218): A valid RSDP was not found [20080926]
    
    Bug Linux neglected to disable ACPI at that stage,
    and later scribbled on smp_found_config:
    
    ACPI: No APIC-table, disabling MPS
    
    But this box doesn't run well in legacy PIC mode,
    it needed IOAPIC mode to perform correctly:
    
    http://lkml.org/lkml/2009/2/5/39
    
    So exit ACPI mode cleanly when we first detect
    that it is hopeless.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9fdd54f206722ecee7fd7ba9dba26140450e7c32
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 6 12:24:17 2009 -0500

    ACPI: delete CPU_IDLE=n code
    
    CPU_IDLE=y has been default for ACPI=y since Nov-2007,
    and has shipped in many distributions since then.
    
    Here we delete the CPU_IDLE=n ACPI idle code, since
    nobody should be using it, and we don't want to
    maintain two versions.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 62663ea8220366472fe20462831f2d69d7987439
Author: Thomas Renninger <trenn@suse.de>
Date:   Tue Feb 3 17:46:46 2009 +0100

    ACPI: cpufreq: Remove deprecated /proc/acpi/processor/../performance proc entries
    
    They were long enough set deprecated...
    
    Update Documentation/cpu-freq/users-guide.txt:
    The deprecated files listed there seen not to exist for some time anymore
    already.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5ec5d38a1c8af255ffc481c81eef13e9155524b3
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 3 22:52:12 2009 -0500

    ACPI: make some IO ports off-limits to AML
    
    ACPICA exports acpi_os_validate_address() so the OS
    can prevent BIOS AML from accessing specified addresses.
    
    Start using this interface to prevent AML from accessing
    some well known IO addresses that the OS "owns".
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3e0676a9b699d12b2bd0a8807459ac4277b181fc
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 3 18:04:39 2009 -0500

    ACPICA: add debug dump of BIOS _OSI strings
    
    on boot, print out the OSI strings the BIOS uses to query the OS.
    
    To see this output...
    
    build with CONFIG_ACPI_DEBUG
    
    boot with
    "acpi.debug_level=4" (ACPI_LV_INFO) (enabled by default)
    and
    "acpi.debug_level=1" (ACPI_UTILITIES) (default is 0)
    
    example output:
    
    ACPI: BIOS _OSI(Windows 2001) supported
    ACPI: BIOS _OSI(Windows 2001 SP1) supported
    ACPI: BIOS _OSI(Windows 2001 SP2) supported
    ACPI: BIOS _OSI(Windows 2006) supported
    ACPI: BIOS _OSI(Linux) not-supported
    ACPI: BIOS _OSI(FreeBSD) not-supported
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f3b39f1393d5cebe56f43a584ef47efbebd2702c
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Feb 2 22:55:01 2009 -0500

    ACPI: proc_dir_entry 'video/VGA' already registered
    
    eliminate the duplicate the name of "VGA"
    
    http://bugzilla.kernel.org/show_bug.cgi?id=12514
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0a3db1cec5d476804185114ff5d1845aed3936b3
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Feb 2 11:33:41 2009 +0800

    ACPI: Skip the first two elements in the _BCL package
    
    According to the Spec the first two elements in the _BCL package won't be
    
    regarded as the available brightness level. The first is the brightness when
    full power is connected to the box(It means that the AC adapter is plugged).
    The second is the brightness level when the box is on battery.
        If the first two elements are still used while finding the next brightness
    level, it will fall back to the lowest level when keeping on pressing
    hotkey. (On some boxes the brightness will be changed twice when hotkey is
    pressed once. One is in the ACPI video driver. The other is changed by sys I/F.
    In the ACPI video driver the first two elements will be used while changing
    the brightness. But the first two elements is skipped while using sys I/F.
    In such case there exists the inconsistency).
        So he first two elements had better be skipped while showing the available
    brightness or finding the next brightness level.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=12450
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 31878dd86b7df9a147f5e6cc6e07092b4308782b
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 28 18:28:09 2009 -0500

    ACPI: remove BM_RLD access from idle entry path
    
    It is true that BM_RLD needs to be set to enable
    bus master activity to wake an older chipset (eg PIIX4) from C3.
    
    This is contrary to the erroneous wording the ACPI 2.0, 3.0
    specifications that suggests that BM_RLD is an indicator
    rather than a control bit.
    
    ACPI 1.0's correct wording should be restored in ACPI 4.0:
    http://www.acpica.org/bugzilla/show_bug.cgi?id=689
    
    But the kernel should not have to clear BM_RLD
    when entering a non C3-type state just to set
    it again when entering a C3-type C-state.
    
    We should be able to set BM_RLD at boot time
    and leave it alone -- removing the overhead of
    accessing this IO register from the idle entry path.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a2b7b01c072435b7832ab392167545a1b38cabc3
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 28 12:47:15 2009 -0500

    ACPI: remove locking from PM1x_STS register reads
    
    PM1a_STS and PM1b_STS are twins that get OR'd together
    on reads, and all writes are repeated to both.
    
    The fields in PM1x_STS are single bits only,
    there are no multi-bit fields.
    
    So it is not necessary to lock PM1x_STS reads against
    writes because it is impossible to read an intermediate
    value of a single bit.  It will either be 0 or 1,
    even if a write is in progress during the read.
    Reads are asynchronous to writes no matter if a lock
    is used or not.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2b25c9f01aa58d48129b2f93748dfb5d1f7ab0a2
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Jan 20 16:17:49 2009 +0100

    eeepc-laptop: use netlink interface
    
    To be prepared for /proc/acpi/event removal we export events
    also through generic netlink interface.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5740294ca3a9b113fe146f2826effb69ca50008d
Author: Matthew Garrett <mjg@redhat.com>
Date:   Tue Jan 20 16:17:48 2009 +0100

    eeepc-laptop: Implement rfkill hotplugging in eeepc-laptop
    
    The Eee implements rfkill by logically unplugging the wireless card from the
    PCI bus. Despite sending ACPI notifications, this does not appear to be
    implemented using standard ACPI hotplug - nor does the firmware provide the
    _OSC method required to support native PCIe hotplug. The only sensible choice
    appears to be to handle the hotplugging directly in the eeepc-laptop driver.
    Tested successfully on a 700, 900 and 901.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c9ddf8fede1271bde0a512fa94f77c4cb1ef4040
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Tue Jan 20 16:17:47 2009 +0100

    eeepc-laptop: Check return values from rfkill_register
    
    Error out if rfkill registration fails, and also set the default system state
    appropriately on boot
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b5f6f26550700445dcc125bbf75b9104e779d353
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Tue Jan 20 16:17:46 2009 +0100

    eeepc-laptop: Add support for extended hotkeys
    
    Newer Eees have extra hotkeys above the function keys. This patch adds support
    for sending them through the input layer.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ed6f44215374d94c35cbe98b582d004b9a3f5fbe
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Jan 20 16:17:45 2009 +0100

    asus-laptop: fix label indentation
    
    Fix the label indentation
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 12d6f35b0ff1f446d465e95e9a2fe187263479ef
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Jan 20 16:17:44 2009 +0100

    asus-laptop: update Kconfig for input layer
    
    Update Kconfig, now asus-laptop use the input layer.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 034ce90a8d1051deaeb31bae7f26ff1440a5b988
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Jan 20 16:17:43 2009 +0100

    asus-laptop: hotkeys via the generic input interface
    
    This patch is based on eeepc-laptop.c and the patchs
    from Nicolas Trangez and Daniel Nascimento (mainly for the keymap).
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2a7dc0d8c60325e9bf820900bf919430e5a419ab
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Jan 20 16:17:42 2009 +0100

    asus-laptop: use generic netlink interface
    
    To be prepared for /proc/acpi/event removal we export events
    also through generic netlink interface.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1021e2119eb33a990a2b9ff1410805dd9bdf7997
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Jan 20 16:17:41 2009 +0100

    asus_acpi: Add R1F support
    
    Add R1F support
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a9df80c5094ed2bac94f4a0d085651f44d549854
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Jan 20 16:17:40 2009 +0100

    eeepc-laptop: split eeepc_backlight_exit()
    
    eeepc_backlight_exit() was doing rfkill and input stuff, which
    is a nonsense. This patch add two specific exit functions, one
    for input and one for rfkill.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2b190e76def5233c542f6025b4a133b1d4bd1a37
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Sat Jan 17 15:51:27 2009 +0100

    panasonic-laptop: fix X[ ARRAY_SIZE(X) ]
    
    Ensure pcc->keymap[ ARRAY_SIZE(pcc->keymap) ] does not occur.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4312495f7db63d27ef52ec83dab55f14a8c43827
Author: Tero Roponen <tero.roponen@gmail.com>
Date:   Sat Jan 17 13:06:02 2009 +0200

    ACPI: Fix crash on ASUS laptops
    
    This patch fixes the crash I experienced in 2.6.29-rc2.
    Tested on ASUS M50vm.
    
    Signed-off-by: Tero Roponen <tero.roponen@gmail.com>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5d8b532af9e52ea89208f5ef31889f646e67ba28
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jan 16 23:09:14 2009 +0100

    ACPI suspend: Fix compilation warnings in drivers/acpi/sleep.c
    
    Fix two compilation warnings in drivers/acpi/sleep.c, one triggered
    by unsetting CONFIG_SUSPEND and the other triggered by unsetting
    CONFIG_HIBERNATION, by moving some code under the appropriate
    #ifdefs .
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 091d71e023557136e96f0e54f301497a3fc95dc3
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Jan 17 00:10:45 2009 +0100

    PM: Fix compilation warning in kernel/power/main.c
    
    Reorder the code in kernel/power/main.c to fix compilation warning
    triggered by unsetting CONFIG_SUSPEND.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>
