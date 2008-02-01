Return-Path: <linux-kernel-owner+w=401wt.eu-S1761927AbYBAXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761927AbYBAXVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759603AbYBAXVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:21:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:60454 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759559AbYBAXVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:21:18 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PATCH] suspend patches for 2.6.25-rc0
Date: Fri, 1 Feb 2008 18:20:56 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802011820.56693.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git suspend

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/suspend/2.6.24/acpi-suspend-20070126-2.6.24.diff.gz

 Documentation/kernel-parameters.txt        |    5 
 Documentation/power/basic-pm-debugging.txt |  216 ++++++++++++-----
 Documentation/power/devices.txt            |   49 ---
 Documentation/power/drivers-testing.txt    |   30 +-
 Documentation/power/notifiers.txt          |    8 
 Documentation/power/userland-swsusp.txt    |   82 ++----
 arch/arm/Kconfig                           |    3 
 arch/arm/mach-at91/pm.c                    |   17 +
 arch/blackfin/Kconfig                      |    4 
 arch/frv/Kconfig                           |    5 
 arch/mips/Kconfig                          |    4 
 arch/powerpc/Kconfig                       |   22 +
 arch/powerpc/platforms/52xx/lite5200_pm.c  |   10 
 arch/sh/Kconfig                            |    4 
 arch/x86/Kconfig                           |    8 
 arch/x86/kernel/suspend_64.c               |    8 
 arch/x86/mm/init_32.c                      |   10 
 drivers/acpi/hardware/hwsleep.c            |   79 ++++--
 drivers/acpi/sleep/main.c                  |  129 ++++++++--
 drivers/acpi/sleep/sleep.h                 |    2 
 drivers/base/power/Makefile                |    2 
 include/acpi/acpixf.h                      |    2 
 include/linux/Kbuild                       |    1 
 include/linux/notifier.h                   |    2 
 include/linux/suspend.h                    |   56 ++--
 include/linux/suspend_ioctls.h             |   32 ++
 kernel/power/Kconfig                       |   65 ++---
 kernel/power/disk.c                        |  204 ++++++++++++----
 kernel/power/main.c                        |  171 +++++++++++--
 kernel/power/power.h                       |   90 ++++---
 kernel/power/snapshot.c                    |   31 +-
 kernel/power/swap.c                        |   33 +-
 kernel/power/swsusp.c                      |   48 ---
 kernel/power/user.c                        |  109 ++++++--
 34 files changed, 1034 insertions(+), 507 deletions(-)

through these commits:

Adrian Bunk (1):
      Hibernation: Move function prototypes to header

Alan Stern (2):
      Hibernation: Add PM_RESTORE_PREPARE and PM_POST_RESTORE notifiers (rev. 2)
      PM: Convert PM notifiers to out-of-line code

Borislav Petkov (1):
      Suspend: Clean up suspend_64.c

David Brownell (1):
      PM: Remove obsolete /sys/devices/.../power/state docs

Johannes Berg (5):
      PM: Make PM_TRACE more architecture independent
      Hibernation: Clean up Kconfig (V2)
      Suspend: Clean up Kconfig (V2)
      Suspend: Add config option to disable the freezer if architecture wants that
      Suspend: Invoke suspend notifications after console switch

Rafael J. Wysocki (27):
      Hibernation: Introduce SNAPSHOT_GET_IMAGE_SIZE ioctl
      Hibernation: Rework platform support ioctls (rev. 2)
      Hibernation: Mark SNAPSHOT_SET_SWAP_FILE ioctl as deprecated (rev. 2)
      Hibernation: Correct definitions of some ioctls (rev. 2)
      Hibernation: Introduce exportable suspend ioctls header (rev. 2)
      ACPI: Fix mismerge in acpi_hibernation_finish
      Suspend: Testing facility (rev. 2)
      suspend: build fix responding to 2.6.25 kset change
      Hibernation: New testing facility (rev. 2)
      PM: Suspend/hibernation debug documentation update (rev. 2)
      Suspend: Fix compilation warning for CONFIG_SUSPEND unset
      Hibernation: Move low level resume to disk.c
      Suspend: Fix comment in main.c
      Hibernation: Fix comment in disk.c
      Hibernation: Remove unnecessary variable declaration
      Suspend: Use common prefix in messages
      Hibernation: Update messages
      suspend: fix ia64 allmodconfig build
      Suspend: Introduce begin() and end() callbacks
      ACPI: Separate invocations of _GTS and _BFS from _PTS and _WAK
      ACPI: Separate disabling of GPEs from _PTS
      ACPI suspend: Call _PTS before suspending devices
      Hibernation: Introduce begin() and end() callbacks
      ACPI hibernation: Call _PTS before suspending devices
      ACPI: Print message before calling _PTS
      Hibernation: Invoke suspend notifications after console switch
      suspend: cleanup reference to swsusp_pg_dir[]

Shaohua Li (1):
      ACPI: clear GPE earily in resume to avoid warning

with this log:

commit a01da01d819ceb4c3f63d2aa7e1321c6a5e53fd8
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Feb 1 15:28:16 2008 +0100

    suspend: cleanup reference to swsusp_pg_dir[]
    
    swsusp_pg_dir[] is used for suspend, but not for hibernation.
    clean-up the ifdefs which worked by accident, while implying the opposite.
    Delete the __nosavedata, which also implied the opposite.
    
    Some day we may optimize CONFIG_ACPI_SLEEP to build minimal kernels
    for just hibernate or just suspend but not both,
    but today isn't that day.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ee128c59cf30f5a013b309cf95c80f1561ca4388
Author: David Brownell <david-b@pacbell.net>
Date:   Fri Jan 11 01:26:57 2008 +0100

    PM: Remove obsolete /sys/devices/.../power/state docs
    
    The /sys/devices/.../power/state files have been gone for a while
    now, but I just noticed some documentation that still refers to
    them.  (Fortunately described as DEPRECATED and WILL REMOVE).
    
    Time to remove that obsolete documentation too ...
    
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6c6e1163d2b4833bf448f02aaf26e12053957078
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jan 11 01:25:21 2008 +0100

    Hibernation: Invoke suspend notifications after console switch
    
    Following the recent change in the suspend code path, switch consoles before
    calling PM notifiers during hibernation.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a7c630e98acfad228bd2b3bba59e163ad86ed6ee
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Fri Jan 11 01:22:23 2008 +0100

    Suspend: Invoke suspend notifications after console switch
    
    In order to fix APM emulation it is necessary to enable apm-emulation
    notifications for suspends triggered in various ways via the suspend
    notifiers.  However, this will cause the systems using APM emulation
    to lock up between X being needed to switch away from the VT and X
    already waiting for resume in the APM ioctl.
    
    This patch moves the console switch (if enabled) before the suspend
    notification (and after the resume notification) to avoid this issue.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 31210f178861d7584cab1bca12ccd5547194d9eb
Author: Borislav Petkov <bbpetkov@yahoo.de>
Date:   Mon Dec 17 00:30:22 2007 +0100

    Suspend: Clean up suspend_64.c
    
    There's a freakishly long comment in suspend_64.c, shorten it.
    
    Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 16a00d127d8162c859537bbd8cb3934603a7985a
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Jan 15 23:17:00 2008 -0500

    Suspend: Add config option to disable the freezer if architecture wants that
    
    This patch makes the freezer optional for suspend to allow the
    system to work (or not work) like the original PMU suspend.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fca1ac6dca20d23ae708b2bb85b1f4c1b7549f43
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jan 8 00:10:57 2008 +0100

    ACPI: Print message before calling _PTS
    
    Make acpi_sleep_prepare() static and cause it to print a message
    specifying the ACPI system sleep state to be entered (helpful for
    debugging the suspend/hibernation code).
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d629dee14e037644f4ddcd42f74674c782fb3ecf
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jan 8 00:09:58 2008 +0100

    ACPI hibernation: Call _PTS before suspending devices
    
    The ACPI 1.0 specification wants us to put devices into low power
    states after executing the _PTS global control method, while ACPI
    2.0 and later want us to do that in the reverse order.  The current
    hibernation code follows ACPI 2.0 in that respect which may cause some
    ACPI 1.0x systems to hang during hibernation (ref.
    http://bugzilla.kernel.org/show_bug.cgi?id=9528).
    
    Make the hibernation code execute _PTS before putting devices into
    low power states (ie. in accordance with ACPI 1.0x) with the
    possibility to override that using the 'acpi_new_pts_ordering' kernel
    command line option.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 07f44315b9cfad180296df99bcd38879f063f092
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jan 8 00:08:44 2008 +0100

    Hibernation: Introduce begin() and end() callbacks
    
    Introduce global hibernation callback .end() and rename global
    hibernation callback .start() to .begin(), in analogy with the
    recent modifications of the global suspend callbacks.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c833a830b4926ea04d190524966874d061397900
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jan 8 00:07:39 2008 +0100

    ACPI suspend: Call _PTS before suspending devices
    
    The ACPI 1.0 specification wants us to put devices into low power
    states after executing the _PTS global control method, while ACPI
    2.0 and later want us to do that in the reverse order.  The current
    suspend code follows ACPI 2.0 in that respect which causes some
    ACPI 1.0x systems to hang during suspend (ref.
    http://bugzilla.kernel.org/show_bug.cgi?id=9528).
    
    Make the suspend code execute _PTS before putting devices into low
    power states (ie. in accordance with ACPI 1.0x) and provide a command
    line option to override the default if need be.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aedf9a8ff25f5890eb416d95520afdc5d40e539b
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jan 8 00:06:16 2008 +0100

    ACPI: Separate disabling of GPEs from _PTS
    
    The preparation to enter an ACPI system sleep state is now tied to
    the disabling of GPEs, but the GPEs should not be disabled before
    suspending devices.  Since on ACPI 1.0x systems the _PTS global
    control method should be executed before suspending devices, we
    need to disable GPEs separately.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4e1bc50b0e083b4d990f6eb54a6a098565bd5197
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jan 8 00:05:21 2008 +0100

    ACPI: Separate invocations of _GTS and _BFS from _PTS and _WAK
    
    The execution of ACPI global control methods _GTS and _BFS is
    currently tied to the preparation to enter a sleep state and to the
    leaving of the sleep state, respectively.  However, these functions
    are called before disabling the nonboot CPUs and after enabling
    them, respectively (in fact, on ACPI 1.0x systems the first of them
    ought to be called before suspending devices), while according to the
    ACPI specification, _GTS is to be executed right prior to entering
    the system sleep state and _BFS is to be executed right after the
    platfor firmware has returned control to the OS on wake up.
    
    Move the execution of _GTS and _BFS to the right places.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 68db114effdf54dd7fc0c724ab2aef5bc98d9c79
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jan 8 00:04:17 2008 +0100

    Suspend: Introduce begin() and end() callbacks
    
    On ACPI systems the target state set by acpi_pm_set_target() is
    reset by acpi_pm_finish(), but that need not be called if the
    suspend fails.  All platforms that use the .set_target() global
    suspend callback are affected by analogous issues.
    
    For this reason, we need an additional global suspend callback that
    will reset the target state regardless of whether or not the suspend
    is successful.  Also, it is reasonable to rename the .set_target()
    callback, since it will be used for a different purpose on ACPI
    systems (due to ACPI 1.0x code ordering requirements).
    
    Introduce the global suspend callback .end() to be executed at the
    end of the suspend sequence and rename the .set_target() global
    suspend callback to .begin().
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fbfe034f5ef51cdd8338a868a2101608f8c45757
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Dec 14 01:07:13 2007 +0100

    suspend: fix ia64 allmodconfig build
    
    kernel/power/main.c:488: error: ‘pm_test_attr’ undeclared here (not in a function)
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4e29bddd1bc13fe78da1d1a11dcb335f7fe36f6e
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Wed Jun 20 09:17:58 2007 +0800

    ACPI: clear GPE earily in resume to avoid warning
    
    Wakeup GPE hasn't a handler. If system is waked up by such GPE like a
    USB hotplug, I saw a lot of error reporting the GPE hasn't handler.
    acpi_leave_sleep_state will clear the GPE but it's too late, we should
    do it before interrupt is re-enabled.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9a72d19a83ff28dd65eae54e210a9141ad993e88
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Sat Dec 8 02:14:00 2007 +0100

    Suspend: Clean up Kconfig (V2)
    
    This cleans up the suspend Kconfig and removes the need to
    declare centrally which architectures support suspend. All
    architectures that currently support suspend are modified
    accordingly.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Acked-by: Russell King <rmk@arm.linux.org.uk>
    Acked-by: Paul Mackerras <paulus@samba.org>
    Acked-by: Ralf Baechle <ralf@linux-mips.org>
    Acked-by: Paul Mundt <lethal@linux-sh.org>
    Cc: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 03f5cd73a5b5b30f6f3bcf8d68b3b79afb8cb880
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Sat Dec 8 02:12:39 2007 +0100

    Hibernation: Clean up Kconfig (V2)
    
    This cleans up the hibernation Kconfig and removes the need to
    declare centrally which architectures support hibernation. All
    architectures that currently support hibernation are modified
    accordingly.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Acked-by: Paul Mackerras <paulus@samba.org>
    Cc: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5c54eb7f956ad54ecb2ffb7933f26831a3b83bb4
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Dec 8 02:09:43 2007 +0100

    Hibernation: Update messages
    
    Make hibernation messages start with one common prefix "PM: " and use
    the word "hibernation" in the messages as a synonym of "suspend to
    disk".
    
    Turn some KERN_INFO messages into debug ones.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ee4d64cfc351e1d33a43a62c072228a8d633f9e4
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Dec 8 02:08:38 2007 +0100

    Suspend: Use common prefix in messages
    
    Make suspend messages start with one common prefix "PM: ".
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5521e77e047321aa77c606d275093e24897c0fa2
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Dec 8 02:07:40 2007 +0100

    Hibernation: Remove unnecessary variable declaration
    
    Remove the unnecessary extern declaration of resume_file[]
    from kernel/power/swap.c .
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9248efd164497b06c942e1c38d51a90c268265ef
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Dec 8 02:06:57 2007 +0100

    Hibernation: Fix comment in disk.c
    
    Fix a comment in kernel/power/disk.c so that it doesn't contain lines
    longer that 80 characters.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 531ca296b97439089a9976c3344e4e2eaa0381a6
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Dec 8 02:06:00 2007 +0100

    Suspend: Fix comment in main.c
    
    Fix a comment in kernel/power/main.c so that it doesn't contain lines
    longer that 80 characters.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d2fdea0305f2b5c6887eff954d1cabb304a376ae
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Dec 8 02:04:21 2007 +0100

    Hibernation: Move low level resume to disk.c
    
    Move the low level restore code to kernel/power/disk.c , since the
    corresponding low level hibernation code is already there.
    
    Make restore fail if device_power_down(PMSG_PRETHAW) returns an
    error.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2006b470bbc77e4d6b46a7bbb5b68119e1a8db3f
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Dec 8 02:03:26 2007 +0100

    Suspend: Fix compilation warning for CONFIG_SUSPEND unset
    
    Suspend: Make debug facility depend on CONFIG_SUSPEND
    
    Make the new suspend debug facility code depend on CONFIG_SUSPEND,
    as appropriate, to remove the compiler warning printed when CONFIG_PM is set
    and CONFIG_SUSPEND is not set.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8ff7d174bef41a219ea7a2d4e99cfd4e8aae0c8c
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Mon Nov 19 23:49:18 2007 +0100

    PM: Convert PM notifiers to out-of-line code
    
    This patch (as1008b) converts the PM notifier routines from inline
    calls to out-of-line code.  It also prevents pm_chain_head from
    being created when CONFIG_PM_SLEEP isn't enabled, and EXPORTs the
    notifier registration and unregistration routines.
    
    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 76eb98a092c3481b3c1f1b9c67c97e77b8cdcea0
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Mon Nov 19 23:46:16 2007 +0100

    PM: Make PM_TRACE more architecture independent
    
    When trying to debug a suspend failure I started implementing
    PM_TRACE for powerpc. I then noticed that I'm debugging a suspend
    failure and so PM_TRACE isn't useful at all, but thought that
    nonetheless this could be useful in the future.
    
    Basically, to support PM_TRACE, you add a Kconfig option that
    selects PM_TRACE and provides the infrastructure as per the
    help text of PM_TRACE.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5c93d7a4578d187f9a529f986626cd37ab6e3e83
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Nov 19 23:43:34 2007 +0100

    PM: Suspend/hibernation debug documentation update (rev. 2)
    
    Update the suspend/hibernation debugging and testing documentation to describe
    the newly introduced testing facilities.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 460db5c6402b5a4e362b564bdfa436dfa4e3b661
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Nov 19 23:42:31 2007 +0100

    Hibernation: New testing facility (rev. 2)
    
    Make it possible to test the hibernation core code with the help of the
    /sys/power/pm_test attribute introduced for suspend testing in the previous
    patch.
    
    Writing an appropriate string to this file causes the hibernation code to work
    in one of the test modes defined as follows:
    
    freezer
    - test the freezing of processes
    
    devices
    - test the freezing of processes and suspending of devices
    
    platform
    - test the freezing of processes, suspending of devices and platform global
      control methods(*)
    
    processors
    - test the freezing of processes, suspending of devices, platform global
      control methods(*) and the disabling of nonboot CPUs
    
    core
    - test the freezing of processes, suspending of devices, platform global
      control methods(*), the disabling of nonboot CPUs and suspending of
      platform/system devices
    
    (*) - the platform global control methods are only available on ACPI systems
          and are only tested if the hibernation mode is set to "platform"
    
    Then, if a hibernation is started by normal means, the hibernation core will
    perform its normal operations up to the point indicated by given test level.
    Next, it will wait for 5 seconds and carry out the resume operations needed to
    transition the system back to the fully functional state.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 21779c8de31b1c9e749af676a033109f70156678
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jan 29 00:29:06 2008 +0100

    suspend: build fix responding to 2.6.25 kset change
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 73b3b8a6d123c77888caa9acfb5938fc784e7732
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Nov 19 23:41:19 2007 +0100

    Suspend: Testing facility (rev. 2)
    
    Introduce sysfs attribute /sys/power/pm_test allowing one to test the suspend
    core code.  Namely, writing one of the strings:
    
    freezer
    devices
    platform
    processors
    core
    
    to this file causes the suspend code to work in one of the test modes defined as
    follows:
    
    freezer
    - test the freezing of processes
    
    devices
    - test the freezing of processes and suspending of devices
    
    platform
    - test the freezing of processes, suspending of devices and platform global
      control methods(*)
    
    processors
    - test the freezing of processes, suspending of devices, platform global
      control methods and the disabling of nonboot CPUs
    
    core
    - test the freezing of processes, suspending of devices, platform global
      control methods, the disabling of nonboot CPUs and suspending of
      platform/system devices
    
    (*) These are ACPI global control methods on ACPI systems
    
    Then, if a suspend is started by normal means, the suspend core will perform
    its normal operations up to the point indicated by given test level.  Next, it
    will wait for 5 seconds and carry out the resume operations needed to transition
    the system back to the fully functional state.
    
    Writing "none" to /sys/power/pm_test turns the testing off.
    
    When open for reading, /sys/power/pm_test contains a space-separated list of all
    available tests (including "none" that represents the normal functionality) in
    which the current test level is indicated by square brackets.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f0c5038e08f04af6f6aa0536c7efed6e128520fe
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Mon Nov 19 23:38:25 2007 +0100

    Hibernation: Add PM_RESTORE_PREPARE and PM_POST_RESTORE notifiers (rev. 2)
    
    Add PM_RESTORE_PREPARE and PM_POST_RESTORE notifiers to the PM core, to be used
    in analogy with the existing PM_HIBERNATION_PREPARE and PM_POST_HIBERNATION
    notifiers.
    
    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: "Rafael J. Wysocki" <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d7b47cc8a4c8dbb1a4a05f4ee48304fb4a4e0099
Author: Adrian Bunk <bunk@kernel.org>
Date:   Mon Nov 19 23:36:20 2007 +0100

    Hibernation: Move function prototypes to header
    
    This patch moves the prototypes of count_highmem_pages() and
    restore_highmem() to kernel/power/power.h
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0122b99e0414205d1f3c1f4bf80f2082f6f1c8b0
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Nov 19 23:33:59 2007 +0100

    ACPI: Fix mismerge in acpi_hibernation_finish
    
    Some code in acpi_hibernation_finish() was moved to acpi_hibernation_leave(),
    but the old copy had been left (it's harmless, but also useless).  Remove it.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f07d2c9078e140323301a72140c6caeb372448dc
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Oct 26 01:05:05 2007 +0200

    Hibernation: Introduce exportable suspend ioctls header (rev. 2)
    
    Move the definitions of hibernation ioctls to a separate header file in
    include/linux, which can be exported to the user space.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f5147875db58350b7c29856b83ef1e38e88a387b
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Oct 26 01:03:33 2007 +0200

    Hibernation: Correct definitions of some ioctls (rev. 2)
    
    Three ioctl numbers belonging to the hibernation userland interface,
    SNAPSHOT_ATOMIC_SNAPSHOT, SNAPSHOT_AVAIL_SWAP, SNAPSHOT_GET_SWAP_PAGE,
    are defined in a wrong way (eg. not portable).  Provide new ioctl numbers for
    these ioctls and mark the existing ones as deprecated.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dbb027badbbd8ae51e914eca50774755d207826a
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Oct 26 01:02:15 2007 +0200

    Hibernation: Mark SNAPSHOT_SET_SWAP_FILE ioctl as deprecated (rev. 2)
    
    Mark the SNAPSHOT_SET_SWAP_FILE ioctl belonging to the hibernation userland
    interface as deprecated.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6ef4bd5a2709f3f8d28e0ce83c911ed2a8af5afe
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Oct 26 01:01:10 2007 +0200

    Hibernation: Rework platform support ioctls (rev. 2)
    
    Modify the hibernation userland interface by adding two new ioctls to it,
    SNAPSHOT_PLATFORM_SUPPORT and SNAPSHOT_POWER_OFF, that can be used,
    respectively, to switch the hibernation platform support on/off and to make the
    kernel transition the system to the hibernation state (eg. ACPI S4) using the
    platform (eg. ACPI) driver.
    
    These ioctls are intended to replace the misdesigned SNAPSHOT_PMOPS ioctl,
    which from now is regarded as obsolete and will be removed in the future.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit edae89f5d1eb1fbe1cab74333db5a8e29776900e
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Oct 26 00:59:31 2007 +0200

    Hibernation: Introduce SNAPSHOT_GET_IMAGE_SIZE ioctl
    
    Add a new ioctl, SNAPSHOT_GET_IMAGE_SIZE, returning the size of the (just
    created) hibernation image, to the hibernation userland interface.
    
    This ioctl is necessary so that the userland utilities using the interface need
    not access the hibernation image header, owned by the kernel, in order to obtain
    the size of the image.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>
