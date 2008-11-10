Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYKJIW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYKJIW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYKJIWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:22:20 -0500
Received: from ms01.sssup.it ([193.205.80.99]:60780 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753353AbYKJIWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:22:19 -0500
Message-ID: <4917EF14.2070309@yahoo.it>
Date: Mon, 10 Nov 2008 09:21:40 +0100
From: michael <trimarchimichael@yahoo.it>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: joel.becker@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V2] Check if the Hangcheck-timer TSC source is stable
References: <491371A8.3090603@yahoo.it> <20081107092314.GI15220@mail.oracle.com>
In-Reply-To: <20081107092314.GI15220@mail.oracle.com>
Content-Type: multipart/mixed;
 boundary="------------020808010001090500000100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020808010001090500000100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------020808010001090500000100
Content-Type: text/x-patch;
 name="hangcheck-timer-tsc-unstable-v3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hangcheck-timer-tsc-unstable-v3.patch"

Check if the TSC source is stable otherwise fail registration.

Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>

---
diff --git a/drivers/char/hangcheck-timer.c b/drivers/char/hangcheck-timer.c
index 712d9f2..8e6dabe 100644
--- a/drivers/char/hangcheck-timer.c
+++ b/drivers/char/hangcheck-timer.c
@@ -10,12 +10,12 @@
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
  * License version 2 as published by the Free Software Foundation.
- * 
+ *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- * 
+ *
  * You should have received a copy of the GNU General Public
  * License along with this program; if not, write to the
  * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
@@ -64,14 +64,18 @@ static int hangcheck_dump_tasks;  /* Defaults to not dumping SysRQ T */
 module_param(hangcheck_tick, int, 0);
 MODULE_PARM_DESC(hangcheck_tick, "Timer delay.");
 module_param(hangcheck_margin, int, 0);
-MODULE_PARM_DESC(hangcheck_margin, "If the hangcheck timer has been delayed more than hangcheck_margin seconds, the driver will fire.");
+MODULE_PARM_DESC(hangcheck_margin, "If the hangcheck timer has been delayed"
+		 " more than hangcheck_margin seconds, the driver will fire.");
 module_param(hangcheck_reboot, int, 0);
-MODULE_PARM_DESC(hangcheck_reboot, "If nonzero, the machine will reboot when the timer margin is exceeded.");
+MODULE_PARM_DESC(hangcheck_reboot, "If nonzero, the machine will reboot"
+		 " when the timer margin is exceeded.");
 module_param(hangcheck_dump_tasks, int, 0);
-MODULE_PARM_DESC(hangcheck_dump_tasks, "If nonzero, the machine will dump the system task state when the timer margin is exceeded.");
+MODULE_PARM_DESC(hangcheck_dump_tasks, "If nonzero, the machine will dump"
+		 " the system task state when the timer margin is exceeded.");
 
 MODULE_AUTHOR("Oracle");
-MODULE_DESCRIPTION("Hangcheck-timer detects when the system has gone out to lunch past a certain margin.");
+MODULE_DESCRIPTION("Hangcheck-timer detects when the system has gone"
+		   " out to lunch past a certain margin.");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(VERSION_STR);
 
@@ -81,7 +85,7 @@ MODULE_VERSION(VERSION_STR);
 static int __init hangcheck_parse_tick(char *str)
 {
 	int par;
-	if (get_option(&str,&par))
+	if (get_option(&str, &par))
 		hangcheck_tick = par;
 	return 1;
 }
@@ -89,7 +93,7 @@ static int __init hangcheck_parse_tick(char *str)
 static int __init hangcheck_parse_margin(char *str)
 {
 	int par;
-	if (get_option(&str,&par))
+	if (get_option(&str, &par))
 		hangcheck_margin = par;
 	return 1;
 }
@@ -97,7 +101,7 @@ static int __init hangcheck_parse_margin(char *str)
 static int __init hangcheck_parse_reboot(char *str)
 {
 	int par;
-	if (get_option(&str,&par))
+	if (get_option(&str, &par))
 		hangcheck_reboot = par;
 	return 1;
 }
@@ -105,7 +109,7 @@ static int __init hangcheck_parse_reboot(char *str)
 static int __init hangcheck_parse_dump_tasks(char *str)
 {
 	int par;
-	if (get_option(&str,&par))
+	if (get_option(&str, &par))
 		hangcheck_dump_tasks = par;
 	return 1;
 }
@@ -152,7 +156,7 @@ static void hangcheck_fire(unsigned long data)
 	if (cur_tsc > hangcheck_tsc)
 		tsc_diff = cur_tsc - hangcheck_tsc;
 	else
-		tsc_diff = (cur_tsc + (~0ULL - hangcheck_tsc)); /* or something */
+		tsc_diff = (cur_tsc + (~0ULL - hangcheck_tsc));
 
 	if (tsc_diff > hangcheck_tsc_margin) {
 		if (hangcheck_dump_tasks) {
@@ -172,15 +176,21 @@ static void hangcheck_fire(unsigned long data)
 	hangcheck_tsc = monotonic_clock();
 }
 
-
 static int __init hangcheck_init(void)
 {
-	printk("Hangcheck: starting hangcheck timer %s (tick is %d seconds, margin is %d seconds).\n",
+	printk(KERN_INFO "Hangcheck: starting hangcheck timer %s"
+			 " (tick is %d seconds, margin is %d seconds).\n",
 	       VERSION_STR, hangcheck_tick, hangcheck_margin);
-#if defined (HAVE_MONOTONIC)
-	printk("Hangcheck: Using monotonic_clock().\n");
+#if defined(HAVE_MONOTONIC)
+	printk(KERN_INFO "Hangcheck: Using monotonic_clock().\n");
 #else
-	printk("Hangcheck: Using get_cycles().\n");
+	if (!check_tsc_unstable())
+		printk(KERN_INFO "Hangcheck: Using get_cycles().\n");
+	else {
+		printk(KERN_ERR "Handcheck: Failed to register"
+		       " (Unstable TSC).\n");
+		return -ENODEV;
+	}
 #endif  /* HAVE_MONOTONIC */
 	hangcheck_tsc_margin =
 		(unsigned long long)(hangcheck_margin + hangcheck_tick);
@@ -196,7 +206,7 @@ static int __init hangcheck_init(void)
 static void __exit hangcheck_exit(void)
 {
 	del_timer_sync(&hangcheck_ticktock);
-        printk("Hangcheck: Stopped hangcheck timer.\n");
+	printk(KERN_INFO "Hangcheck: Stopped hangcheck timer.\n");
 }
 
 module_init(hangcheck_init);

--------------020808010001090500000100--
