Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbXKTSNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbXKTSNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXKTSN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:13:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:58085 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbXKTSNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:13:24 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PATCH] ACPI patches for 2.6.24-rc3
Date: Tue, 20 Nov 2007 13:13:05 -0500
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201313.05502.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This request is larger than I'd prefer at -rc3,
but as I wasn't available for an -rc2 merge, some things waited until now.
The good news is that the larger text changes are low risk.

The EC changes are tweaks to the -rc0 update --
as we've learned about new and creative ways that vendors
can make their EC's violate spec...  Thanks to Alexey for
being extremely responsive in debugging these...

Fixed a popular battery oops regression.

Fixed a boot hang on some unusual AMD boxes seen with the new CPU_IDLE.

Fixed a long-standing IRQ8 issue that some OEMs
and Linux distros are eagerly awaiting.

Fixed the processor throttling extensions that we first
started supporting in 2.6.23.  The reality is that it took
until now to properly test the code, as only very new platforms
have it.

And a couple of small cleanups -- the larger ones are waiting for 2.6.25.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.24/acpi-release-20070126-2.6.24-rc3.diff.gz

 Documentation/thinkpad-acpi.txt     |   73 +++---
 arch/x86/kernel/acpi/processor.c    |    3 
 arch/x86/kernel/acpi/sleep_64.c     |    3 
 arch/x86/kernel/io_apic_32.c        |   21 +
 arch/x86/kernel/io_apic_64.c        |   24 +-
 arch/x86/pci/acpi.c                 |    2 
 drivers/acpi/Kconfig                |   18 +
 drivers/acpi/Makefile               |    2 
 drivers/acpi/ac.c                   |   20 -
 drivers/acpi/battery.c              |   22 +
 drivers/acpi/ec.c                   |   43 ++-
 drivers/acpi/osl.c                  |   25 --
 drivers/acpi/processor_core.c       |   14 -
 drivers/acpi/processor_idle.c       |  111 +++++----
 drivers/acpi/processor_throttling.c |  286 ++++++++++++++++++------
 drivers/acpi/sbs.c                  |   43 ++-
 drivers/acpi/tables/tbutils.c       |    2 
 drivers/acpi/video.c                |  155 ++++++-------
 drivers/misc/thinkpad_acpi.c        |  231 ++++++++++++++-----
 drivers/misc/thinkpad_acpi.h        |    4 
 drivers/pnp/pnpacpi/rsparser.c      |   24 +-
 include/acpi/processor.h            |    1 
 include/linux/acpi.h                |    5 
 include/linux/cpuidle.h             |    1 
 24 files changed, 769 insertions(+), 364 deletions(-)

through these commits:

Adrian Bunk (2):
      x86_64: remove acpi_pci_link_exit()
      x86: acpi_pciprobe_dmi_table[] must be __devinitdata

Alexey Starikovskiy (3):
      ACPI: EC: Workaround for optimized controllers
      ACPI: Split out control for /proc/acpi entries from battery, ac, and sbs.
      ACPI: EC: Don't init EC early if it has no _INI

Danny Baumann (1):
      ACPI: Video: Increase buffer size for writes to brightness proc file.

Dmitry Torokhov (4):
      ACPI: video - fit input device into sysfs tree
      ACPI: video - add missing input_free_device()
      ACPI: video - remove unsafe uses of list_for_each_safe()
      ACPI: video - convert semaphore to a mutex

Henrique de Moraes Holschuh (8):
      ACPI: thinkpad-acpi: revert keymap changes
      ACPI: thinkpad-acpi: support 16 levels of brightness (v3)
      ACPI: thinkpad-acpi: add brightness_force parameter
      ACPI: thinkpad-acpi: prefer standard ACPI backlight level control
      ACPI: thinkpad-acpi: bump up version to 0.17
      ACPI: thinkpad-acpi: allow for syscall restart in sysfs handlers
      ACPI: thinkpad-acpi: fix brightness_set error paths
      ACPI: thinkpad-acpi: fix oops when a module parameter has no value

Jeff Garzik (1):
      ACPI: SBS: Fix retval warning

Joe Perches (1):
      ACPI: Add missing spaces to printk format

Len Brown (4):
      ACPI: video - delete stray run-time printk
      Revert "ACPI: add documentation for deprecated /proc/acpi/battery in ACPI_PROCFS"
      Revert "acpi: make ACPI_PROCFS default to y"
      Revert "Fix very high interrupt rate for IRQ8 (rtc) unless pnpacpi=off"

Roland Dreier (1):
      ACPI: Always return valid 'status' from acpi_battery_get_property()

Shaohua Li (1):
      ACPI: fix two IRQ8 issues in IOAPIC mode

Venkatesh Pallipadi (3):
      cpuidle: fix C3 for no bus-master control case
      cpuidle: add sched_clock_idle_[sleep|wakeup]_event() hooks
      cpuidle: fix HP nx6125 regression

Zhao Yakui (7):
      ACPI: Enforce T-state limit changes immediately
      ACPI: Handle I/O access width requestst that are not a multiple of 8 bits.
      ACPI: If _TSS exists, do not access FADT.duty_width
      ACPI: throttle: Change internal APIs better handle _PTC
      ACPI: Use _TSS for throttling control, when present. Add error checks.
      ACPI: Get throttling info from BIOS only after evaluating _PDC
      ACPI: Enable MSR (FixedHW) support for T-States

with this log:

commit e6532b8883760bdf9d251c669a3919fc9457aeca
Merge: d89a9bd... 4fdb2a0...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 20 01:21:47 2007 -0500

    Pull fluff into release branch
    
    Conflicts:
    
    	drivers/acpi/ec.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d89a9bda14204547f966ed1510a269a44c0b7f5d
Merge: d12dbbf... c88c578...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 20 01:20:57 2007 -0500

    Pull video-2.6.24 into release branch

commit d12dbbfe948c89156ad1b0fe7c808ba4d6f00bc2
Merge: 614a6bb... 59f91ff...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 20 01:20:42 2007 -0500

    Pull thinkpad-2.6.24 into release branch

commit 614a6bbecceb97558819f18a676fd819ea61550b
Merge: c2e46d2... f79f06a...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 20 01:20:31 2007 -0500

    Pull thermal into release branch

commit c2e46d2e2a8e6ed17fac6154ac7e5fa7fe4efb28
Merge: 95b0078... 65ea652...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 20 01:20:00 2007 -0500

    Pull procfs-default into release branch
    
    Conflicts:
    
    	drivers/acpi/sbs.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 95b00786f3b8fa99f53931361beeb4c10504ad87
Merge: 22201f7... ddc081a...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 20 01:18:37 2007 -0500

    Pull cpuidle into release branch

commit 22201f7402851b9a47e64139ca589bd8555f7138
Merge: 5824b45... f2d6893...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 20 01:18:19 2007 -0500

    Pull bugzilla-9327 into release branch

commit 5824b4512650db90ddd5fdbea7f8aea3c7df3a94
Merge: 7833b4a... 5870a8c...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 20 01:18:07 2007 -0500

    Pull bugzilla-9262 into release branch

commit 7833b4ae466e084a865542c6fd83394a3d274144
Merge: 86533e8... 61fd47e...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 20 01:17:54 2007 -0500

    Pull bugzilla-9153 into release branch

commit 86533e80e0a20ed1a676f9eeb2dde0fa5ff23276
Merge: 2ffbb83... 037cbc6...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 20 01:17:42 2007 -0500

    Pull battery into release branch

commit 61fd47e0c84764f49b4e52bfd8170fac52636f00
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Sat Nov 17 01:05:28 2007 -0500

    ACPI: fix two IRQ8 issues in IOAPIC mode
    
    Use mp_irqs[] to get PNP device's interrupt polarity and trigger.
    There are two reasons to do this:
    1. BIOS bug for PNP interrupt
    2. BIOS explictly does override
    mp_irqs[] should cover all the cases.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=5243
    http://bugzilla.kernel.org/show_bug.cgi?id=7679
    http://bugzilla.kernel.org/show_bug.cgi?id=9153
    
    [lenb: fixed !IOAPIC and 64-bit !SMP builds]
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4fdb2a05ef5703553fdd28f1b96ebdd79f173657
Author: Joe Perches <joe@perches.com>
Date:   Mon Nov 19 17:48:02 2007 -0800

    ACPI: Add missing spaces to printk format
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ddc081a19585c8ba5aad437779950c2ef215360a
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Mon Nov 19 21:43:22 2007 -0500

    cpuidle: fix HP nx6125 regression
    
    Fix for http://bugzilla.kernel.org/show_bug.cgi?id=9355
    
    cpuidle always used to fallback to C2 if there is some bm activity while
    entering C3. But, presence of C2 is not always guaranteed. Change cpuidle
    algorithm to detect a safe_state to fallback in case of bm_activity and
    use that state instead of C2.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5062911830a66df0c0ad28c387a8c0623cb0d28c
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Mon Nov 19 19:49:00 2007 -0500

    cpuidle: add sched_clock_idle_[sleep|wakeup]_event() hooks
    
    Port 2aa44d0567ed21b47b87d68819415d48194cb923
    (sched: sched_clock_idle_[sleep|wakeup]_event()) to cpuidle.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c9c860e5349ef62cd9226694b3aa625ef66f504e
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Mon Nov 19 19:48:00 2007 -0500

    cpuidle: fix C3 for no bus-master control case
    
    Port 18eab8550397f1f3d4b8b2c5257c88dae25d58ed
    (Enable C3 even when PM2_control is zero) to cpuidle.
    
    Without this patch, some systems will notice a regression
    when enabling CPU_IDLE -- C3 would no longer be available.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 59f91ff11e594913a5b3c03a4707fdf02338c8df
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Nov 18 09:18:29 2007 -0200

    ACPI: thinkpad-acpi: fix oops when a module parameter has no value
    
    set_ibm_param() could OOPS with a NULL pointer derreference if one did not give
    any values for a module parameter it handles.  This would, of course, cause all
    sort of trouble for future modprobing and require a reboot to clean up
    properly.
    
    Fix it by returning -EINVAL if no values are given for the parameter, and also
    avoid any nastyness from BUG_ON while at it.
    
    How to reproduce: modprobe thinkpad-acpi brightness
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Tested-by: Mike Kershaw <dragorn@kismetwireless.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f0714d20234062bd0a8f49a6b32f7d1d7f3c2943
Author: Len Brown <len.brown@intel.com>
Date:   Mon Nov 19 12:23:59 2007 -0500

    Revert "Fix very high interrupt rate for IRQ8 (rtc) unless pnpacpi=off"
    
    This reverts commit 9cd8047b463f213c294f756119ac353312e7a152.

commit 5870a8cd23181703cc76f88f630372f8602c7648
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Nov 15 21:52:47 2007 +0300

    ACPI: EC: Don't init EC early if it has no _INI
    
    Option to init EC early inserted to handle #8598 ASUS problem,
    introduced several others.
    
    EC driver in this particular case has fake _INI method, not present on
    other machines, which don't need or break from this workaround, so lets use
    its presence as a flag for early init.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9262
    http://bugzilla.kernel.org/show_bug.cgi?id=8598
    https://bugzilla.novell.com/show_bug.cgi?id=334806
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 65ea6520375cc09d19ecb46f03ab7ef70bcf06dd
Author: Len Brown <len.brown@intel.com>
Date:   Mon Nov 19 11:22:44 2007 -0500

    Revert "acpi: make ACPI_PROCFS default to y"
    
    This reverts commit cbff2fbf55c21f50298b1aef1263b11bf510e35f.

commit 3539a901d60ae84f8b0748cd26c1c263c2b3ef5f
Author: Len Brown <len.brown@intel.com>
Date:   Mon Nov 19 11:22:35 2007 -0500

    Revert "ACPI: add documentation for deprecated /proc/acpi/battery in ACPI_PROCFS"
    
    This reverts commit 6e800af233e0bdf108efb7bd23c11ea6fa34cdeb.

commit fdcedbba2f98c94bfbac9f6e712ab765f997b8dc
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Nov 19 16:33:45 2007 +0300

    ACPI: Split out control for /proc/acpi entries from battery, ac, and sbs.
    
    Introduce new ACPI_PROCFS_POWER (default Yes) config option and move
    procfs code in battery, ac, and sbs drivers under it.
    This is done to allow ACPI_PROCFS to be default No.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c88c5786d3df51ccfa4e2d111fc9c8fc0f5b2797
Author: Danny Baumann <dannybaumann@web.de>
Date:   Fri Nov 2 13:47:53 2007 +0100

    ACPI: Video: Increase buffer size for writes to brightness proc file.
    
    In order to be able to write the value "100"
    to /proc/acpi/video/.../brightness, we have to allocate 5 bytes:
    4 characters will be written (1, 0, 0 plus null byte),
    and 1 byte should be buffer for a terminating NULL character.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9278
    
    Signed-off-by: Danny Baumann <dannybaumann@web.de>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f2d68935ba08cf80f151bbdb5628381184e4a498
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Nov 19 01:37:03 2007 +0300

    ACPI: EC: Workaround for optimized controllers
    
    Some controllers fail to send confirmation GPE after address write.
    Detect this and don't expect such confirmation in future.
    This is a generalization of previous workaround
    (66c5f4e7367b0085652931b2f3366de29e7ff5ec), which did only read address.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9327
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Tested-by: Romano Giannetti <romano.giannetti@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 037cbc63fd83162a8ee0c69680207ce4609adbea
Author: Jeff Garzik <jgarzik@redhat.com>
Date:   Sun Nov 18 00:32:31 2007 +0300

    ACPI: SBS: Fix retval warning
    
    drivers/acpi/sbs.c: In function acpi_battery_add:
    drivers/acpi/sbs.c:811: warning: ignoring return value of device_create_file,
    declared with attribute warn_unused_result
    
    Additional cleanups:
    * use struct acpi_battery in acpi_battery_remove() to clean up function
    calls, just like acpi_battery_add() already does.
    
    * put braces around unregister call, as it depends on dev being not NULL.
    
    * remove unneeded braces
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f79f06ab9f86d7203006d2ec8992ac80df36a34e
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu Nov 15 17:06:36 2007 +0800

    ACPI: Enable MSR (FixedHW) support for T-States
    
    Add throttling control via MSR when T-states uses
    the FixHW Control Status registers.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0ac3c571315a53c14d2733564f14ebdb911fe903
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu Nov 15 17:05:46 2007 +0800

    ACPI: Get throttling info from BIOS only after evaluating _PDC
    
    Previously _PDC was evaluated later, and thus we'd not get
    the chance to tell the BIOS that we can suport FixedHW registers (MSRs)
    and the BIOS would always ask us to use System I/O access
    for throttling.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9bcb27217344c2c1389db3983a436e19484c2f50
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu Nov 15 17:05:05 2007 +0800

    ACPI: Use _TSS for throttling control, when present. Add error checks.
    
    _TSS was erroneously ignored, in favor of the FADT.
    
    When TSS is used, the access width is included in the PTC control/status
    register.  So it is unnecessary that the access bit width is multiplied by 8.
    At the same time the bit_offset should be considered for system I/O Access.
    
    It should be checked the bit_width and bit_offset of PTC regsiter in order to
    avoid the failure of system I/O access. It means that bit_width plus
    bit_offset can't be greater than 32.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0753f6e0a3d9568fb6b8e34753b944d9f8eed05b
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu Nov 15 17:03:46 2007 +0800

    ACPI: throttle: Change internal APIs better handle _PTC
    
    Change the function interface for throttling control via PTC.
    The following functions are concerned:
    
    acpi_read_throttling_status()
    acpi_write_throttling_state()
    acpi_get_throttling_value()
    acpi_get_throttling_state()
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 22cc50199d0616f7b002563a0e9117ba479356e1
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu Nov 15 17:02:03 2007 +0800

    ACPI: If _TSS exists, do not access FADT.duty_width
    
    Factor out legacy FADT.duty_width code
    and run it only in the non _TSS case.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 49fbabf56dc715bbb51e59742e82ba762790aac0
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu Nov 15 17:01:06 2007 +0800

    ACPI: Handle I/O access width requestst that are not a multiple of 8 bits.
    
    We've run into BIOS that hand us 4-bit access width requests
    for T-state control when the code expected only multipls of 8-bits.
    Round up.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ef54d5ad2f58f899be6419fd1090cdeb2439851a
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu Nov 15 16:59:30 2007 +0800

    ACPI: Enforce T-state limit changes immediately
    
    When a T-state limit change notification is received,
    Linux must evaluate _TPC and change its current
    T-state immediately to comply with the new limit.
    
    Previously, Linux would notice the new limit
    only upon the next throttling change.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 55b8d50c1a7b2d53eddaa3114dc55b0ed00df0f3
Author: Adrian Bunk <bunk@kernel.org>
Date:   Fri Nov 9 07:02:11 2007 +0100

    x86: acpi_pciprobe_dmi_table[] must be __devinitdata
    
    This patch fixes the following section mismatches with CONFIG_HOTPLUG=n:
    
    <--  snip  -->
    
    ...
    WARNING: vmlinux.o(.data+0x23640): Section mismatch: reference to .init.text.20:can_skip_ioresource_align (between 'acpi_pciprobe_dmi_table' and 'pcibios_irq_mask')
    WARNING: vmlinux.o(.data+0x2366c): Section mismatch: reference to .init.text.20:can_skip_ioresource_align (between 'acpi_pciprobe_dmi_table' and 'pcibios_irq_mask')
    WARNING: vmlinux.o(.data+0x23698): Section mismatch: reference to .init.text.20:can_skip_ioresource_align (between 'acpi_pciprobe_dmi_table' and 'pcibios_irq_mask')
    ...
    
    <--  snip  -->
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 16ee2db63ef78c387bdda6e0cde3a2051518b6cf
Author: Adrian Bunk <bunk@kernel.org>
Date:   Fri Nov 9 07:03:13 2007 +0100

    x86_64: remove acpi_pci_link_exit()
    
    acpi_pci_link_exit() is both unused and empty.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a4f0c2767e9c55123d7dad7176554e9d6e6056bc
Author: Len Brown <len.brown@intel.com>
Date:   Wed Nov 14 12:49:13 2007 -0500

    ACPI: video - delete stray run-time printk
    
    printk("video bus notify\n");
    
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bbac81f5487175e4bd5602a80c17689d8f82a63e
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Mon Nov 5 11:43:32 2007 -0500

    ACPI: video - convert semaphore to a mutex
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ff102ea99099c36250e93a87a9794b5233801020
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Mon Nov 5 11:43:31 2007 -0500

    ACPI: video - remove unsafe uses of list_for_each_safe()
    
    list_for_each_safe() only protects list from list alterations
    performed by the same thread. One still needs to implement
    proper locking when list is being accessed from several threads.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f51e83916a0a022d3d0ea39ae2f877c703032923
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Mon Nov 5 11:43:30 2007 -0500

    ACPI: video - add missing input_free_device()
    
    If input_register_device() fails input_free_device() must
    be called to release memory allocated for the device.
    Also consolidate error handling in acpi_bus_video_add()
    and handle input_allocate_device() failures.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 91c05c667b2d8e43e0bbc5f269bf45d4821001d6
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Mon Nov 5 11:43:29 2007 -0500

    ACPI: video - fit input device into sysfs tree
    
    Properly set up parent on input device registered by the video driver.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4c41d3ad6544f1c9aec37c441af04f5d0ad3a731
Author: Roland Dreier <roland@digitalvampire.org>
Date:   Wed Nov 7 15:09:09 2007 -0800

    ACPI: Always return valid 'status' from acpi_battery_get_property()
    
    If a battery is at a critical charge level and not being charged or
    discharged, then the ACPI _BST method will return a state of 4, and
    the current acpi_battery_get_property() code will not set any property
    value for POWER_SUPPLY_PROP_STATUS.  This will cause an oops in
    power_supply_show_property() when it reads off the end of the
    status_text array.  This actually was causing a 100% reproducible
    crash on boot on my laptop with two batteries, when one battery was
    completely drained and the laptop was not plugged in.
    
    Fix this by making sure acpi_battery_get_property() returns
    POWER_SUPPLY_STATUS_UNKNOWN for any battery state it doesn't already
    handle explicitly.  There doesn't seem to be any status enum value
    defined that makes more sense than 'unknown' for a battery at a
    critical charge level.
    
    Signed-off-by: Roland Dreier <roland@digitalvampire.org>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <lenb@t61.(none)>

commit 4273af8d08c823d5898a2b1c2d0f25b4a8b9eaee
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Oct 30 17:46:25 2007 -0200

    ACPI: thinkpad-acpi: fix brightness_set error paths
    
    The code calling brightness_set() can't handle EINTR/ERESTARTSYS well, nor
    is it checking brightness_set() return status properly.
    
    Fix it.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fc589a3ce5f38db6239c147da4f9172a25575ecc
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Oct 30 17:46:24 2007 -0200

    ACPI: thinkpad-acpi: allow for syscall restart in sysfs handlers
    
    Map an mutex_lock_interruptible() error return into ERESTARTSYS, as the
    only possible error from mutex_lock_interruptible is EINTR, and that will
    only happen if signal_pending() causes the mutex lock attempt to abort.
    
    This still allows signals to be delivered ASAP, which is much nicer than
    just doing mutex_lock, and still shadows userspace from EINTR when
    SA_RESTART is active.
    
    Problem reported by Peter Jordan.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Jean Delvare <khali@linux-fr.org>
    Cc: Peter Jordan <usernetwork@gmx.info>
    Cc: Richard Neill <rn214@hermes.cam.ac.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b856f5b8c022b75bb0504a8c1ce16a5f1656e08b
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Oct 30 17:46:23 2007 -0200

    ACPI: thinkpad-acpi: bump up version to 0.17
    
    The lm-sensors 3.0.0/libsensors4 compatibility changes are reason enough to
    bump up the version string.  Do it.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e11e211a0b21bbb625fac2056bdb54dd02020556
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Oct 30 17:46:22 2007 -0200

    ACPI: thinkpad-acpi: prefer standard ACPI backlight level control
    
    Newer Lenovo BIOSes support the standard ACPI backlight brightness
    interface (_BCM, _BQC, _BCL).  It should be used instead of the native
    thinkpad backlight brightness control interface when possible.
    
    This patch disables the native brightness support in the driver by default
    when we detect that the standard ACPI interface is available.  The local
    admin can still enable it using the module parameter "brightness_enable".
    
    Note that we need to detect the standard ACPI backlight interface only in
    boxes for which we would load the native backlight interface in the first
    place, and that no ThinkPad BIOS has _BCL but misses the other methods, so
    the detection routines can be really simple.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 87cc537a54fc017d998cf603f5fab9ca4a85d668
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Oct 30 18:02:07 2007 -0200

    ACPI: thinkpad-acpi: add brightness_force parameter
    
    Add a "brightness_enable" module parameter that allows the local admin to
    force the backlight support to not be enabled.
    
    It can also be used to force the backlight support to be enabled, but that
    is currently a no-op as the backlight support is enabled by default when
    available.  This will be changed by a different patch.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a3f104c02ab842574e699186cf953551aafe2ca9
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Oct 30 17:46:20 2007 -0200

    ACPI: thinkpad-acpi: support 16 levels of brightness (v3)
    
    Lenovo ThinkPads often have 16 brightness levels in EC, and not just eight
    levels like older ThinkPads.  They also have standard ACPI backlight
    brightness control.
    
    We detect the number of brightness levels by the presence of a BCLL package
    with 16 entries.  If BCLL is not there, we assume eight levels (Z6*).  If
    it is there, but it doesn't have 16 entries, we assume eight levels (T60).
    Otherwise we assume sixteen levels (T61, X61, etc).
    
    We don't use _BCL because it can have side-effects in thinkpads.  Thanks to
    Thomas Renninger <trenn@suse.de> for notifying me of this potential
    problem.
    
    Using the standard ACPI backlight brightness control *instead* of the
    native thinkpad backlight control is a better idea, though.  A different
    patch will take care of this.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e927c08da53e5c87ca07f7a828d4a0048e7bacf0
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Oct 30 17:46:19 2007 -0200

    ACPI: thinkpad-acpi: revert keymap changes
    
    Revert commit fba956c46a72f9e7503fd464ffee43c632307e31, "Map volume and
    brightness events on thinkpads".
    
    That commit made some modifications to the default keymaps that cause bad
    behaviour on all IBM ThinkPads if HAL doesn't know to change them into
    passive (on-screen-display only) events.
    
    The proper solution for IBM ThinkPads is to use the _NOTIFY version of the
    key codes for the IBM default map (which are not available in mainline
    yet), and for the Lenovo keymap, it will take some studying of the various
    DSDTs and testing to know the best path (which I will do shortly).
    
    For more data, refer to:
    http://thread.gmane.org/gmane.linux.kernel/591037/focus=591045
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Jeremy Katz <katzj@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
