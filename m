Return-Path: <linux-kernel-owner+w=401wt.eu-S1161195AbXDNMYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161195AbXDNMYx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 08:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161204AbXDNMYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 08:24:52 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:4290 "EHLO yumi.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161195AbXDNMYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 08:24:51 -0400
Date: Sat, 14 Apr 2007 14:24:47 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070414122447.GA2827@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Adrian Bunk <bunk@stusta.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	pavel@suse.cz, linux-pm@lists.osdl.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070413212954.GA2545@melchior.yamamaya.is-a-geek.org> <20070413235017.GR5907@stusta.de> <20070414120900.GA3001@melchior.yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070414120900.GA3001@melchior.yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Adrian Bunk wrote:
> > On Fri, Apr 13, 2007 at 11:29:55PM +0200, Tobias Diedrich wrote:
> > > Linus Torvalds wrote:
> > > 
> > > > We should be getting close to a 2.6.21 release, so please update any 
> > > > regression reports you've done,
> > > 
> > > For me, suspend to disk works only once (has been the case for all
> > > .21-rcs IIRC, but I didn't get around to report it so far).
> > > There are some threads about an issue like this, which is supposed
> > > to be fixed by disabling CONFIG_PCI_MSI, but on my system the
> > > problem persists nonetheless.
> > > 
> > > On the second suspend attempt, the last message I see is
> > > "Suspending console(s)"
> > > 
> > > If I find the time, I'll try to bisect it this weekend.
> > >...
> > 
> > Does CONFIG_HPET_TIMER=n make any difference?
> > Does the latest -git work?
> 
> bisect results:
> 
> git-bisect start
> # good: [fa285a3d7924a0e3782926e51f16865c5129a2f7] Linux 2.6.20
> git-bisect good fa285a3d7924a0e3782926e51f16865c5129a2f7
> # bad: [2eb1ae149a28c1b8ade687c5fbab3c37da4c0fba] Linux 2.6.21-rc1
> git-bisect bad 2eb1ae149a28c1b8ade687c5fbab3c37da4c0fba
> # bad: [574009c1a895aeeb85eaab29c235d75852b09eb8] Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus
> git-bisect bad 574009c1a895aeeb85eaab29c235d75852b09eb8
> # good: [43187902cbfafe73ede0144166b741fb0f7d04e1] Merge master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6
> git-bisect good 43187902cbfafe73ede0144166b741fb0f7d04e1
> # good: [beda9f3a13bbb22cde92a45f230a02ef2afef6a9] kbuild: more Makefile cleanups
> git-bisect good beda9f3a13bbb22cde92a45f230a02ef2afef6a9
> # bad: [7edc136ab688f751037a86e8a051151d7962d33f] Char: isicom, support higher rates
> git-bisect bad 7edc136ab688f751037a86e8a051151d7962d33f
> # good: [6267276f3fdda9ad0d5ca451bdcbdf42b802d64b] optional ZONE_DMA: deal with cases of ZONE_DMA meaning the first zone
> git-bisect good 6267276f3fdda9ad0d5ca451bdcbdf42b802d64b
> # bad: [b4ac91a0eac36f347a509afda07e4305e931de61] uml: chan_user.h formatting fixes
> git-bisect bad b4ac91a0eac36f347a509afda07e4305e931de61
> # bad: [bf0059b23fd2f0b304f647d87fad0aa626ecf0c0] M68KNOMMU: user ARRAY_SIZE macro when appropriate
> git-bisect bad bf0059b23fd2f0b304f647d87fad0aa626ecf0c0
> # good: [c1725f2af89f1eda3cb9007290971b55084569a4] ARM26: Use ARRAY_SIZE macro when appropriate
> git-bisect good c1725f2af89f1eda3cb9007290971b55084569a4
> # bad: [9b87ed790714bd3a8d492feb24f6c48f8bb59c3a] m32r: fix do_page_fault and update_mmu_cache
> git-bisect bad 9b87ed790714bd3a8d492feb24f6c48f8bb59c3a
> # bad: [d12c610e08022a1b84d6bd4412c189214d32e713] swsusp-change-code-ordering-in-userc-sanity
> git-bisect bad d12c610e08022a1b84d6bd4412c189214d32e713
> # bad: [ed746e3b18f4df18afa3763155972c5835f284c5] swsusp: Change code ordering in disk.c
> git-bisect bad ed746e3b18f4df18afa3763155972c5835f284c5
> # good: [e3c7db621bed4afb8e231cb005057f2feb5db557] PM: Change code ordering in main.c
> git-bisect good e3c7db621bed4afb8e231cb005057f2feb5db557
> 
> 
> ed746e3b18f4df18afa3763155972c5835f284c5 is first bad commit
> commit ed746e3b18f4df18afa3763155972c5835f284c5
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Sat Feb 10 01:43:32 2007 -0800
> 
>     [PATCH] swsusp: Change code ordering in disk.c
>     
>     Change the ordering of code in kernel/power/disk.c so that device_suspend() is
>     called before disable_nonboot_cpus() and platform_finish() is called after
>     enable_nonboot_cpus() and before device_resume(), as indicated by the recent
>     discussion on Linux-PM (cf.
>     http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).
>     
>     The changes here only affect the built-in swsusp.
>     
>     [alexey.y.starikovskiy@linux.intel.com: fix LED blinking during image load]
>     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>     Acked-by: Pavel Machek <pavel@ucw.cz>
>     Cc: Greg KH <greg@kroah.com>
>     Cc: Nigel Cunningham <nigel@suspend2.net>
>     Cc: Patrick Mochel <mochel@digitalimplant.org>
>     Cc: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> :040000 040000 7eca5b3a8f9606bc4f2ff41192ec8c9d4ca90d18 8313b674e1d1bdf6849350af06d28a89b3bb3054 M      kernel
> 
> 
> Now, the remaining test is to try reverting this commit from -rc6. :)

Doesn't apply cleanly against -rc6, but fixes the problem when
reverted from -rc1.

Index: linux-2.6.21-rc1/kernel/power/disk.c
===================================================================
--- linux-2.6.21-rc1.orig/kernel/power/disk.c	2007-04-14 14:16:59.000000000 +0200
+++ linux-2.6.21-rc1/kernel/power/disk.c	2007-04-14 14:17:03.000000000 +0200
@@ -87,24 +87,52 @@
 	}
 }
 
-static void unprepare_processes(void)
-{
-	thaw_processes();
-	pm_restore_console();
-}
-
 static int prepare_processes(void)
 {
 	int error = 0;
 
 	pm_prepare_console();
+
+	error = disable_nonboot_cpus();
+	if (error)
+		goto enable_cpus;
+
 	if (freeze_processes()) {
 		error = -EBUSY;
-		unprepare_processes();
+		goto thaw;
 	}
+
+	if (pm_disk_mode == PM_DISK_TESTPROC) {
+		printk("swsusp debug: Waiting for 5 seconds.\n");
+		mdelay(5000);
+		goto thaw;
+	}
+
+	error = platform_prepare();
+	if (error)
+		goto thaw;
+
+	/* Free memory before shutting down devices. */
+	if (!(error = swsusp_shrink_memory()))
+		return 0;
+
+	platform_finish();
+ thaw:
+	thaw_processes();
+ enable_cpus:
+	enable_nonboot_cpus();
+	pm_restore_console();
 	return error;
 }
 
+static void unprepare_processes(void)
+{
+	platform_finish();
+	thaw_processes();
+	enable_nonboot_cpus();
+	pm_restore_console();
+}
+
 /**
  *	pm_suspend_disk - The granpappy of hibernation power management.
  *
@@ -122,45 +150,29 @@
 	if (error)
 		return error;
 
-	if (pm_disk_mode == PM_DISK_TESTPROC) {
-		printk("swsusp debug: Waiting for 5 seconds.\n");
-		mdelay(5000);
-		goto Thaw;
-	}
-	/* Free memory before shutting down devices. */
-	error = swsusp_shrink_memory();
-	if (error)
-		goto Thaw;
-
-	error = platform_prepare();
-	if (error)
-		goto Thaw;
+	if (pm_disk_mode == PM_DISK_TESTPROC)
+		return 0;
 
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
 	if (error) {
-		printk(KERN_ERR "PM: Some devices failed to suspend\n");
-		goto Resume_devices;
+		resume_console();
+		printk("Some devices failed to suspend\n");
+		goto Thaw;
 	}
-	error = disable_nonboot_cpus();
-	if (error)
-		goto Enable_cpus;
 
 	if (pm_disk_mode == PM_DISK_TEST) {
 		printk("swsusp debug: Waiting for 5 seconds.\n");
 		mdelay(5000);
-		goto Enable_cpus;
+		goto Done;
 	}
 
 	pr_debug("PM: snapshotting memory.\n");
 	in_suspend = 1;
-	error = swsusp_suspend();
-	if (error)
-		goto Enable_cpus;
+	if ((error = swsusp_suspend()))
+		goto Done;
 
 	if (in_suspend) {
-		enable_nonboot_cpus();
-		platform_finish();
 		device_resume();
 		resume_console();
 		pr_debug("PM: writing image.\n");
@@ -176,10 +188,7 @@
 	}
 
 	swsusp_free();
- Enable_cpus:
-	enable_nonboot_cpus();
- Resume_devices:
-	platform_finish();
+ Done:
 	device_resume();
 	resume_console();
  Thaw:
@@ -228,28 +237,19 @@
 
 	pr_debug("PM: Checking swsusp image.\n");
 
-	error = swsusp_check();
-	if (error)
+	if ((error = swsusp_check()))
 		goto Done;
 
 	pr_debug("PM: Preparing processes for restore.\n");
 
-	error = prepare_processes();
-	if (error) {
+	if ((error = prepare_processes())) {
 		swsusp_close();
 		goto Done;
 	}
 
-	error = platform_prepare();
-	if (error) {
-		swsusp_free();
-		goto Thaw;
-	}
-
 	pr_debug("PM: Reading swsusp image.\n");
 
-	error = swsusp_read();
-	if (error) {
+	if ((error = swsusp_read())) {
 		swsusp_free();
 		goto Thaw;
 	}
@@ -257,22 +257,21 @@
 	pr_debug("PM: Preparing devices for restore.\n");
 
 	suspend_console();
-	error = device_suspend(PMSG_PRETHAW);
-	if (error)
-		goto Free;
+	if ((error = device_suspend(PMSG_PRETHAW))) {
+		resume_console();
+		printk("Some devices failed to suspend\n");
+		swsusp_free();
+		goto Thaw;
+	}
 
-	error = disable_nonboot_cpus();
-	if (!error)
-		swsusp_resume();
+	mb();
 
-	enable_nonboot_cpus();
- Free:
-	swsusp_free();
-	platform_finish();
+	pr_debug("PM: Restoring saved image.\n");
+	swsusp_resume();
+	pr_debug("PM: Restore failed, recovering.n");
 	device_resume();
 	resume_console();
  Thaw:
-	printk(KERN_ERR "PM: Restore failed, recovering.\n");
 	unprepare_processes();
  Done:
 	/* For success case, the suspend path will release the lock */

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
