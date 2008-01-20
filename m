Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYATODl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYATODl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 09:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbYATODc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 09:03:32 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40635 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYATODb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 09:03:31 -0500
Date: Sun, 20 Jan 2008 16:02:13 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] the scheduled 'time' option removal
Message-ID: <20080120140213.GG8669@does.not.exist>
References: <20080101134656.GG2360@does.not.exist> <20080101180751.9d31262b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080101180751.9d31262b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 06:07:51PM -0800, Randy Dunlap wrote:
> On Tue, 1 Jan 2008 15:46:56 +0200 Adrian Bunk wrote:
> 
> > This patch contains the scheduled removal of the 'time' option.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Thanks.  Looks good except that Documentation/kernel-parameters.txt
> needs a patch also:  delete these 3 lines:
> 
> 	time		Show timing data prefixed to each printk message line
> 			[deprecated, see 'printk.time']
> 
> then I will Ack it.

Ups, sorry, fixed patch below.

cu
Adrian


<--  snip  -->


This patch contains the scheduled removal of the 'time' option.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/feature-removal-schedule.txt |    8 --------
 Documentation/kernel-parameters.txt        |    3 ---
 kernel/printk.c                            |   13 -------------
 3 files changed, 24 deletions(-)

84ec4030ca61db7f80b6d761acb7d12255cc5cf6 
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 20c4c8b..93aac19 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -233,14 +233,6 @@ Who:	Jean Delvare <khali@linux-fr.org>
 
 ---------------------------
 
-What:	'time' kernel boot parameter
-When:	January 2008
-Why:	replaced by 'printk.time=<value>' so that printk timestamps can be
-	enabled or disabled as needed
-Who:	Randy Dunlap <randy.dunlap@oracle.com>
-
----------------------------
-
 What:  drivers depending on OSS_OBSOLETE
 When:  options in 2.6.23, code in 2.6.25
 Why:   obsolete OSS drivers
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c417877..79afb11 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1899,9 +1899,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			<deci-seconds>: poll all this frequency
 			0: no polling (default)
 
-	time		Show timing data prefixed to each printk message line
-			[deprecated, see 'printk.time']
-
 	tipar.timeout=	[HW,PPT]
 			Set communications timeout in tenths of a second
 			(default 15).
diff --git a/kernel/printk.c b/kernel/printk.c
index 89011bf..3aa8749 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -560,19 +560,6 @@ static int printk_time = 0;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
-static int __init printk_time_setup(char *str)
-{
-	if (*str)
-		return 0;
-	printk_time = 1;
-	printk(KERN_NOTICE "The 'time' option is deprecated and "
-		"is scheduled for removal in early 2008\n");
-	printk(KERN_NOTICE "Use 'printk.time=<value>' instead\n");
-	return 1;
-}
-
-__setup("time", printk_time_setup);
-
 __attribute__((weak)) unsigned long long printk_clock(void)
 {
 	return sched_clock();

