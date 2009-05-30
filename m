Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbZE3Bpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbZE3Bpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 21:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbZE3Bpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 21:45:41 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:41581 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZE3Bpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 21:45:40 -0400
Date: Fri, 29 May 2009 21:45:40 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
Subject: ACPI & driver patches for 2.6.30-rc7
Message-id: <alpine.LFD.2.00.0905292144300.4293@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.30/acpi-release-20090521-2.6.30-rc7.diff.gz

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 ++--
 drivers/acpi/pci_bind.c                    |   24 ++++++------------------
 drivers/acpi/processor_idle.c              |    8 +++++++-
 drivers/acpi/processor_perflib.c           |   12 +++++++++---
 drivers/acpi/processor_throttling.c        |    2 +-
 drivers/acpi/video.c                       |   18 +++++++++++++++++-
 drivers/dma/ioat_dma.c                     |    2 +-
 drivers/gpu/drm/Kconfig                    |   14 +++++++-------
 drivers/idle/i7300_idle.c                  |    6 +++++-
 include/linux/i7300_idle.h                 |   20 ++++++++++----------
 10 files changed, 65 insertions(+), 45 deletions(-)

through these commits:

Frans Pop (1):
      ACPI processor: remove spurious newline from warning message

Jaswinder Singh Rajput (1):
      drm/i915: acpi/video.c fix section mismatch warning

Joe Perches (1):
      acpi-cpufreq: fix printk typo and indentation

Kenji Kaneshige (1):
      PCI/ACPI: fix wrong ref count handling in acpi_pci_bind()

Len Brown (3):
      i7300_idle: allow testing on i5000-series hardware w/o re-compile
      ACPI: sanity check _PSS frequency to prevent cpufreq crash
      ACPI, i915: build fix (v2)

Shaohua Li (2):
      cpuidle: makes AMD C1E work in acpi_idle
      cpuidle: fix AMD C1E suspend hang

Zhang Rui (2):
      ACPI: video: DMI workaround broken eMachines E510 BIOS enabling display brightness
      ACPI: video: DMI workaround broken Acer 5315 BIOS enabling display brightness

with this log:

commit 6afec830acc75a4dc4a7547c66fbf18152c946ef
Merge: 93bcece 7d60e8a 34d531e dacd254 31db564 2f10260
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 29 21:30:01 2009 -0400

    Merge branches 'bugzilla-13121+', 'bugzilla-13233', 'redhat-bugzilla-500311', 'pci-bind-oops', 'misc-2.6.30' and 'i7300_idle' into release

commit 31db5645bda24682dadbc97d5e8a7918ade2a298
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 29 21:11:27 2009 -0400

    ACPI, i915: build fix (v2)
    
    drivers/built-in.o: In function `intel_opregion_init':
    (.text+0x9d540): undefined reference to `acpi_video_register'
    
    v2: move under DRM_I915 from DRM_I915_KMS
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

commit 61c8c67e3ad67ea1d1360f2e88688bd942834756
Author: Joe Perches <joe@perches.com>
Date:   Tue May 26 14:58:39 2009 -0700

    acpi-cpufreq: fix printk typo and indentation
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 21671b88be331fb9c95891d5ee7d2e940e6b024c
Author: Frans Pop <elendil@planet.nl>
Date:   Fri May 22 10:23:40 2009 +0200

    ACPI processor: remove spurious newline from warning message
    
    Commit 4973b22a ("ACPI processor: reset the throttling state once it's
    invalid") introduced a new warning which prints a spurious newline.
    
    The ACPI_WARNING macro that is used already takes care of adding a
    newline, after adding ACPI_CA_VERSION to the message. Remove the newline
    to avoid the message getting split into two lines.
    
    Signed-off-by: Frans Pop <elendil@planet.nl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1fc8d33acafe68bdcc21b327d22ef3820b819727
Author: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date:   Wed May 20 11:56:08 2009 +0530

    drm/i915: acpi/video.c fix section mismatch warning
    
    Currently acpi_video_exit() is exported as well as using __exit which causes:
    
      WARNING: drivers/acpi/video.o(__ksymtab+0x0): Section mismatch in reference from the variable __ksymtab_acpi_video_exit to the function .exit.text:acpi_video_exit()
      The symbol acpi_video_exit is exported and annotated __exit
      Fix this by removing the __exit annotation of acpi_video_exit or drop the export.
    
    Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 93bcece20ef87c29548ec7e66532f1018572cea0
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue May 19 15:08:41 2009 -0400

    ACPI: video: DMI workaround broken Acer 5315 BIOS enabling display brightness
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13121
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 34ac272b3aaef11a91e19a72f3ac5772a96ffbc5
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue May 26 23:35:34 2009 -0400

    ACPI: video: DMI workaround broken eMachines E510 BIOS enabling display brightness
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13376
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 34d531e640cb805973cf656b15c716b961565cea
Author: Len Brown <len.brown@intel.com>
Date:   Tue May 26 15:11:06 2009 -0400

    ACPI: sanity check _PSS frequency to prevent cpufreq crash
    
    When BIOS SETUP is changed to disable EIST, some BIOS
    hand the OS an un-initialized _PSS:
    
            Name (_PSS, Package (0x06)
            {
                Package (0x06)
                {
                    0x80000000,	// frequency [MHz]
                    0x80000000,	// power [mW]
                    0x80000000,	// latency [us]
                    0x80000000,	// BM latency [us]
                    0x80000000,	// control
                    0x80000000	// status
                },
    	    ...
    
    These are outrageous values for frequency,
    power and latency, raising the question where to draw
    the line between legal and illegal.  We tend to survive
    garbage in the power and latency fields, but we can BUG_ON
    when garbage is in the frequency field.
    
    Cpufreq multiplies the frequency by 1000 and stores it in a u32 KHz.
    So disregard a _PSS with a frequency so large
    that it can't be represented by cpufreq.
    
    https://bugzilla.redhat.com/show_bug.cgi?id=500311
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2f102607ac77354b02a76cf2748598ce9f270f08
Author: Len Brown <len.brown@intel.com>
Date:   Wed May 27 23:59:58 2009 -0400

    i7300_idle: allow testing on i5000-series hardware w/o re-compile
    
    Testing the i7300_idle driver on i5000-series hardware required
    an edit to i7300_idle.h to "#define SUPPORT_I5000 1" and a re-build
    of both i7300_idle and ioat_dma.
    
    Replace that build-time scheme with a load-time module parameter:
    "7300_idle.forceload=1" to make it easier to test the driver
    on hardware that while not officially validated, works fine
    and is much more commonly available.
    
    By default (no modparam) the driver will continue to load
    only on the i7300.
    
    Note that ioat_dma runs a copy of i7300_idle's probe routine
    to know to reserve an IOAT channel for i7300_idle.
    This change makes ioat_dma do that always on the i5000,
    just like it does on the i7300.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Acked-by: Andrew Henroid <andrew.d.henroid@intel.com>

commit dacd2549ca61ddbdd1ed62a76ca95dea3f0e02c6
Author: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Date:   Tue May 26 09:08:03 2009 +0900

    PCI/ACPI: fix wrong ref count handling in acpi_pci_bind()
    
    The 'dev' field of struct acpi_pci_data is having a pointer to struct
    pci_dev without incrementing the reference counter. Because of this, I
    got the following kernel oops when I was doing some pci hotplug
    operations. This patch fixes this bug by replacing wrong hand-made
    pci_find_slot() with pci_get_slot() in acpi_pci_bind().
    
     BUG: unable to handle kernel NULL pointer dereference at 00000000000000e8
     IP: [<ffffffff803f0e9b>] acpi_pci_unbind+0xb1/0xdd
    
     Call Trace:
      [<ffffffff803ecee4>] acpi_bus_remove+0x54/0x68
      [<ffffffff803ecf6d>] acpi_bus_trim+0x75/0xe3
      [<ffffffffa0345ddd>] acpiphp_disable_slot+0x16d/0x1e0 [acpiphp]
      [<ffffffffa03441f0>] disable_slot+0x20/0x60 [acpiphp]
      [<ffffffff803cfc18>] power_write_file+0xc8/0x110
      [<ffffffff803c6a54>] pci_slot_attr_store+0x24/0x30
      [<ffffffff803469ce>] sysfs_write_file+0xce/0x140
      [<ffffffff802e94e7>] vfs_write+0xc7/0x170
      [<ffffffff802e9aa0>] sys_write+0x50/0x90
      [<ffffffff8020bd6b>] system_call_fastpath+0x16/0x1b
    
    Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
    Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Alex Chiang <achiang@hp.com>
    Tested-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7d60e8ab0d5507229dfbdf456501cc378610fa01
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Tue May 19 16:09:54 2009 +0800

    cpuidle: fix AMD C1E suspend hang
    
    When AMD C1E is enabled, local APIC timer will stop even in C1. To avoid
    suspend/resume hang, this patch removes C1 and replace it with a cpu_relax() in
    suspend/resume path. This hasn't any impact in runtime path.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13233
    
    [ impact: avoid suspend/resume hang in AMD CPU with C1E enabled ]
    
    Tested-by: Dmitry Lyzhyn <thisistempbox@yahoo.com>
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 87ad57bacb25c3f24c54f142ef445f68277705f0
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Tue May 19 16:09:42 2009 +0800

    cpuidle: makes AMD C1E work in acpi_idle
    
    When AMD C1E is enabled, local APIC timer will stop even in C1.
    This patch uses broadcast IPI to replace local APIC timer in C1.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13233
    
    [ impact: avoid boot hang in AMD CPU with C1E enabled ]
    
    Tested-by: Dmitry Lyzhyn <thisistempbox@yahoo.com>
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
