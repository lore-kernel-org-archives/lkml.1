Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbXJJHMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbXJJHMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 03:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXJJHME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 03:12:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:43564 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbXJJHMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 03:12:01 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PATCH] ACPI paches for 2.6.24-rc0
Date: Tue, 9 Oct 2007 23:10:47 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710092310.48143.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Multiple random branches which have been queued for a while...
A new platform specific driver for Fujitsu laptops.

cpuidle is new, and is not perfect, but it seems time for it to get it upstream
where it will get some wider exposure now that people are doing things
like running powertop to tune tickless kernels...
The old ACPI idle code runs when CONFIG_CPU_IDLE=n.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.23/acpi-release-20070126-2.6.23.diff.gz

 Documentation/thinkpad-acpi.txt    |   25 
 arch/i386/Kconfig                  |    2 
 arch/x86_64/Kconfig                |    2 
 drivers/Makefile                   |    1 
 drivers/acpi/Kconfig               |   14 
 drivers/acpi/Makefile              |    1 
 drivers/acpi/ac.c                  |   33 
 drivers/acpi/battery.c             | 1038 +++++--------
 drivers/acpi/bus.c                 |   23 
 drivers/acpi/ec.c                  |   93 -
 drivers/acpi/events/evevent.c      |    6 
 drivers/acpi/hardware/hwregs.c     |   89 -
 drivers/acpi/hardware/hwsleep.c    |   40 
 drivers/acpi/osl.c                 |    8 
 drivers/acpi/processor_core.c      |   22 
 drivers/acpi/processor_idle.c      |  488 ++++++
 drivers/acpi/sbs.c                 | 1869 +++++++------------------
 drivers/acpi/sbshc.c               |  309 ++++
 drivers/acpi/sbshc.h               |   27 
 drivers/acpi/sleep/main.c          |    6 
 drivers/acpi/sleep/sleep.h         |    1 
 drivers/acpi/sleep/wakeup.c        |  117 -
 drivers/acpi/tables/tbutils.c      |    2 
 drivers/acpi/thermal.c             |   28 
 drivers/acpi/video.c               |   30 
 drivers/cpuidle/Kconfig            |   20 
 drivers/cpuidle/Makefile           |    5 
 drivers/cpuidle/cpuidle.c          |  295 +++
 drivers/cpuidle/cpuidle.h          |   33 
 drivers/cpuidle/driver.c           |   56 
 drivers/cpuidle/governor.c         |  141 +
 drivers/cpuidle/governors/Makefile |    6 
 drivers/cpuidle/governors/ladder.c |  166 ++
 drivers/cpuidle/governors/menu.c   |  137 +
 drivers/cpuidle/sysfs.c            |  361 ++++
 drivers/misc/Kconfig               |   17 
 drivers/misc/Makefile              |    1 
 drivers/misc/fujitsu-laptop.c      |  358 ++++
 drivers/misc/sony-laptop.c         |  204 +-
 drivers/misc/thinkpad_acpi.c       |  207 ++
 drivers/misc/thinkpad_acpi.h       |   37 
 drivers/net/wireless/ipw2100.c     |   29 
 drivers/net/wireless/ipw2100.h     |    2 
 include/acpi/achware.h             |    4 
 include/acpi/acpi_bus.h            |    2 
 include/acpi/acpixf.h              |    2 
 include/acpi/processor.h           |    5 
 include/linux/acpi.h               |   26 
 include/linux/cpuidle.h            |  180 ++
 include/linux/tick.h               |    9 
 kernel/time/tick-sched.c           |   16 
 51 files changed, 4182 insertions(+), 2411 deletions(-)

through these commits:

Alexey Starikovskiy (21):
      ACPI: Thermal: Drop concurrent thermal checks
      ACPI: video: Don't call absent methods
      ACPI: VIDEO: Adjust current level to closest available one.
      ACPI: EC: Drop ECDT-based boot_ec as soon as we find DSDT-based one.
      ACPI: Hibernate erroneously disabled Suspend wakeup devices
      ACPI: Battery: don't use acpi_extract_package()
      ACPI: Battery: simplify update scheme
      ACPI: Battery: Misc clean-ups, no functional changes
      ACPI: Battery: Add sysfs support
      ACPI: Battery: add sysfs alarm
      ACPI: Add acpi_bus_generate_event4() function
      ACPI: EC: Add new query handler to list head.
      ACPI: SBS: Split host controller (ACPI0001) from SBS driver (ACPI0002)
      ACPI: SBS: Simplify data structures in SBS
      ACPI: SBS: Make SBS reads table-driven.
      ACPI: SBS: Add support for power_supply class (and sysfs)
      ACPI: SBS: Add ACPI_PROCFS around procfs handling code.
      ACPI: SBS: Add sysfs alarm
      ACPI: AC: Add sysfs interface
      ACPICA: hw: remove use_lock flag from acpi_hw_register_{read, write}
      ACPICA: hw: Don't carry spinlock over suspend

Andreas Herrmann (2):
      sony-laptop/thinkpad-acpi: fix INPUT=n build
      acpi_video: kernel build error if !INPUT

Andrew Morton (1):
      ACPI: suppress uninitialized var warning

Henrique de Moraes Holschuh (10):
      ACPI: thinkpad-acpi: make room for more features in tp_features bitfield
      ACPI: thinkpad-acpi: issue EV_SYNC after EV_SWITCH
      ACPI: thinkpad-acpi: add mutex-based locking to input device event send path
      ACPI: thinkpad-acpi: keep track of module state
      ACPI: thinkpad-acpi: check version of hot key firmware
      ACPI: thinkpad-acpi: dequeue all pending hot key events at once (v2.2)
      ACPI: thinkpad-acpi: fix regression on HKEY LID event handling
      ACPI: thinkpad-acpi: use a separate platform device for hwmon and name it (v2)
      ACPI: thinkpad-acpi: duplicate driver attributes to new hwmon pdrv
      ACPI: thinkpad-acpi: skip blanks before the data when parsing sysfs

Jonathan Woithe (1):
      fujitsu-laptop: create Fujitsu laptop platform specific driver

Len Brown (3):
      ACPI: thermal: use round_jiffies when thermal zone polling is enabled
      cpuidle: consolidate 2.6.22 cpuidle branch into one patch
      ACPI: cpuidle: port idle timer suspend/resume workaround to cpuidle

Mattia Dongili (1):
      sony-laptop: old Vaio models contain 2 IO port entries

Rafael J. Wysocki (2):
      Hibernation: Make sure that ACPI is enabled in acpi_hibernation_finish
      ACPI: clean up acpi_enter_sleep_state_prep

with this log:

commit 00a2b433557f10736e8a02de619b3e9052556c12
Merge: de85871... 2d571b3...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 10 01:00:45 2007 -0400

    Pull acpica into test branch

commit 2d571b33cf7efd6a894e765e3cb45587ec5b834a
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sun Sep 30 22:39:42 2007 +0400

    ACPICA: hw: Don't carry spinlock over suspend
    
    ACPI uses acpi_get_register() in order to get into suspend.
    This function is guarded by acpi_gbl_hardware_lock, which will be carried
    into resume phase.
    At resume interrupts are enabled and first ACPI interrupt deadlocks on this
    lock.
    Solution seems to be to not lock register read, as there are no concurrent
    activity at this point.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=7499
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d30dc9abb4aacfd4df3f486f22bcbc0531b73283
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sun Sep 30 22:39:36 2007 +0400

    ACPICA: hw: remove use_lock flag from acpi_hw_register_{read, write}
    
    use_lock flag is used once for acpi_hw_register_read, and never for
    acpi_hw_register_write. It will greatly simplify understanding of
    locking if we just drop this use_lock altogether, and wrap the only call
    to ..._read in lock/unlock.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit de85871a9a53c00cae4c3a70849b5eaad0eb38b2
Merge: 731aa5f... e196441...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 10 00:32:13 2007 -0400

    Pull cpuidle into test branch

commit 731aa5fd9971a5163845fbe55de63d686a11da0a
Merge: 27345a5... 4c61106...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 10 00:30:55 2007 -0400

    Pull bugzilla-8709 into release branch

commit 27345a5109f36779187311f77e30bcf596571c29
Merge: e270051... 9b03933...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 10 00:30:40 2007 -0400

    Pull bugzilla-292300 into release branch

commit e270051d9c6e5f0b31668ec1f0d864ab9920ffca
Merge: a2883df... d5b4a3d...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 10 00:30:19 2007 -0400

    Pull battery-sbs-ac into release branch

commit a2883dfa2e4a94b24109b2bfe735561e50cc44b4
Merge: 73a855f... 6e21578...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 10 00:29:40 2007 -0400

    Pull thermal into release branch

commit 73a855f70d9b3571fa878727cbc568d9774c6dce
Merge: 194e3d1... 63f0edf...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 10 00:29:11 2007 -0400

    Pull video into release branch
    
    Conflicts:
    
    	drivers/acpi/video.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 194e3d174043f5ab22649a5cb38a1c05d015750f
Merge: bf0a40b... d048253...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 10 00:28:17 2007 -0400

    Pull fujitsu-v3 into release branch

commit bf0a40b77ab1ce13fb6fa3bf7c8e413bac02873a
Merge: 2cde4af... 32afbf0...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 10 00:28:04 2007 -0400

    Pull thinkpad into release branch

commit 2cde4afacad1d66a129ad8787c01ce122382559a
Merge: e67c5d8... fd1caae...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 10 00:27:58 2007 -0400

    Pull sony-2.6.24 into release branch

commit e67c5d8df119d5e85c0b7525a6c9d356ac6f7989
Merge: 67e74fd... 6cffd46...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 10 00:27:44 2007 -0400

    Pull suspend into release branch

commit 67e74fdd81349a92fcece318a5ee41714273eb01
Merge: bbf25010f... 8ab7367...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 10 00:27:26 2007 -0400

    Pull randconfig into release branch

commit e196441bdf2dbf0526b28a6829c39557c236d611
Author: Len Brown <len.brown@intel.com>
Date:   Thu Oct 4 01:23:47 2007 -0400

    ACPI: cpuidle: port idle timer suspend/resume workaround to cpuidle
    
    Some timers stop during C2 and C3, and so there are various
    generations of timer broadcast workarounds to deal with that.
    But that (already complex) code gets confused during suspend.
    
    As it is unlikely that deep C-states would save much power
    during the actual suspend/resume process anyway, deep C-states
    were disabled via the addition of .suspend/.resume hooks
    in to the ACPI processor driver.
    
    Here that workaround is ported to the cpuidle version of
    the ACPI idle loop.  Technically, ACPI could un-register
    itself from cpuidle on .suspend, but that code path
    is currently quite cumbersome.  So instead,
    we simply invoke C1 from the C2 and C3 handlers
    for the duration of .suspend/.resume.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6cffd46651b881a11791a7ef4d99f2f20853fcd9
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Oct 2 13:24:09 2007 -0700

    ACPI: clean up acpi_enter_sleep_state_prep
    
    Remove some redundant code from acpi_enter_sleep_state_prep() and clean up
    a comment in there.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8a0bb7362587807fec985f72fb0317aa8ed24835
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Oct 2 13:24:08 2007 -0700

    Hibernation: Make sure that ACPI is enabled in acpi_hibernation_finish
    
    If the BIOS does not enable ACPI and the "acpi=off" command line parameter
    is passed to the boot kernel, ACPI may be disabled when the (restored)
    image kernel attempts to execute acpi_hibernation_finish().  To prevent
    this from happening we can call acpi_enable() from
    acpi_hibernation_finish() (if ACPI is already enabled, this will have no
    effect).
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8ab7367f483d1d676d61fca58498a73b194dda82
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Tue Oct 2 13:24:10 2007 -0700

    ACPI: suppress uninitialized var warning
    
    drivers/acpi/tables/tbutils.c: In function `acpi_tb_parse_root_table':
    drivers/acpi/tables/tbutils.c:403: warning: `rsdt_address' may be used uninitialized in this function
    
    Reported-by: Uwe Bugla <uwe.bugla@gmx.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4f86d3a8e297205780cca027e974fd5f81064780
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 3 18:58:00 2007 -0400

    cpuidle: consolidate 2.6.22 cpuidle branch into one patch
    
    commit e5a16b1f9eec0af7cfa0830304b41c1c0833cf9f
    Author: Len Brown <len.brown@intel.com>
    Date:   Tue Oct 2 23:44:44 2007 -0400
    
        cpuidle: shrink diff
    
        processor_idle.c |  440 +++++++++++++++++++++++++++++++++++++++++--
        1 file changed, 429 insertions(+), 11 deletions(-)
    
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit dfbb9d5aedfb18848a3e0d6f6e3e4969febb209c
    Author: Len Brown <len.brown@intel.com>
    Date:   Wed Sep 26 02:17:55 2007 -0400
    
        cpuidle: reduce diff size
    
        Reduces the cpuidle processor_idle.c diff vs 2.6.22 from this
         processor_idle.c | 2006 ++++++++++++++++++++++++++-----------------
         1 file changed, 1219 insertions(+), 787 deletions(-)
    
        to this:
         processor_idle.c |  502 +++++++++++++++++++++++++++++++++++++++----
         1 file changed, 458 insertions(+), 44 deletions(-)
    
        ...for the purpose of making the cpuilde patch less invasive
        and easier to review.
    
        no functional changes.  build tested only.
    
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 889172fc915f5a7fe20f35b133cbd205ce69bf6c
    Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Thu Sep 13 13:40:05 2007 -0700
    
        cpuidle: Retain old ACPI policy for !CONFIG_CPU_IDLE
    
        Retain the old policy in processor_idle, so that when CPU_IDLE is not
        configured, old C-state policy will still be used. This provides a
        clean gradual migration path from old ACPI policy to new cpuidle
        based policy.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 9544a8181edc7ecc33b3bfd69271571f98ed08bc
    Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Thu Sep 13 13:39:17 2007 -0700
    
        cpuidle: Configure governors by default
    
        Quoting Len "Do not give an option to users to shoot themselves in the foot".
    
        Remove the configurability of ladder and menu governors as they are
        needed for default policy of cpuidle. That way users will not be able to
        have cpuidle without any policy loosing all C-state power savings.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 8975059a2c1e56cfe83d1bcf031bcf4cb39be743
    Author: Adam Belay <abelay@novell.com>
    Date:   Tue Aug 21 18:27:07 2007 -0400
    
        CPUIDLE: load ACPI properly when CPUIDLE is disabled
    
        Change the registration return codes for when CPUIDLE
        support is not compiled into the kernel.  As a result, the ACPI
        processor driver will load properly even if CPUIDLE is unavailable.
        However, it may be possible to cleanup the ACPI processor driver further
        and eliminate some dead code paths.
    
        Signed-off-by: Adam Belay <abelay@novell.com>
        Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit e0322e2b58dd1b12ec669bf84693efe0dc2414a8
    Author: Adam Belay <abelay@novell.com>
    Date:   Tue Aug 21 18:26:06 2007 -0400
    
        CPUIDLE: remove cpuidle_get_bm_activity()
    
        Remove cpuidle_get_bm_activity() and updates governors
        accordingly.
    
        Signed-off-by: Adam Belay <abelay@novell.com>
        Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 18a6e770d5c82ba26653e53d240caa617e09e9ab
    Author: Adam Belay <abelay@novell.com>
    Date:   Tue Aug 21 18:25:58 2007 -0400
    
        CPUIDLE: max_cstate fix
    
        Currently max_cstate is limited to 0, resulting in no idle processor
        power management on ACPI platforms.  This patch restores the value to
        the array size.
    
        Signed-off-by: Adam Belay <abelay@novell.com>
        Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 1fdc0887286179b40ce24bcdbde663172e205ef0
    Author: Adam Belay <abelay@novell.com>
    Date:   Tue Aug 21 18:25:40 2007 -0400
    
        CPUIDLE: handle BM detection inside the ACPI Processor driver
    
        Update the ACPI processor driver to detect BM activity and
        limit state entry depth internally, rather than exposing such
        requirements to CPUIDLE.  As a result, CPUIDLE can drop this
        ACPI-specific interface and become more platform independent.  BM
        activity is now handled much more aggressively than it was in the
        original implementation, so some testing coverage may be needed to
        verify that this doesn't introduce any DMA buffer under-run issues.
    
        Signed-off-by: Adam Belay <abelay@novell.com>
        Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 0ef38840db666f48e3cdd2b769da676c57228dd9
    Author: Adam Belay <abelay@novell.com>
    Date:   Tue Aug 21 18:25:14 2007 -0400
    
        CPUIDLE: menu governor updates
    
        Tweak the menu governor to more effectively handle non-timer
        break events.  Non-timer break events are detected by comparing the
        actual sleep time to the expected sleep time.  In future revisions, it
        may be more reliable to use the timer data structures directly.
    
        Signed-off-by: Adam Belay <abelay@novell.com>
        Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit bb4d74fca63fa96cf3ace644b15ae0f12b7df5a1
    Author: Adam Belay <abelay@novell.com>
    Date:   Tue Aug 21 18:24:40 2007 -0400
    
        CPUIDLE: fix 'current_governor' sysfs entry
    
        Allow the "current_governor" sysfs entry to properly handle
        input terminated with '\n'.
    
        Signed-off-by: Adam Belay <abelay@novell.com>
        Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit df3c71559bb69b125f1a48971bf0d17f78bbdf47
    Author: Len Brown <len.brown@intel.com>
    Date:   Sun Aug 12 02:00:45 2007 -0400
    
        cpuidle: fix IA64 build (again)
    
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit a02064579e3f9530fd31baae16b1fc46b5a7bca8
    Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Sun Aug 12 01:39:27 2007 -0400
    
        cpuidle: Remove support for runtime changing of max_cstate
    
        Remove support for runtime changeability of max_cstate. Drivers can use
        use latency APIs.
    
        max_cstate can still be used as a boot time option and dmi override.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 0912a44b13adf22f5e3f607d263aed23b4910d7e
    Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Sun Aug 12 01:39:16 2007 -0400
    
        cpuidle: Remove ACPI cstate_limit calls from ipw2100
    
        ipw2100 already has code to use accetable_latency interfaces to limit the
        C-state. Remove the calls to acpi_set_cstate_limit and acpi_get_cstate_limit
        as they are redundant.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit c649a76e76be6bff1fd770d0a775798813a3f6e0
    Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Sun Aug 12 01:35:39 2007 -0400
    
        cpuidle: compile fix for pause and resume functions
    
        Fix the compilation failure when cpuidle is not compiled in.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Acked-by: Adam Belay <adam.belay@novell.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 2305a5920fb8ee6ccec1c62ade05aa8351091d71
    Author: Adam Belay <abelay@novell.com>
    Date:   Thu Jul 19 00:49:00 2007 -0400
    
        cpuidle: re-write
    
        Some portions have been rewritten to make the code cleaner and lighter
        weight.  The following is a list of changes:
    
        1.) the state name is now included in the sysfs interface
        2.) detection, hotplug, and available state modifications are handled by
        CPUIDLE drivers directly
        3.) the CPUIDLE idle handler is only ever installed when at least one
        cpuidle_device is enabled and ready
        4.) the menu governor BM code no longer overflows
        5.) the sysfs attributes are now printed as unsigned integers, avoiding
        negative values
        6.) a variety of other small cleanups
    
        Also, Idle drivers are no longer swappable during runtime through the
        CPUIDLE sysfs inteface.  On i386 and x86_64 most idle handlers (e.g.
        poll, mwait, halt, etc.) don't benefit from an infrastructure that
        supports multiple states, so I think using a more general case idle
        handler selection mechanism would be cleaner.
    
        Signed-off-by: Adam Belay <abelay@novell.com>
        Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Acked-by: Shaohua Li <shaohua.li@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit df25b6b56955714e6e24b574d88d1fd11f0c3ee5
    Author: Len Brown <len.brown@intel.com>
    Date:   Tue Jul 24 17:08:21 2007 -0400
    
        cpuidle: fix IA64 buid
    
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit fd6ada4c14488755ff7068860078c437431fbccd
    Author: Adrian Bunk <bunk@stusta.de>
    Date:   Mon Jul 9 11:33:13 2007 -0700
    
        cpuidle: static
    
        make cpuidle_replace_governor() static
    
        Signed-off-by: Adrian Bunk <bunk@stusta.de>
        Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit c1d4a2cebcadf2429c0c72e1d29aa2a9684c32e0
    Author: Adrian Bunk <bunk@stusta.de>
    Date:   Tue Jul 3 00:54:40 2007 -0400
    
        cpuidle: static
    
        This patch makes the needlessly global struct menu_governor static.
    
        Signed-off-by: Adrian Bunk <bunk@stusta.de>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit dbf8780c6e8d572c2c273da97ed1cca7608fd999
    Author: Andrew Morton <akpm@linux-foundation.org>
    Date:   Tue Jul 3 00:49:14 2007 -0400
    
        export symbol tick_nohz_get_sleep_length
    
        ERROR: "tick_nohz_get_sleep_length" [drivers/cpuidle/governors/menu.ko] undefined!
        ERROR: "tick_nohz_get_idle_jiffies" [drivers/cpuidle/governors/menu.ko] undefined!
    
        And please be sure to get your changes to core kernel suitably reviewed.
    
        Cc: Adam Belay <abelay@novell.com>
        Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
        Cc: Ingo Molnar <mingo@elte.hu>
        Cc: Thomas Gleixner <tglx@linutronix.de>
        Cc: john stultz <johnstul@us.ibm.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 29f0e248e7017be15f99febf9143a2cef00b2961
    Author: Andrew Morton <akpm@linux-foundation.org>
    Date:   Tue Jul 3 00:43:04 2007 -0400
    
        tick.h needs hrtimer.h
    
        It uses hrtimers.
    
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit e40cede7d63a029e92712a3fe02faee60cc38fb4
    Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Tue Jul 3 00:40:34 2007 -0400
    
        cpuidle: first round of documentation updates
    
        Documentation changes based on Pavel's feedback.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 83b42be2efece386976507555c29e7773a0dfcd1
    Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Tue Jul 3 00:39:25 2007 -0400
    
        cpuidle: add rating to the governors and pick the one with highest rating by default
    
        Introduce a governor rating scheme to pick the right governor by default.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit d2a74b8c5e8f22def4709330d4bfc4a29209b71c
    Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Tue Jul 3 00:38:08 2007 -0400
    
        cpuidle: make cpuidle sysfs driver governor switch off by default
    
        Make default cpuidle sysfs to show current_governor and current_driver in
        read-only mode.  More elaborate available_governors and available_drivers with
        writeable current_governor and current_driver interface only appear with
        "cpuidle_sysfs_switch" boot parameter.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 1f60a0e80bf83cf6b55c8845bbe5596ed8f6307b
    Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Tue Jul 3 00:37:00 2007 -0400
    
        cpuidle: menu governor: change the early break condition
    
        Change the C-state early break out algorithm in menu governor.
    
        We only look at early breakouts that result in wakeups shorter than idle
        state's target_residency.  If such a breakout is frequent enough, eliminate
        the particular idle state upto a timeout period.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 45a42095cf64b003b4a69be3ce7f434f97d7af51
    Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Tue Jul 3 00:35:38 2007 -0400
    
        cpuidle: fix uninitialized variable in sysfs routine
    
        Fix the uninitialized usage of ret.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 80dca7cdba3e6ee13eae277660873ab9584eb3be
    Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Tue Jul 3 00:34:16 2007 -0400
    
        cpuidle: reenable /proc/acpi//power interface for the time being
    
        Keep /proc/acpi/processor/CPU*/power around for a while as powertop depends
        on it. It will be marked deprecated and removed in future. powertop can use
        cpuidle interfaces instead.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 589c37c2646c5e3813a51255a5ee1159cb4c33fc
    Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Tue Jul 3 00:32:37 2007 -0400
    
        cpuidle: menu governor and hrtimer compile fix
    
        Compile fix for menu governor.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 0ba80bd9ab3ed304cb4f19b722e4cc6740588b5e
    Author: Len Brown <len.brown@intel.com>
    Date:   Thu May 31 22:51:43 2007 -0400
    
        cpuidle: build fix - cpuidle vs ipw2100 module
    
        ERROR: "acpi_set_cstate_limit" [drivers/net/wireless/ipw2100.ko] undefined!
    
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit d7d8fa7f96a7f7682be7c6cc0cc53fa7a18c3b58
    Author: Adam Belay <abelay@novell.com>
    Date:   Sat Mar 24 03:47:07 2007 -0400
    
        cpuidle: add the 'menu' governor
    
        Here is my first take at implementing an idle PM governor that takes
        full advantage of NO_HZ.  I call it the 'menu' governor because it
        considers the full list of idle states before each entry.
    
        I've kept the implementation fairly simple.  It attempts to guess the
        next residency time and then chooses a state that would meet at least
        the break-even point between power savings and entry cost.  To this end,
        it selects the deepest idle state that satisfies the following
        constraints:
             1. If the idle time elapsed since bus master activity was detected
                is below a threshold (currently 20 ms), then limit the selection
                to C2-type or above.
             2. Do not choose a state with a break-even residency that exceeds
                the expected time remaining until the next timer interrupt.
             3. Do not choose a state with a break-even residency that exceeds
                the elapsed time between the last pair of break events,
                excluding timer interrupts.
    
        This governor has an advantage over "ladder" governor because it
        proactively checks how much time remains until the next timer interrupt
        using the tick infrastructure.  Also, it handles device interrupt
        activity more intelligently by not including timer interrupts in break
        event calculations.  Finally, it doesn't make policy decisions using the
        number of state entries, which can have variable residency times (NO_HZ
        makes these potentially very large), and instead only considers sleep
        time deltas.
    
        The menu governor can be selected during runtime using the cpuidle sysfs
        interface like so:
        "echo "menu" > /sys/devices/system/cpu/cpuidle/current_governor"
    
        Signed-off-by: Adam Belay <abelay@novell.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit a4bec7e65aa3b7488b879d971651cc99a6c410fe
    Author: Adam Belay <abelay@novell.com>
    Date:   Sat Mar 24 03:47:03 2007 -0400
    
        cpuidle: export time until next timer interrupt using NO_HZ
    
        Expose information about the time remaining until the next
        timer interrupt expires by utilizing the dynticks infrastructure.
        Also modify the main idle loop to allow dynticks to handle
        non-interrupt break events (e.g. DMA).  Finally, expose sleep ticks
        information to external code.  Thomas Gleixner is responsible for much
        of the code in this patch.  However, I've made some additional changes,
        so I'm probably responsible if there are any bugs or oversights :)
    
        Signed-off-by: Adam Belay <abelay@novell.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 2929d8996fbc77f41a5ff86bb67cdde3ca7d2d72
    Author: Adam Belay <abelay@novell.com>
    Date:   Sat Mar 24 03:46:58 2007 -0400
    
        cpuidle: governor API changes
    
        This patch prepares cpuidle for the menu governor.  It adds an optional
        stage after idle state entry to give the governor an opportunity to
        check why the state was exited.  Also it makes sure the idle loop
        returns after each state entry, allowing the appropriate dynticks code
        to run.
    
        Signed-off-by: Adam Belay <abelay@novell.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 3a7fd42f9825c3b03e364ca59baa751bb350775f
    Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Thu Apr 26 00:03:59 2007 -0700
    
        cpuidle: hang fix
    
        Prevent hang on x86-64, when ACPI processor driver is added as a module on
        a system that does not support C-states.
    
        x86-64 expects all idle handlers to enable interrupts before returning from
        idle handler.  This is due to enter_idle(), exit_idle() races.  Make
        cpuidle_idle_call() confirm to this when there is no pm_idle_old.
    
        Also, cpuidle look at the return values of attch_driver() and set
        current_driver to NULL if attach fails on all CPUs.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 4893339a142afbd5b7c01ffadfd53d14746e858e
    Author: Shaohua Li <shaohua.li@intel.com>
    Date:   Thu Apr 26 10:40:09 2007 +0800
    
        cpuidle: add support for max_cstate limit
    
        With CPUIDLE framework, the max_cstate (to limit max cpu c-state)
        parameter is ingored. Some systems require it to ignore C2/C3
        and some drivers like ipw require it too.
    
        Signed-off-by: Shaohua Li <shaohua.li@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 43bbbbe1cb998cbd2df656f55bb3bfe30f30e7d1
    Author: Shaohua Li <shaohua.li@intel.com>
    Date:   Thu Apr 26 10:40:13 2007 +0800
    
        cpuidle: add cpuidle_fore_redetect_devices API
    
        add cpuidle_force_redetect_devices API,
        which forces all CPU redetect idle states.
        Next patch will use it.
    
        Signed-off-by: Shaohua Li <shaohua.li@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit d1edadd608f24836def5ec483d2edccfb37b1d19
    Author: Shaohua Li <shaohua.li@intel.com>
    Date:   Thu Apr 26 10:40:01 2007 +0800
    
        cpuidle: fix sysfs related issue
    
        Fix the cpuidle sysfs issue.
        a. make kobject dynamicaly allocated
        b. fixed sysfs init issue to avoid suspend/resume issue
    
        Signed-off-by: Shaohua Li <shaohua.li@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 7169a5cc0d67b263978859672e86c13c23a5570d
    Author: Randy Dunlap <randy.dunlap@oracle.com>
    Date:   Wed Mar 28 22:52:53 2007 -0400
    
        cpuidle: 1-bit field must be unsigned
    
        A 1-bit bitfield has no room for a sign bit.
        drivers/cpuidle/governors/ladder.c:54:16: error: dubious bitfield without explicit `signed' or `unsigned'
    
        Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
        Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 4658620158dc2fbd9e4bcb213c5b6fb5d05ba7d4
    Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Wed Mar 28 22:52:41 2007 -0400
    
        cpuidle: fix boot hang
    
        Patch for cpuidle boot hang reported by Larry Finger here.
        http://www.ussg.iu.edu/hypermail/linux/kernel/0703.2/2025.html
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Cc: Larry Finger <larry.finger@lwfinger.net>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit c17e168aa6e5fe3851baaae8df2fbc1cf11443a9
    Author: Len Brown <len.brown@intel.com>
    Date:   Wed Mar 7 04:37:53 2007 -0500
    
        cpuidle: ladder does not depend on ACPI
    
        build fix for CONFIG_ACPI=n
    
        In file included from drivers/cpuidle/governors/ladder.c:21:
        include/acpi/processor.h:88: error: expected specifier-qualifier-list before ‘acpi_integer’
        include/acpi/processor.h:106: error: expected specifier-qualifier-list before ‘acpi_integer’
        include/acpi/processor.h:168: error: expected specifier-qualifier-list before ‘acpi_handle’
    
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 8c91d958246bde68db0c3f0c57b535962ce861cb
    Author: Adrian Bunk <bunk@stusta.de>
    Date:   Tue Mar 6 02:29:40 2007 -0800
    
        cpuidle: make code static
    
        This patch makes the following needlessly global code static:
        - driver.c: __cpuidle_find_driver()
        - governor.c: __cpuidle_find_governor()
        - ladder.c: struct ladder_governor
    
        Signed-off-by: Adrian Bunk <bunk@stusta.de>
        Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Cc: Adam Belay <abelay@novell.com>
        Cc: Shaohua Li <shaohua.li@intel.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 0c39dc3187094c72c33ab65a64d2017b21f372d2
    Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Wed Mar 7 02:38:22 2007 -0500
    
        cpu_idle: fix build break
    
        This patch fixes a build breakage with !CONFIG_HOTPLUG_CPU and
        CONFIG_CPU_IDLE.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Adrian Bunk <bunk@stusta.de>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 8112e3b115659b07df340ef170515799c0105f82
    Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Tue Mar 6 02:29:39 2007 -0800
    
        cpuidle: build fix for !CPU_IDLE
    
        Fix the compile issues when CPU_IDLE is not configured.
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Cc: Adam Belay <abelay@novell.com>
        Cc: Shaohua Li <shaohua.li@intel.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 1eb4431e9599cd25e0d9872f3c2c8986821839dd
    Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Thu Feb 22 13:54:57 2007 -0800
    
        cpuidle take2: Basic documentation for cpuidle
    
        Documentation for cpuidle infrastructure
    
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Adam Belay <abelay@novell.com>
        Signed-off-by: Shaohua Li <shaohua.li@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit ef5f15a8b79123a047285ec2e3899108661df779
    Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Thu Feb 22 13:54:03 2007 -0800
    
        cpuidle take2: Hookup ACPI C-states driver with cpuidle
    
        Hookup ACPI C-states onto generic cpuidle infrastructure.
    
        drivers/acpi/procesor_idle.c is now a ACPI C-states driver that registers as
        a driver in cpuidle infrastructure and the policy part is removed from
        drivers/acpi/processor_idle.c. We use governor in cpuidle instead.
    
        Signed-off-by: Shaohua Li <shaohua.li@intel.com>
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Adam Belay <abelay@novell.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    commit 987196fa82d4db52c407e8c9d5dec884ba602183
    Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Thu Feb 22 13:52:57 2007 -0800
    
        cpuidle take2: Core cpuidle infrastructure
    
        Announcing 'cpuidle', a new CPU power management infrastructure to manage
        idle CPUs in a clean and efficient manner.
        cpuidle separates out the drivers that can provide support for multiple types
        of idle states and policy governors that decide on what idle state to use
        at run time.
        A cpuidle driver can support multiple idle states based on parameters like
        varying power consumption, wakeup latency, etc (ACPI C-states for example).
        A cpuidle governor can be usage model specific (laptop, server,
        laptop on battery etc).
        Main advantage of the infrastructure being, it allows independent development
        of drivers and governors and allows for better CPU power management.
    
        A huge thanks to Adam Belay and Shaohua Li who were part of this mini-project
        since its beginning and are greatly responsible for this patchset.
    
        This patch:
    
        Core cpuidle infrastructure.
        Introduces a new abstraction layer for cpuidle:
        * which manages drivers that can support multiple idles states. Drivers
          can be generic or particular to specific hardware/platform
        * allows pluging in multiple policy governors that can take idle state policy
          decision
        * The core also has a set of sysfs interfaces with which administrato can know
          about supported drivers and governors and switch them at run time.
    
        Signed-off-by: Adam Belay <abelay@novell.com>
        Signed-off-by: Shaohua Li <shaohua.li@intel.com>
        Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
        Signed-off-by: Len Brown <len.brown@intel.com>
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 32afbf07aa53120c0e3fe1881b948ded99f4fc35
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Mon Oct 8 10:12:56 2007 -0300

    ACPI: thinkpad-acpi: skip blanks before the data when parsing sysfs
    
    Skip blanks not just at the tail of sysfs writes, but also at the head.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d5b4a3d0efa36de31b86d5677dad6c36cb8735d7
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:44:06 2007 +0400

    ACPI: AC: Add sysfs interface
    
    Refer to Documentation/power_supply_class.txt for interface description.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8bd955320661cfd03ab8d5574d96aa684acd38f6
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:44:00 2007 +0400

    ACPI: SBS: Add sysfs alarm
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 66e4b72bfa7347fd1017b9b82dce77a410f2e4a1
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:43:54 2007 +0400

    ACPI: SBS: Add ACPI_PROCFS around procfs handling code.
    
    Make procfs support optional under ACPI_PROCFS
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 94f6c0860139da9219255b8ff45ad42117dda859
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:43:48 2007 +0400

    ACPI: SBS: Add support for power_supply class (and sysfs)
    
    Add support for power_supply class and sysfs interface of it.
    Refer to Documentation/power_supply_class.txt for interface description.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit db1c291af7ad748777371f25b9ff92e3e5aba38e
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:43:41 2007 +0400

    ACPI: SBS: Make SBS reads table-driven.
    
    Re-factor SBS functions to use tables and cycles for repeated operations.
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 89862e3be1ba387c738fc2c3a5875cfd7e51c5a8
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:43:35 2007 +0400

    ACPI: SBS: Simplify data structures in SBS
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 91087dfa51a29b3c190e99339c4c32eb13646c51
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:43:28 2007 +0400

    ACPI: SBS: Split host controller (ACPI0001) from SBS driver (ACPI0002)
    
    Replace poll-based host controller driver with the notify-based one.
    Split it out of sbs.c.
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 30c08574da0ead1a47797ce028218ce5b2de61c7
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:43:22 2007 +0400

    ACPI: EC: Add new query handler to list head.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8db85d4c9a0cc131242c80ef8456362d66561dc2
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:43:16 2007 +0400

    ACPI: Add acpi_bus_generate_event4() function
    
    acpi_bus_generate_event() takes two strings out of passed device object.
    SBS needs to supply these strings directly.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3e58ea0d31659b22ba5753f7abf3d7db346eab81
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:43:11 2007 +0400

    ACPI: Battery: add sysfs alarm
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d7380965752505951668e85de59c128d1d6fd21f
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:43:04 2007 +0400

    ACPI: Battery: Add sysfs support
    
    Refer to Documentation/power_supply_class.txt for interface description.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aa650bbdcb94bde4292eabc44490970825c98669
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:42:58 2007 +0400

    ACPI: Battery: Misc clean-ups, no functional changes
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f1d4661abe05d0a2c014166042d15ed8b69ae8f2
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:42:52 2007 +0400

    ACPI: Battery: simplify update scheme
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 038fdea2960be53f82353fd409526fb77a558c52
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:42:46 2007 +0400

    ACPI: Battery: don't use acpi_extract_package()
    
    acpi_extract_package() creates more problems with memory management than
    it solves as helper for package handling.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9b039330808b83acac3597535da26f47ad1862ce
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 26 19:47:30 2007 +0400

    ACPI: Hibernate erroneously disabled Suspend wakeup devices
    
    S4 suspend to disk will disable GPE's permanently
    because acpi_gpe_sleep_prepare() does not have
    a counterpart at resume time.  Thus, those devices
    became unavailable for wakeup from subsequent
    S3 suspend-to-ram.
    
    Here acpi_gpe_sleep_prepare() is removed, and upon suspend
    acpi_enable_wakeup_device() gets its functionality.
    Upon resume, acpi_disable_wakeup_device() restores the state.
    
    https://bugzilla.novell.com/show_bug.cgi?id=292300
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2369cc9492a462285f9eec9d2bbfa730cc2ab5ac
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 23 11:39:07 2007 -0300

    ACPI: thinkpad-acpi: duplicate driver attributes to new hwmon pdrv
    
    Thinkpad-acpi has some driver attributes (debug level, sysfs interface
    version, etc) that also belong to the new hwmon driver.  Duplicate them
    there.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7fd400297978a2cf7a74344fb22020e9479b4f69
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Sep 25 06:38:03 2007 -0300

    ACPI: thinkpad-acpi: use a separate platform device for hwmon and name it (v2)
    
    Use a separate platform device and driver ("thinkpad_hwmon") to attach
    hwmon attributes and class, and add a name attribute of "thinkpad" to
    it, which defines the hwmon device name for libsensors4.
    
    This makes thinkpad-acpi compatible with libsensors4 from lm-sensors, and
    the platform driver and device split will make it much easier to separate
    hwmon functionality into its own module later on.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3e5ce914bd17335ca74a7c7b06a776c6be6ca434
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 23 11:39:05 2007 -0300

    ACPI: thinkpad-acpi: fix regression on HKEY LID event handling
    
    We were letting ThinkPad-specific LID events through to userspace again,
    instead of dropping them.  Fix it.  We don't want to give userspace the
    option of not using generic LID handling.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3eea123df1637a88d0899626a67b83dca959efff
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 23 11:39:04 2007 -0300

    ACPI: thinkpad-acpi: dequeue all pending hot key events at once (v2.2)
    
    Receive all pending HKEY events at once from a single notification, and don't
    complain if the queue is empty.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1b6521dc84f372dd92a96381fbeeebb01173d050
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 23 11:39:03 2007 -0300

    ACPI: thinkpad-acpi: check version of hot key firmware
    
    Check the HKEY firmware version (HKEY.MHKV handler), and refuse to load if
    it is unknown.  Use this instead of the presence of HKEY.DHKV to detect hot
    key mask capability.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8fef502e5a14df05f1e755edc9175e01c9814080
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 23 11:39:02 2007 -0300

    ACPI: thinkpad-acpi: keep track of module state
    
    Keep track of module state (init, running, exit).  This makes it trivially
    easy to avoid running any interrupt handlers, threads, or any other async
    activity before we are ready, or when we want to go away.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8523ed6fb2ca04973fe759fda8ab4af72492fc7e
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 23 11:39:01 2007 -0300

    ACPI: thinkpad-acpi: add mutex-based locking to input device event send path
    
    Protect the input device event sending path with a mutex, since hot key
    input events are not atomic and require an cohesive event block to be sent
    together.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f4e1e43c607b5ead89b2135c348392810420de69
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 23 11:39:00 2007 -0300

    ACPI: thinkpad-acpi: issue EV_SYNC after EV_SWITCH
    
    We were missing a input_sync on the radio switch event report path. Add it.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4b2fe7e2a79727104e549a89a32b4aae26521861
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 23 11:38:59 2007 -0300

    ACPI: thinkpad-acpi: make room for more features in tp_features bitfield
    
    Increase tp_features to 32 bits.  It is too close to running out of room.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 03e2bf261e832abf48d40113ce08a70338dd18c9
Author: Andreas Herrmann <aherrman@arcor.de>
Date:   Mon Sep 17 23:41:05 2007 +0200

    acpi_video: kernel build error if !INPUT
    
    Commit e9dab1960ac9746fa34eff726b81635147615a79
    (ACPI video hotkey: export missing ACPI video hotkey events via input layer)
    exports ACPI video hotkey events via input layer. But this breaks kernel
    build if ACPI_VIDEO && !INPUT:
    
     LD      .tmp_vmlinux1
    drivers/built-in.o: In function `acpi_video_bus_remove':
    drivers/acpi/video.c:2007: undefined reference to `input_unregister_device'
        ...
    
    Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8a66074c379cacc79168681bf7dea37ad278f5d1
Author: Andreas Herrmann <aherrman@arcor.de>
Date:   Mon Sep 17 22:54:34 2007 +0200

    sony-laptop/thinkpad-acpi: fix INPUT=n build
    
    Build errors if CONFIG_SONY_LAPTOP && !INPUT or
    if CONFIG_THINKPAD_ACPI && !INPUT:
    
     LD      vmlinux
        ...
    drivers/built-in.o: In function `sony_laptop_remove_input':
    sony-laptop.c:(.text+0x768fb): undefined reference to `input_unregister_device'
        ...
    drivers/built-in.o: In function `thinkpad_acpi_module_exit':
    thinkpad_acpi.c:(.text+0x78c1b): undefined reference to `input_free_device'
        ...
    
    Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Acked-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4c611060660f0de3e9b8f02df207312bc6f5c331
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 5 19:56:38 2007 -0400

    ACPI: EC: Drop ECDT-based boot_ec as soon as we find DSDT-based one.
    
    ASUS notebooks have numerous problems with EC initialization
    This patch tries to work around three known issues reported
    in bugzilla 8598, 8709 and 8909/8919.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 63f0edfc0b7f8058f9d3f9b572615ec97ae011ba
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Sep 3 16:30:08 2007 +0400

    ACPI: VIDEO: Adjust current level to closest available one.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4500ca8e221e72cc38e7c239b9b1a041031ee450
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Sep 3 16:29:58 2007 +0400

    ACPI: video: Don't call absent methods
    
    Signed-off-by: Ryan May <rmay@ou.edu>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6e2157858ac94530fddbf19dc59ab6b392baf1f3
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sat Sep 1 00:11:59 2007 +0400

    ACPI: Thermal: Drop concurrent thermal checks
    
    Fix for #3686, where get_temperature() may cause thermal notify, which
    causes one more get_temperature().
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 21bc42ab852549f4a547d18d77e0e4d1b24ffd96
Author: Len Brown <len.brown@intel.com>
Date:   Tue Sep 4 12:49:22 2007 -0400

    ACPI: thermal: use round_jiffies when thermal zone polling is enabled
    
    Properly functioning systems do not use thermal zone polling,
    they use event-based notification.
    
    However, some users enable periodic thermal zone polling
    to work around bugs on their platforms, and at least one
    platform exists with a real _TZP that requests polling.
    
    While thermal zone polling (_TZP) is specified in units to 0.1 seconds,
    it actually has a maximum granularity of 1 second.  Thus, we can safely
    round up the _TZP timeout to occur on the next 1-second boundary.
    This will batch it with other 1-second-granularity timers in the
    system and thus potentially extend processor idle duration.
    
    Note that the same timer is used both for _TZP
    and for passive processor thermal throttling.
    We can not round up the timeout when it is used
    for passive thermal throttling.
    
    Also, we can not make this a deferrable timer,
    as temperature is just as relevant during idle
    as it is during non-idle.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d0482533c73a8685f7ce0951a10280cfd58b8825
Author: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Date:   Wed Aug 29 15:58:19 2007 +0930

    fujitsu-laptop: create Fujitsu laptop platform specific driver
    
    Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fd1caaed466de2ee100e250b6c755376eda7ba3b
Author: Mattia Dongili <malattia@linux.it>
Date:   Sun Aug 12 16:20:28 2007 +0900

    sony-laptop: old Vaio models contain 2 IO port entries
    
    Make the driver aware of this case and manage the existence of a
    second separate IO port.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>
