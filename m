Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab0COCAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 22:00:53 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:52822 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab0COCAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 22:00:49 -0400
Date: Sun, 14 Mar 2010 21:58:39 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@sony
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ACPI patches for Linux-2.6.34-rc1
Message-id: <alpine.LFD.2.00.1003142155470.19244@sony>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Here is why three things included in this request
look somewhat "merge-windo-ish".

re: sony-laptop
Matthew Garrett has graciously offered to handle consolidating
the x86 platform drivers from this release forward.  These patches
were not in his merge window request b/c he thought I sent them
up already.

re: bjorn's pnp series
I got a verbal Ack from Jesse Barnes on this series
and he wants it now.  It exposes additional info
that we may need in response to the recent PCI changes.

re: alex's processor-rename series
I procrastinated this re-factoring till after -merge
to avoid conflict with the cpufreq tree, recalling
a KS group discussion that rc1 is actually a reasonable time
for cleanups that don't otherwise change much.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.34/acpi-release-20100121-2.6.34-rc1.diff.gz

 Documentation/feature-removal-schedule.txt |    7 +
 Documentation/kernel-parameters.txt        |    4 -
 arch/ia64/kernel/acpi.c                    |    3 +
 arch/x86/kernel/acpi/boot.c                |  100 +---
 drivers/acpi/Makefile                      |    4 +-
 drivers/acpi/acpica/exmutex.c              |    3 +-
 drivers/acpi/battery.c                     |   86 ++-
 drivers/acpi/bus.c                         |   10 +-
 drivers/acpi/ec.c                          |   33 +-
 drivers/acpi/internal.h                    |    2 +
 drivers/acpi/processor_core.c              | 1118 ++++------------------------
 drivers/acpi/processor_driver.c            |  978 ++++++++++++++++++++++++
 drivers/acpi/processor_pdc.c               |  209 ------
 drivers/acpi/processor_throttling.c        |    3 -
 drivers/acpi/sbs.c                         |    5 +
 drivers/acpi/sleep.c                       |   19 +-
 drivers/acpi/thermal.c                     |   36 +-
 drivers/acpi/utils.c                       |   45 --
 drivers/acpi/video.c                       |   28 +-
 drivers/pci/hotplug/acpiphp_glue.c         |   19 +
 drivers/platform/x86/sony-laptop.c         |   91 ++--
 drivers/pnp/base.h                         |    3 +
 drivers/pnp/interface.c                    |    7 +-
 drivers/pnp/pnpacpi/rsparser.c             |   49 +-
 drivers/pnp/resource.c                     |   27 +-
 drivers/pnp/support.c                      |    4 +-
 drivers/power/power_supply_sysfs.c         |    1 +
 include/acpi/processor.h                   |   10 +-
 include/linux/ioport.h                     |   18 +-
 include/linux/power_supply.h               |    1 +
 lib/vsprintf.c                             |   13 +-
 31 files changed, 1502 insertions(+), 1434 deletions(-)
 create mode 100644 drivers/acpi/processor_driver.c
 delete mode 100644 drivers/acpi/processor_pdc.c

through these commits:

Alex Chiang (11):
      ACPI: processor: mv processor_core.c processor_driver.c
      ACPI: processor: mv processor_pdc.c processor_core.c
      ACPI: processor: export acpi_get_cpuid()
      ACPI: processor: move acpi_get_cpuid into processor_core.c
      ACPI: processor: add internal processor_physically_present()
      ACPI: processor: remove early _PDC optin quirks
      ACPI: processor: driver doesn't need to evaluate _PDC
      ACPI: processor: refactor internal map_lapic_id()
      ACPI: processor: refactor internal map_x2apic_id()
      ACPI: processor: refactor internal map_lsapic_id()
      ACPI: processor: push file static MADT pointer into internal map_madt_entry()

Alexey Starikovskiy (4):
      ACPI: Battery: Add bit flags
      POWER: Add support for cycle_count
      ACPI: SBS: Export cycle_count
      ACPI: Battery: Add support for _BIX extended info method

Bartlomiej Zolnierkiewicz (2):
      ACPI: remove superfluous NULL pointer check from acpi_processor_get_throttling_info()
      ACPICA: fix acpi_ex_release_mutex() comment

Bjorn Helgaas (5):
      resource: expand IORESOURCE_TYPE_BITS to make room for bus resource type
      resource: add bus number support
      resource: add window support
      PNPACPI: add window support
      PNPACPI: add bus number support

Dmitry Torokhov (3):
      sony-laptop - remove private workqueue, use keventd instead
      sony-laptop - simplify keymap initialization
      sony-laptop - switch from workqueue to a timer

Len Brown (3):
      ACPI: delete unused acpi_evaluate_string()
      ACPI: remove "acpi=ht" DMI blacklist
      ACPI: plan to delete "acpi=ht" boot option

Matthew Garrett (1):
      ACPI video: Be more liberal in validating _BQC behaviour

Rafael J. Wysocki (1):
      ACPI / EC / PM: Close race between EC and resume from hibernation

Shaohua Li (1):
      acpiphp: Execute ACPI _REG method for hotadded devices

Thomas Renninger (2):
      ACPI thermal: Check for thermal zone requirement
      ACPI thermal: Don't invalidate thermal zone if critical trip point is bad

Zhang Rui (1):
      ACPI: Disable explicit power state retrieval on fans

with this log:

commit ec28dcc6b4c00b78ad269ad5b85ebd5c2d504825
Merge: c67fcd6 d060705 f6bb13a 0c99c52 4c81ba4 7e0e9c0 149fe9c cffdde9 fa80945 8b7ef6d 70287db 38bcb37
Author: Len Brown <len.brown@intel.com>
Date:   Sun Mar 14 21:30:17 2010 -0400

    Merge branches 'battery-2.6.34', 'bugzilla-10805', 'bugzilla-14668', 'bugzilla-531916-power-state', 'ht-warn-2.6.34', 'pnp', 'processor-rename', 'sony-2.6.34', 'suse-bugzilla-531547', 'tz-check', 'video' and 'misc-2.6.34' into release

commit 149fe9c293f76803206648270ca24fc2604d5f01
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 22 12:12:00 2010 -0700

    ACPI: processor: push file static MADT pointer into internal map_madt_entry()
    
    There's no real need for a pointer to the MADT to be global. The only
    function who uses it is map_madt_entry.
    
    This allows us to remove some more ugly #ifdefs.
    
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eae701ceadf5aa3fc3b334029ef71f6885ef1cde
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 22 12:11:55 2010 -0700

    ACPI: processor: refactor internal map_lsapic_id()
    
    Un-nest the if statements for readability.
    
    Remove comments that re-state the obvious.
    
    Change the control flow so that we no longer need a temp variable.
    
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d67420956b7b1dcffb894b2f1f81b9408fca1b4c
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 22 12:11:50 2010 -0700

    ACPI: processor: refactor internal map_x2apic_id()
    
    Untangle the nested if conditions to make this function look
    more similar to the other map_*apic_id() functions.
    
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 11130736c99c37e253f45b2d3fd30b07313f83c6
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 22 12:11:44 2010 -0700

    ACPI: processor: refactor internal map_lapic_id()
    
    Untangle the if() statement a little for readability.
    
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d8191fa4a33fdc817277da4f2b7f771ff605a41c
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 22 12:11:39 2010 -0700

    ACPI: processor: driver doesn't need to evaluate _PDC
    
    Now that the early _PDC evaluation path knows how to correctly
    evaluate _PDC on only physically present processors, there's no
    need for the processor driver to evaluate it later when it loads.
    
    To cover the hotplug case, push _PDC evaluation down into the
    hotplug paths.
    
    Cc: x86@kernel.org
    Cc: Tony Luck <tony.luck@intel.com>
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b1da4c5d1032ebc29fec8bd8f592ba6589be8ed
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 22 12:11:34 2010 -0700

    ACPI: processor: remove early _PDC optin quirks
    
    Now that we check for physically present processors before blindly
    evaluating _PDC, we no longer need to maintain a DMI opt-in table
    nor a kernel param.
    
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5d554a7bb0643a6151a84319bfeba8270bf5269e
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 22 12:11:29 2010 -0700

    ACPI: processor: add internal processor_physically_present()
    
    Detect if a processor is physically present before evaluating _PDC.
    
    We want this because some BIOS will provide a _PDC even for processors
    that are not present. These bogus _PDC methods then attempt to load
    non-existent tables, which causes problems.
    
    Avoid those bogus landmines.
    
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 78ed8bd2944b6400f742306e5fe9d1b9b6bf18ba
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 22 12:11:24 2010 -0700

    ACPI: processor: move acpi_get_cpuid into processor_core.c
    
    Enumerating processors (via MADT/_MAT) belongs in the processor core,
    which is always built-in, rather than living in the processor driver
    which may not be built.
    
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2e9d5e4efa0beeca03ad550bda28027826e83e42
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 22 12:11:19 2010 -0700

    ACPI: processor: export acpi_get_cpuid()
    
    Rename static get_cpu_id() to acpi_get_cpuid() and export it.
    
    This change also gives us an opportunity to remove the
    #ifndef CONFIG_SMP from processor_driver.c and into a header file
    where it properly belongs.
    
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4d5d4cd88c542ff56cf7feacd29cc907f2abbfbb
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 22 12:11:14 2010 -0700

    ACPI: processor: mv processor_pdc.c processor_core.c
    
    We've renamed the old processor_core.c to processor_driver.c, to
    convey the idea that it can be built modular and has driver-like
    bits.
    
    Now let's re-create a processor_core.c for the bits needed
    statically by the rest of the kernel. The contents of processor_pdc.c
    are a good starting spot, so let's just rename that file and
    complete our three card monte.
    
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0131aa3dd7dcf41c66784b96ff351f63ee3ef348
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 22 12:11:08 2010 -0700

    ACPI: processor: mv processor_core.c processor_driver.c
    
    The ACPI processor driver can be built as a module. But it has
    pieces of code that should always be built statically into the
    kernel.
    
    The plan is for processor_core.c to contain the static bits while
    processor_driver.c contains the module-like bits.
    
    Since the bulk of the code in the current processor_core.c is
    module-like, first step is to rename the file to processor_driver.c
    
    Next step will re-create processor_core.c and cherry-pick out
    the static bits.
    
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4c81ba4900ab4eb24c7d2ba1aca594c644b6ce4c
Author: Len Brown <len.brown@intel.com>
Date:   Sun Mar 14 16:28:46 2010 -0400

    ACPI: plan to delete "acpi=ht" boot option
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8144c880397d502d12af4ef721f3eac50163fa39
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 18 23:42:47 2010 -0500

    ACPI: remove "acpi=ht" DMI blacklist
    
    SuSE added these entries when deploying ACPI in Linux-2.4.
    I pulled them into Linux-2.6 on 2003-08-09.
    Over the last 6+ years, several entries have proven to be
    unnecessary and deleted, while no new entries have been added.
    Matthew suggests that they now have negative value, and I agree.
    
    Based-on-patch-by: Matthew Garrett <mjg59@srcf.ucam.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7e0e9c042790d4ea44c6a00ddaad8b8bbcc3f17f
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Mar 5 10:47:57 2010 -0700

    PNPACPI: add bus number support
    
    Add support for bus number resources.  This is for bridges with a range of
    bus numbers behind them.  Previously, PNP ignored bus number resources.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fa35b49260b615d634bfa1f767aa315fa323c2e9
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Mar 5 10:47:52 2010 -0700

    PNPACPI: add window support
    
    Add support for resource windows.  This is for bridge resources, i.e.,
    regions where a bridge forwards transactions from the primary to the
    secondary side.  This does not add support for *setting* windows via
    the /proc interface.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9d7cca04211d4eb104eaaa424b98f650bc29c730
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Mar 5 10:47:47 2010 -0700

    resource: add window support
    
    Add support for resource windows.  This is for bridge resources, i.e.,
    regions where a bridge forwards transactions from the primary to the
    secondary side.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0f4050c7d3ba0275e5f39513c0670a717d43048c
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Mar 5 10:47:42 2010 -0700

    resource: add bus number support
    
    Add support for bus number resources.  This is for bridges with a range of
    bus numbers behind them.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cd7e9fcd1f7c9c397f747cf506c66f7dca11d1c6
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Mar 5 10:47:26 2010 -0700

    resource: expand IORESOURCE_TYPE_BITS to make room for bus resource type
    
    No functional change; this just makes room for another resource type.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d06070509147c948a06056da619c9dc2ed349805
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Feb 25 10:59:34 2010 +0800

    acpiphp: Execute ACPI _REG method for hotadded devices
    
    Per ACPI spec, _ERG method should be executed before device driver
    gets control for hotpluged device. Firmware might do some configuration
    there. See http://bugzilla.kernel.org/show_bug.cgi?id=10805. In this
    machine, _REG method of docked device will configure cardbus bridge.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Tested-by: Paul Martin <pm@debian.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 70287db87cfc968fe78bf82a489833cc77b84352
Author: Matthew Garrett <mjg@redhat.com>
Date:   Tue Feb 16 16:53:50 2010 -0500

    ACPI video: Be more liberal in validating _BQC behaviour
    
    Right now, if _BQC returns a value we don't understand we immediately
    invalidate it. Change this behaviour so we only invalidate it if it
    continues to give an invalid answer after we've already set a brightness.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f6bb13aa1ea3bb26a4c783822347873f085b9000
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Mar 4 01:52:58 2010 +0100

    ACPI / EC / PM: Close race between EC and resume from hibernation
    
    There is a race between resume from hibernation and the EC driver
    that may result in restoring the hibernation image in the middle of
    an EC transaction in progress, which in turn may lead to
    unpredictable behavior of the platform.
    
    To remove that race condition, add a helpers for suspending and
    resuming EC transactions in a safe way to be executed by the ACPI
    platform hibernate pre-restore and restore cleanup callbacks.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14668
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Reported-and-tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fa80945269f312bc609e8384302f58b03c916e12
Author: Thomas Renninger <trenn@suse.de>
Date:   Sat Feb 20 11:44:27 2010 +0100

    ACPI thermal: Don't invalidate thermal zone if critical trip point is bad
    
    V2: Corrected integer/long conversion.
    
    Some BIOSes return a negative value for the critical trip point.
    Especially since Windows 2006...
    We currently invalidate the whole thermal zone in this case.
    But it may still be needed for cooling, also without critical
    trip point.
    
    This patch invalidates the critical trip point if no _CRT
    function is found or if it returns negative values, but does
    not invalidate the whole thermal zone in this case.
    
    Reference: http://bugzilla.novell.com/show_bug.cgi?id=531547
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Tested-by: clarkt@cnsp.com
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8b7ef6d8f16274da42344cd50746ddb1c93c25ea
Author: Thomas Renninger <trenn@suse.de>
Date:   Tue Feb 16 22:55:51 2010 +0100

    ACPI thermal: Check for thermal zone requirement
    
    ACPI spec says (11.5 Thermal Zone Interface Requirements):
       A thermal zone must contain at least one trip point
       (critical, near critical, active, or passive)
    
    Check this once at init time.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Tested-by: clarkt@cnsp.com
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 38bcb37a6f63fcdfcc0dd0af3ec5c03a4b7be48e
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Tue Feb 2 14:37:56 2010 -0800

    ACPICA: fix acpi_ex_release_mutex() comment
    
    trivial, leftover from my NULL pointer dereference patch which got
    'superseded' by commit fbc3be2
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ded180e7ebfc324b36a94931f99d0705dcd8da29
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Tue Feb 2 14:37:55 2010 -0800

    ACPI: remove superfluous NULL pointer check from acpi_processor_get_throttling_info()
    
    Dan's list contains:
    
    drivers/acpi/processor_throttling.c +1139 acpi_processor_get_throttling_info(11) warning: variable derefenced before check 'pr'
    
    acpi_processor_get_throttling_info() is never called with pr == NULL.
    
    [ bart: the potential NULL pointer dereference was finally fixed in
      (much later than mine) commit 5cfa245 but my patch is still valid ]
    
    Reported-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0e026445fb36852d3102cb8bb24868765fe5816a
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 16 03:01:42 2010 -0500

    ACPI: delete unused acpi_evaluate_string()
    
    Roel found a logic issue in the #if 0 acpi_evaluate_string():
    
    -           || (element->type != ACPI_TYPE_BUFFER)
    +           && (element->type != ACPI_TYPE_BUFFER)
    
    delete the dead code.
    
    pointed-out-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c67fcd670b55e89e0c129fbf7fae854bd1f8bfa6
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Oct 15 14:31:44 2009 +0400

    ACPI: Battery: Add support for _BIX extended info method
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 16698857fba1b10af4890055272975adf5686e83
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Oct 15 14:31:37 2009 +0400

    ACPI: SBS: Export cycle_count
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c955fe8e0bdd7be7a6bc2d49245d570a816f7cc5
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Oct 15 14:31:30 2009 +0400

    POWER: Add support for cycle_count
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7b3bcc4a1a7cd2d53b403ca29d06ceb5fa617eb7
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Oct 15 14:31:24 2009 +0400

    ACPI: Battery: Add bit flags
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0c99c5288eb9b1bbc9684b0ec0fd7efc578749b3
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Dec 17 16:02:08 2009 +0800

    ACPI: Disable explicit power state retrieval on fans
    
    If the ACPI power state can be got both directly and indirectly,
    we prefer to get it indirectly.
    
    https://bugzilla.redhat.com/show_bug.cgi?id=531916 describes a
    system with a _PSC method for the fan that always returns "on".
    There's no benefit in us always requesting the state of the fan
    when performing transitions - we want to do everything we can
    to ensure that the fan turns on when it should do, not risk
    hardware damage by believing the hardware when it tells us the
    fan is already on. Given that the Leading Other OS(tm) works fine
    on this machine, it seems likely that it behaves in much this way.
    
    inspired-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cffdde993a016bedbc2f5eb60d00c3a766ffb612
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Thu Dec 24 00:02:30 2009 -0800

    sony-laptop - switch from workqueue to a timer
    
    The function that is executing in workqueue context does not need
    to sleep so let's switch to a timer which is more lightweight.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c45bc9d62c39202b401d1bf7bb2812abb88798a1
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Thu Dec 24 00:02:23 2009 -0800

    sony-laptop - simplify keymap initialization
    
    Also use input_set_capability() helper instead of manipulating
    bits directly.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9593bd07ec8eaaa30aba4281b2b3273282fc344f
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Thu Dec 24 00:02:16 2009 -0800

    sony-laptop - remove private workqueue, use keventd instead
    
    If we reschedule work instead of having work function sleep for 10 msecs
    between reads from kfifo we can safely use the main workqueue (keventd)
    and not bother with creating driver-private one.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>

