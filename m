Return-Path: <linux-kernel-owner+w=401wt.eu-S1946398AbXBQDZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946398AbXBQDZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 22:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946395AbXBQDZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 22:25:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:43742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946391AbXBQDZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 22:25:23 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PATCH] ACPI patches for 2.6.21 - part II (resend)
Date: Fri, 16 Feb 2007 22:23:59 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702162223.59837.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This...

Fixes some battery, thermal, and fan related bugs.
Adds the sony-laptop driver, which controls brightness on akpm's vaio...
Removes the experimental hotkey driver, per schedule.
Adds the ACPI support needed by the upcoming rtc driver
Fixes a suspend regression caused by part I
Fixes an IA64 processor driver regression caused by part I

... and updates the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.20/acpi-release-20070126-2.6.20.diff.gz

 Documentation/acpi-hotkey.txt              |   38 
 Documentation/feature-removal-schedule.txt |   23 
 Documentation/sony-laptop.txt              |  106 +
 MAINTAINERS                                |    9 
 arch/i386/kernel/acpi/boot.c               |    5 
 arch/ia64/kernel/acpi.c                    |    4 
 arch/x86_64/kernel/early-quirks.c          |    4 
 drivers/acpi/Kconfig                       |   10 
 drivers/acpi/Makefile                      |    1 
 drivers/acpi/ac.c                          |    9 
 drivers/acpi/acpi_memhotplug.c             |    9 
 drivers/acpi/asus_acpi.c                   |   20 
 drivers/acpi/battery.c                     |   24 
 drivers/acpi/bay.c                         |  107 -
 drivers/acpi/bus.c                         |   30 
 drivers/acpi/button.c                      |    7 
 drivers/acpi/cm_sbs.c                      |    2 
 drivers/acpi/container.c                   |    9 
 drivers/acpi/debug.c                       |    2 
 drivers/acpi/dispatcher/dsmethod.c         |   12 
 drivers/acpi/dock.c                        |    8 
 drivers/acpi/ec.c                          |    9 
 drivers/acpi/event.c                       |    2 
 drivers/acpi/events/evgpe.c                |   11 
 drivers/acpi/events/evmisc.c               |   11 
 drivers/acpi/executer/exdump.c             |    2 
 drivers/acpi/executer/exmutex.c            |   36 
 drivers/acpi/fan.c                         |    9 
 drivers/acpi/glue.c                        |   62 +
 drivers/acpi/hardware/hwsleep.c            |   13 
 drivers/acpi/hotkey.c                      | 1042 -----------------
 drivers/acpi/i2c_ec.c                      |    5 
 drivers/acpi/ibm_acpi.c                    |   18 
 drivers/acpi/numa.c                        |   18 
 drivers/acpi/osl.c                         |   35 
 drivers/acpi/pci_bind.c                    |    2 
 drivers/acpi/pci_irq.c                     |    2 
 drivers/acpi/pci_link.c                    |    5 
 drivers/acpi/pci_root.c                    |    5 
 drivers/acpi/power.c                       |  156 ++
 drivers/acpi/processor_core.c              |   13 
 drivers/acpi/processor_idle.c              |   11 
 drivers/acpi/processor_perflib.c           |    3 
 drivers/acpi/processor_thermal.c           |    3 
 drivers/acpi/processor_throttling.c        |    3 
 drivers/acpi/sbs.c                         |   25 
 drivers/acpi/scan.c                        |    3 
 drivers/acpi/sleep/main.c                  |    3 
 drivers/acpi/system.c                      |    3 
 drivers/acpi/tables.c                      |   41 
 drivers/acpi/tables/tbxface.c              |    9 
 drivers/acpi/thermal.c                     |   37 
 drivers/acpi/toshiba_acpi.c                |    6 
 drivers/acpi/utilities/utdelete.c          |    1 
 drivers/acpi/utils.c                       |    2 
 drivers/acpi/video.c                       |    9 
 drivers/misc/Kconfig                       |   15 
 drivers/misc/Makefile                      |    1 
 drivers/misc/asus-laptop.c                 |    5 
 drivers/misc/sony-laptop.c                 |  562 +++++++++
 drivers/pnp/pnpacpi/Kconfig                |   16 
 drivers/usb/misc/appledisplay.c            |    4 
 include/acpi/acinterp.h                    |    3 
 include/acpi/acobject.h                    |    2 
 include/acpi/acpi_drivers.h                |   40 
 include/acpi/acpiosxf.h                    |    6 
 include/asm-i386/acpi.h                    |    1 
 include/linux/acpi.h                       |    8 
 68 files changed, 1170 insertions(+), 1547 deletions(-)

through these commits:

Ahmed S. Darwish (1):
      ACPI: toshiba_acpi: Use ARRAY_SIZE macro when appropriate

Al Viro (1):
      ACPI: bay: fix wrong order of kzalloc arguments

Alessandro Guido (2):
      sony_acpi: Add backlight support to the sony_acpi
      sony_acpi: Add backlight support to the sony_acpi v2

Alexey Starikovskiy (7):
      ACPI: Disable GPEs in preparation for sleep.
      ACPI: invoke acpi_sleep_init() earlier
      ACPI: IA64: fix calculation of apic_id
      ACPI: Disable wake GPEs only once.
      ACPICA: fix AML mutex re-entrancy
      Execute AML Notify() requests on stack.
      ACPI: ec: add unlock in error path

Andrew Morton (4):
      ACPI: bay: fix build warning
      sony_acpi: Avoid dimness on resume.
      sony_acpi: Fix sony_acpi_resume call
      sony_acpi: Video sysfs support take 2

David Brownell (1):
      ACPI: updates rtc-cmos device platform_data

Henrique de Moraes Holschuh (2):
      ACPI: ibm-acpi: cleanup init and exit paths
      ACPI: bay: use IS_ERR for return of register_platform_device_simple

John Keller (2):
      ACPI: acpi_unload_table_id() always returns error
      ACPI: IA64: react to acpi_table_parse() return value change

Konstantin Karasyov (2):
      ACPI: Thermal issues on HP nx6325
      ACPI: fix fan after resume from S3

Kristen Carlson Accardi (1):
      ACPI: bay: remove ACPI driver struct

Len Brown (13):
      ACPI: add video driver MAINTAINER
      ACPI: clean up ACPI_MODULE_NAME() use
      ACPI: fix acpi_driver.name usage
      ACPI: delete extra #defines in /drivers/acpi/ drivers
      ACPI: acpi_table_parse() now returns success/fail, not count
      ACPI: acpi_madt_entry_handler() is not MADT specific
      ACPI: acpi_table_parse_madt_family() is not MADT specific
      sony-laptop: Lindent
      ACPI: remove acpi_os_readable(), acpi_os_writable()
      ACPI: always enable CONFIG_PNPACPI on CONFIG_ACPI kernels
      ACPI: remove non-PNPACPI version of get_rtc_dev()
      ACPI: update acpi_power_resume() per new acpi_op_resume
      ACPI: hotkey: remove driver, per feature-removal-schedule.txt

Matthew C Campbell (1):
      ACPI: asus_acpi: Add support for Asus Z81SP

Mattia Dongili (11):
      sony_acpi: Allow easier debugging for the unknown SNC methods.
      sony_acpi: Add lanpower and audiopower controls
      sony_acpi: Allow multiple sony_acpi_values for the same .name
      sony_acpi: Fix sony_acpi backlight registration and unregistration
      sony-laptop: create from sony_acpi
      sony-laptop: Remove /proc/acpi/sony interface and implement platform_device.
      sony-laptop: Small update to the Kconfig help to make people believe this driver is useful.
      sony-laptop: Group functions and structures to better draw subsytems usage
      sony-laptop: Update docs
      sony-laptop: add to MAINTAINERS
      sony-laptop: allow complex per-value input/output validation

Michael Hanselmann (1):
      ACPI: video: Fix null pointer in appledisplay driver

Randy Dunlap (1):
      ACPI: Fix sparse warnings

Rusty Russell (1):
      ACPI: cleanup: make disable_acpi() valid w/o CONFIG_ACPI

Sanjoy Mahajan (1):
      ACPI: thermal: fix units in debug output

Stelian Pop (2):
      sony_acpi: SNC device support for Sony Vaios
      sony_acpi: Add acpi_bus_generate event

Thomas Gleixner (1):
      ACPI: include apic.h in processor driver for benefit of UP kernels

Vladimir Lebedev (2):
      ACPI: battery: check for battery present on /proc/battery access
      ACPI: sbs: fix present rate

with this log:

commit 255f0385c8e0d6b9005c0e09fffb5bd852f3b506
Merge: 902b236... e6d0f56...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 16 22:12:04 2007 -0500

    Pull bugzilla-7897 into release branch

commit 902b236c087bf021c94cc21a2b09d928c4156c2b
Merge: 08e4a10... aafbcd1...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 16 22:11:57 2007 -0500

    Pull bugzilla-7887 into release branch

commit 08e4a10ec82faf5ba67c8d0115b7bc9e58071555
Merge: 4559b43... b1028c5...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 16 22:11:50 2007 -0500

    Pull bugzilla-7570 into release branch

commit 4559b438225b01942e1661759db0df55883b1bc0
Merge: 1004879... 4bd35cd...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 16 22:11:37 2007 -0500

    Pull bugzilla-7200 into release branch

commit 1004879f25c5719517b3d8a3180a517e190e2f5b
Merge: f0e5ed7... e8363f3...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 16 22:11:31 2007 -0500

    Pull bugzilla-7122 into release branch

commit f0e5ed7f323db4e47b51da4a23fad8245c173081
Merge: 8800c0e... 5f7748c...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 16 22:11:21 2007 -0500

    Pull bugzilla-5534 into release branch

commit 8800c0ebf5e8363dab66647512dcef5b83203dec
Merge: 9cdd79c... 5ee6edb...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 16 22:11:02 2007 -0500

    Pull remove-hotkey into release branch

commit 9cdd79c9b99873d600d397fda012fc3f57cc2776
Merge: c0cd79d... 156c221...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 16 22:10:55 2007 -0500

    Pull sony into release branch

commit c0cd79d11412969b6b8fa1624cdc1277db82e2fe
Merge: 81450b7... db2d4cc...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 16 22:10:32 2007 -0500

    Pull fluff into release branch
    
    Conflicts:
    
    	arch/x86_64/pci/mmconfig.c
    	drivers/acpi/bay.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit db2d4ccdc8f9f3433d3a8566404189f2e9295c23
Author: John Keller <jpk@sgi.com>
Date:   Fri Feb 16 15:07:27 2007 -0600

    ACPI: IA64: react to acpi_table_parse() return value change
    
    acpi_boot_init() is making a bad check on the return
    status from acpi_table_parse(). acpi_table_parse() now
    returns zero on success, one on failure.
    
    Signed-off-by: Aaron Young <ayoung@sgi.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5ee6edbcde4d3b14e4e03d4b331df1099a34aa8d
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 10 01:18:25 2007 -0500

    ACPI: hotkey: remove driver, per feature-removal-schedule.txt
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 81450b73dde07f473a4a7208b209b4c8b7251d90
Merge: 8a03d9a... 0539771...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 16 18:52:41 2007 -0500

    Pull misc-for-upstream into release branch
    
    Conflicts:
    
    	drivers/usb/misc/appledisplay.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0539771d7236b425f285652f6f297cc7939c8f9a
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Feb 14 10:55:00 2007 -0200

    ACPI: bay: use IS_ERR for return of register_platform_device_simple
    
    register_platform_device_simple returns ERR_PTR(foo), so test it with
    IS_ERR(foo).
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ecb5f7521a309cb9c5fc0832b9705cd2a03d7d45
Author: John Keller <jpk@sgi.com>
Date:   Thu Feb 15 14:08:30 2007 -0600

    ACPI: acpi_unload_table_id() always returns error
    
    acpi_unload_table_id() is always returning an error status.
    Also, once the matching table is found, don't bother looking
    for another match.
    
    Signed-off-by: John Keller <jpk@sgi.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c24e912b61b1ab2301c59777134194066b06465c
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Thu Feb 15 23:16:18 2007 +0300

    ACPI: ec: add unlock in error path
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b1028c545ced13590dd9a9a8086543aef26c7187
Author: Konstantin Karasyov <konstantin.a.karasyov@intel.com>
Date:   Fri Feb 16 02:23:07 2007 -0500

    ACPI: fix fan after resume from S3
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7570
    
    Signed-off-by: Konstantin Karasyov <konstantin.a.karasyov@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e8363f332757ac22395fb120cc33b3262f9ee26c
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 16 02:05:39 2007 -0500

    ACPI: update acpi_power_resume() per new acpi_op_resume
    
    drivers/acpi/power.c:69: warning: initialization from incompatible pointer type
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0a6139027f3986162233adc17285151e78b39cac
Author: Konstantin Karasyov <konstantin.a.karasyov@intel.com>
Date:   Fri Feb 16 01:47:06 2007 -0500

    ACPI: Thermal issues on HP nx6325
    
    The previous reference counting scheme to enable power resources
    got confused when multiple devices were present that might
    repeatedly enable or disable the resource and throw off the count.
    
    The new code simply lists the referencing devices which
    are requesting the resource to be enabled.  When there are none,
    then it is off.
    
    Signed-off-by: Konstantin Karasyov <konstantin.a.karasyov@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 636cedf9df6a6442364e78b51925f306a1056e43
Author: Sanjoy Mahajan <sanjoy@mrao.cam.ac.uk>
Date:   Fri Feb 16 01:24:43 2007 -0500

    ACPI: thermal: fix units in debug output
    
    http://bugzilla.kernel.org/show_bug.cgi?id=4972
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5c95d3f5783ab184f64b7848f0a871352c35c3cf
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Feb 15 23:25:53 2007 -0500

    ACPI: include apic.h in processor driver for benefit of UP kernels
    
    apic.h does not get included on UP compiles.  That way the
    APICTIMER_STOPS_ON_C3 is not there and UP boxen have no support for timer
    broadcasting.  This was never noticed, because the lapic timer is only used
    for profiling on UP.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Cc: Roman Zippel <zippel@linux-m68k.org>
    Cc: john stultz <johnstul@us.ibm.com>
    Cc: Andi Kleen <ak@suse.de>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8d4956c201c2f7683289f70095443c59a39f94ef
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 15 22:46:42 2007 -0500

    ACPI: remove non-PNPACPI version of get_rtc_dev()
    
    It isn't needed in ACPI code anymore because
    now ACPI always includes PNPACPI.
    
    Cc: David Brownell <david-b@pacbell.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 243b66e76ab722cdec1921d7f80c0cb808131c37
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 15 22:34:36 2007 -0500

    ACPI: always enable CONFIG_PNPACPI on CONFIG_ACPI kernels
    
    We removed the ACPI motherboard driver which handled
    the ACPI=y, PNP=n case, so now we need to enforce that
    PNP & PNPACPI are always enabled for ACPI kernels.
    
    Most major distros ship this way this already.
    
    Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fc955f670c0a66aca965605dae797e747b2bef7d
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 15 22:11:48 2007 -0500

    ACPI: remove acpi_os_readable(), acpi_os_writable()
    
    ...which are now unused
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 70c0846e430881967776582e13aefb81407919f1
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Tue Feb 13 16:11:36 2007 -0800

    ACPI: Fix sparse warnings
    
    Use NULL for pointers
    
    drivers/acpi/osl.c:208:10: warning: Using plain integer as NULL pointer
    drivers/acpi/tables/tbxface.c:411:49: warning: Using plain integer as NULL pointer
    drivers/acpi/processor_core.c:1008:10: warning: Using plain integer as NULL pointer
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5f7748cf91558a5026ded5be93c5bf6c1ac34edf
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Thu Feb 15 16:13:51 2007 -0500

    Execute AML Notify() requests on stack.
    
    HP nx6125/nx6325/... machines have a _GPE handler with an infinite
    loop sending Notify() events to different ACPI subsystems.
    
    The notify handler in the ACPI thermal driver is a C-routine,
    which may invoke the ACPI interpreter again to get access
    to some ACPI variables such as temperature.  (acpi_evaluate_xxx)
    On these HP machines such an evaluation changes state of an ASL variable
    and lets the loop above break.
    
    In the current ACPI implementation, Notify requests are being deferred
    to the same kacpid workqueue on which the above GPE handler with
    infinite loop is executing. Thus we have a deadlock -- loop will
    continue to spin, sending notify events, and at the same time
    preventing these notify events from being run on a workqueue. All
    notify events are deferred, thus we see explosion in memory consumption.
    
    Also as GPE handling is blocked, machines overheat because ACPI-based
    fan control is stalled.  Eventually by external poll of the same
    acpi_evaluate, kacpid is released and all the queued notify events are
    free to run, thus 100% CPU utilization by kacpid for several seconds
    or more.
    
    To prevent this failure,  Linux must not send notify events to the
    kacpid workqueue -- either executing them immediately or putting them
    on some other thread.
    
    The first attempt to create a new thread was done by Peter Wainwright
    He created a bunch of threads, which were stealing work from a kacpid
    workqueue.
    This patch appeared in 2.6.15-based kernel shipped with Ubuntu 6.06 LTS.
    
    Second attempt was done by Alexey Starikovskiy, who created a new thread
    for each Notify event. This worked OK on HP nx machines,
    but broke Linus' Compaq n620c, by producing threads with a speed what
    they stopped the machine completely.
    Thus this patch was reverted from 2.6.18-rc2.
    
    Alexey re-made the patch to create second workqueue just for notify events,
    thus hopping it will not break Linus' machine. Patch was tested on the
    same HP nx machines in #5534 and #7122, but this broke Linus' machine
    also and was reverted from 2.6.19-rc with much fanfair.
    
    The 4th patch inserted schedule_timeout(1) into deferred
    execution of kacpid, if we had any notify requests pending, but Linus
    decided that it was too complex (involved either changes to workqueue
    to see if it's empty or atomic inc/dec).  Then a 5th attempt did a
    yield() to every GPE execution.
    
    Finally, this 6th generation patch simply executes the notify handler
    on the stack.  Previous attempts to do this simple solution failed
    because of issues in AML mutex re-entrancy which are now fixed
    by the previous patch in this series.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=5534
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c0d127b56937c3e72c2b1819161d2f6718eee877
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Thu Feb 15 16:12:23 2007 -0500

    ACPICA: fix AML mutex re-entrancy
    
    ACPI AML supports "serialized" methods which are protected
    by an implicit mutex.  The mutex is re-entrant for that AML thread
    to allow recursion.
    
    However, Linux implements notify() by creating a new AML thread.
    So for systems where notify() re-enters a serialized method,
    deadlock results.
    
    The fix is to use the Linux thread_id as the key to allowing
    re-entrancy, not the AML thread pointer.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=5534
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 156c221b728ccd4657c359cd25428946856beca8
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Feb 12 22:01:07 2007 +0100

    sony-laptop: allow complex per-value input/output validation
    
    Replace sony_acpi_value.{min,max} with a callback function that allows
    more complex reasoning in accepting input and presenting output.
    
    This allows consistency between the sony-laptop specific 'brightness_default'
    and the backlight subsystem 0-based 'brightness'.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0d477faca3a661908378b602c3d12df73c922c9f
Author: Mattia Dongili <malattia@linux.it>
Date:   Thu Feb 8 20:16:40 2007 +0100

    sony-laptop: add to MAINTAINERS
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ab5bd20696485a3f8c2f27058ace1cc1d6b580b3
Author: Mattia Dongili <malattia@linux.it>
Date:   Thu Feb 8 20:16:41 2007 +0100

    sony-laptop: Update docs
    
    Update documentation to be consistent with current implementation
    (backlight subsys and platform_device).
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a02d1c1d2aa8ad4b2ed8da25e234c8962973f1b8
Author: Len Brown <len.brown@intel.com>
Date:   Wed Feb 7 15:34:02 2007 -0500

    sony-laptop: Lindent
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d78865cdb096781382074943c1b7781696b178a6
Author: Mattia Dongili <malattia@linux.it>
Date:   Wed Feb 7 20:01:56 2007 +0100

    sony-laptop: Group functions and structures to better draw subsytems usage
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 287ddfd522097257dadf37deb21969ad4dbc8148
Author: Mattia Dongili <malattia@linux.it>
Date:   Wed Feb 7 20:01:55 2007 +0100

    sony-laptop: Small update to the Kconfig help to make people believe this driver is useful.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ed3aa4b729478978f117269b5266a2d18948912c
Author: Mattia Dongili <malattia@linux.it>
Date:   Wed Feb 7 20:01:54 2007 +0100

    sony-laptop: Remove /proc/acpi/sony interface and implement platform_device.
    
    Rework method names list to allow an easier management of multiple
    values.
    Add myself as author/maintainer and bump the version number.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 91fbc1d311c1b8b71203b96f1a0629da7360eb4c
Author: Mattia Dongili <malattia@linux.it>
Date:   Wed Feb 7 20:01:53 2007 +0100

    sony-laptop: create from sony_acpi
    
    Move drivers/acpi/sony_acpi.c to drivers/misc/sony-laptop.c with all the
    necessary configuration.
    The SONY_LAPTOP config option substitutes the old ACPI_SONY and is 'default n'
    now.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7df03b82ed081777d2393ff8a5fb9d4a3a560f26
Author: Mattia Dongili <malattia@linux.it>
Date:   Sat Jan 13 23:04:41 2007 +0100

    sony_acpi: Fix sony_acpi backlight registration and unregistration
    
    Initialize the current brightness if the driver registration
    was successful and unregister the driver in the error exit path.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 57ede701af3bc0c153070133e7831332ffa1d761
Author: Mattia Dongili <malattia@linux.it>
Date:   Sat Jan 13 23:04:40 2007 +0100

    sony_acpi: Allow multiple sony_acpi_values for the same .name
    
    The acpi handles are kept _only_ if both the requested .acpiget and .acpiset
    are available in the DSDT.
    Currently only the SCDP/CDPW dualism is known.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4465857d5f99079bae00621626adf74ed8256296
Author: Mattia Dongili <malattia@linux.it>
Date:   Sat Jan 13 23:04:39 2007 +0100

    sony_acpi: Add lanpower and audiopower controls
    
    audiopower works well on my SZ72B so it's not marked has "debug" while lanpower
    has at least one report of not resuming power happily so morked as "debug"
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 05e2d8274ef4504db9941f7c515f340ab6c0b2e1
Author: Mattia Dongili <malattia@linux.it>
Date:   Sat Jan 13 23:04:38 2007 +0100

    sony_acpi: Allow easier debugging for the unknown SNC methods.
    
    Allow the existence of a setter method without a getter and viceversa,
    additionaly set /proc file permissions reflecting it.
    Fix also the error exit path.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c561162f10b9f35c9aa5c25eb8dbeb446f0c5201
Author: Stelian Pop <stelian@popies.net>
Date:   Sat Jan 13 23:04:37 2007 +0100

    sony_acpi: Add acpi_bus_generate event
    
    Added acpi_bus_generate event for forwarding Fn-keys pressed to acpi subsystem,
    and made correspondent necessary changes for this to work.
    
    Signed-off-by: Nilton Volpato <nilton.volpato@gmail.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 82c47731f77e7615f5a952c662d873b55e71f3b9
Author: Andrew Morton <akpm@osdl.org>
Date:   Sat Jan 13 23:04:36 2007 +0100

    sony_acpi: Video sysfs support take 2
    
    add dev argument for backlight_device_register
    
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 243e8b191df4e9c11e62ea11fa298351997e98c3
Author: Alessandro Guido <alessandro.guido@gmail.com>
Date:   Sat Jan 13 23:04:35 2007 +0100

    sony_acpi: Add backlight support to the sony_acpi v2
    
    Enable the sony_acpi driver to use the backlight subsysyem for adjusting
    the monitor brightness.  Old way of changing the brightness will be still
    available for compatibility with existing tools.
    
    Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 50f62afb114ffcf052cf07d4b49b2d148b749955
Author: Alessandro Guido <alessandro.guido@gmail.com>
Date:   Sat Jan 13 23:04:34 2007 +0100

    sony_acpi: Add backlight support to the sony_acpi
    
    Make the sony_acpi use the backlight subsystem to adjust brightness value
    instead of using the /proc/sony/brightness file.  (Other settings will
    still have a /proc/sony/...  entry)
    
    Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>
    Cc: Stelian Pop <stelian@popies.net>
    Cc: Richard Purdie <rpurdie@rpsys.net>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fac3506100c19391bc5474084dd838f0fb87bf26
Author: Andrew Morton <akpm@osdl.org>
Date:   Sat Jan 13 23:04:33 2007 +0100

    sony_acpi: Fix sony_acpi_resume call
    
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3f4f461fa816815b9338047a29cf2521f23f1783
Author: Andrew Morton <akpm@osdl.org>
Date:   Sat Jan 13 23:04:32 2007 +0100

    sony_acpi: Avoid dimness on resume.
    
    Doesn't work.
    
    Cc: Stelian Pop <stelian@popies.net>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7f09c432bed80cecfba634933ddc06735e64da00
Author: Stelian Pop <stelian@popies.net>
Date:   Sat Jan 13 23:04:31 2007 +0100

    sony_acpi: SNC device support for Sony Vaios
    
    From: Bjorn Helgaas <bjorn.helgaas@hp.com>
    
      Even though the devices claimed by sony_acpi.c can not be hot-plugged, the
      driver registration infrastructure allows the .add() and .remove() methods
      to be called at any time while the driver is registered.  So remove __init
      and __exit from them.
    
    From: Matthew Garrett <mjg59@srcf.ucam.org>
    
    [UBUNTU:acpi/sony] Add FN hotkey support
    Source URL of Patch:
    http://www.kernel.org/git/?p=linux/kernel/git/bcollins/ubuntu-dapper.git;a=commitdiff;h=7a9b49cba4919e8506604629db03add8e0b85767
    
    Signed-off-by: Ben Collins <bcollins@ubuntu.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6eb87fed52b7f6ac200eaa649cc3221e239d0113
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 10 22:17:07 2007 -0500

    ACPI: acpi_table_parse_madt_family() is not MADT specific
    
    acpi_table_parse_madt_family() is also used to parse SRAT entries.
    So re-name it to acpi_table_parse_entries(), and re-name the
    madt-specific variables within it accordingly.
    
    cosmetic only.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5a8765a84c31ea51baf1f6c78116cd877bd8cd64
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 10 21:35:47 2007 -0500

    ACPI: acpi_madt_entry_handler() is not MADT specific
    
    acpi_madt_entry_handler() is also used for the SRAT,
    so re-name it acpi_table_entry_handler().
    
    cosmetic only.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7f8f97c3cc75d5783d0b45cf323dedf17684be19
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 10 21:28:03 2007 -0500

    ACPI: acpi_table_parse() now returns success/fail, not count
    
    Returning count for tables that are supposed to be unique
    was useless and confusing.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Tue Feb 13 02:35:50 2007 -0500

    ACPI: Disable wake GPEs only once.
    
    fixes Suspend/Resume regressions due to recent ACPICA update.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a795ca5852fb944f21bd71c1230fcc5456e7d5ef
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Feb 12 14:39:38 2007 +1100

    ACPI: cleanup: make disable_acpi() valid w/o CONFIG_ACPI
    
    Len Brown <lenb@kernel.org> said:
    > Okay, but better to use disable_acpi()
    > indeed, since this would be the first code not already inside CONFIG_ACPI
    > to invoke disable_acpi(), we could define the inline as empty and you could
    > then scratch the #ifdef too.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7cda93e008e1a477970adbf82dba81a5d4f0ae40
Author: Len Brown <len.brown@intel.com>
Date:   Mon Feb 12 23:50:02 2007 -0500

    ACPI: delete extra #defines in /drivers/acpi/ drivers
    
    Cosmetic only.
    
    Except in a single case, #define ACPI_*_DRIVER_NAME
    were invoked 0 or 1 times.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c2b6705b75d9c7aff98a4602a32230639e10891c
Author: Len Brown <len.brown@intel.com>
Date:   Mon Feb 12 23:33:40 2007 -0500

    ACPI: fix acpi_driver.name usage
    
    It was erroneously used as a description rather than a name.
    
    ie. turn this:
    
    lenb@se7525gp2:/sys> ls bus/acpi/drivers
    ACPI AC Adapter Driver  ACPI Embedded Controller Driver  ACPI Power Resource Driver
    ACPI Battery Driver     ACPI Fan Driver                  ACPI Processor Driver
    ACPI Button Driver      ACPI PCI Interrupt Link Driver   ACPI Thermal Zone Driver
    ACPI container driver   ACPI PCI Root Bridge Driver      hpet
    
    into this:
    
    lenb@se7525gp2:~> ls /sys/bus/acpi/drivers
    ac  battery  button  container  ec  fan  hpet  pci_link  pci_root  power  processor  thermal
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f52fd66d2ea794010c2d7536cf8e6abed0ac4947
Author: Len Brown <len.brown@intel.com>
Date:   Mon Feb 12 22:42:12 2007 -0500

    ACPI: clean up ACPI_MODULE_NAME() use
    
    cosmetic only
    
    Make "module name" actually match the file name.
    Invoke with ';' as leaving it off confuses Lindent and gcc doesn't care.
    Fix indentation where Lindent did get confused.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 615d5f235b6c402ca01098a828c3d67e79e57cb6
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Mon Feb 12 10:51:23 2007 -0500

    ACPI: IA64: fix calculation of apic_id
    
    fix regression from recent table re-write
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 359acec8cd78d35e64147565e28b516599066e08
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 10 01:59:24 2007 -0500

    ACPI: add video driver MAINTAINER
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e6d0f5622d30a3b98fb0ba6264d5006a18270890
Author: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Date:   Sat Feb 10 01:51:13 2007 -0500

    ACPI: sbs: fix present rate
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7897
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4bd35cdb1e2d1a1bbbe4b75132718e79b80519ab
Author: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Date:   Sat Feb 10 01:43:48 2007 -0500

    ACPI: battery: check for battery present on /proc/battery access
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7200
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aafbcd165a2a02e6dff173f66772b3148229ace8
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Sat Feb 10 01:32:16 2007 -0500

    ACPI: invoke acpi_sleep_init() earlier
    
    late_initcall() is too late for acpi_sleep_init().
    Call it directly from acpi_init code.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7887
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ed41dab90eb40ac4911e60406bc653661f0e4ce1
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Sat Feb 10 01:30:35 2007 -0500

    ACPI: Disable GPEs in preparation for sleep.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7887
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d78112e1f1da2a8be1ac0d7b583dcc25aa4f079c
Author: Michael Hanselmann <linux-kernel@hansmi.ch>
Date:   Sat Feb 10 00:47:44 2007 -0500

    ACPI: video: Fix null pointer in appledisplay driver
    
    commit "ACPI: video: Add dev argument for backlight_device_register"
    519ab5f2be65b72cf12ae99c89752bbe79b44df6
    broke the apple display driver.
    
    Signed-off-by: Michael Hanselmann <linux-kernel@hansmi.ch>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3945ac36af3da6014cde9836c5acc5b3adaaa379
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Feb 6 19:13:44 2007 -0200

    ACPI: ibm-acpi: cleanup init and exit paths
    
    Fix a small memory leak on module removal, and other
    assorted minor cleanups on the module init codepath.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a3c94e5c5921b0fd75b33042ca598aee52f1f7b9
Author: Al Viro <viro@ftp.linux.org.uk>
Date:   Fri Feb 9 16:05:07 2007 +0000

    ACPI: bay: fix wrong order of kzalloc arguments
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b2b7910d5d3cb6e53b40a435bbc3f1de60f4464a
Author: Ahmed S. Darwish <darwish.07@gmail.com>
Date:   Tue Feb 6 16:14:43 2007 -0800

    ACPI: toshiba_acpi: Use ARRAY_SIZE macro when appropriate
    
    Use ARRAY_SIZE macro already defined in kernel.h
    
    Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d94d3dff0d5da3bdfcbb424ba5c08534521fd690
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Wed Feb 7 16:51:46 2007 -0800

    ACPI: bay: fix build warning
    
    drivers/acpi/bay.c: In function 'bay_add':
    drivers/acpi/bay.c:310: warning: statement with no effect
    
    Fix it by rewriting those macros in C.  Much nicer.
    
    Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a74388e21ef2adbba4450f7b3f05ffe88df630d5
Author: David Brownell <david-b@pacbell.net>
Date:   Mon Feb 5 16:09:11 2007 -0800

    ACPI: updates rtc-cmos device platform_data
    
    Update ACPI to export its RTC extension information through platform_data
    to the PNPACPI or platform bus device node used on the system being set up.
    
    This will need to be updated later to provide a firmware hook to handle
    system suspend with an alarm pending.
    
    Len notes that "Eventually we may bundle ACPI/PNP/PNPACPI..." but if/when
    that happens, ACPI can simplify this without my help.
    
    And until it does, the separate patch creating a platform_device (on all
    X86_PC systems, even without ACPI) will be needed.
    
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1c0f0575fd02a3996f09cac2ef29c4cc5c2d279d
Author: Matthew C Campbell <calvinmc@gmail.com>
Date:   Mon Feb 5 16:09:09 2007 -0800

    ACPI: asus_acpi: Add support for Asus Z81SP
    
    Adds support in asus_acpi for the Asus Z81SP laptop.  This preserves all
    old functionality when improperly detected as well as enabling Bluetooth
    support.
    
    Signed-off-by: Matthew C Campbell <calvinmc@gmail.com>
    Acked-by: Corentin Chary <corentincj@iksaif.net>
    Cc: Karol Kozimor <sziwan@users.sourceforge.net>
    Cc: <acpi4asus-user@lists.sourceforge.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c41458aca0defd5b16239ffd65630d1b87672ee5
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Mon Feb 5 16:09:07 2007 -0800

    ACPI: bay: remove ACPI driver struct
    
    The bay driver is a platform driver, and doesn't need to also be an acpi
    driver.  Remove the acpi driver related structures and callbacks, they didn't
    do anything anyway.  Switch to uevent for user space event notification.
    
    Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>
