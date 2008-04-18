Return-Path: <linux-kernel-owner+w=401wt.eu-S1760359AbYDRSbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbYDRSbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759883AbYDRSbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:31:08 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:44194 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759730AbYDRSbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MCxhcVUeEHKsjmU1sl4ymB5PVSqoTsn1RcKOkdkXznk+dB1ESvD0vU13K1HRTlEElg9TABEe762j7fmiSTtXo4Yq/KvvcpVx5ojjB17sC4r+9hC3BsFA8zYuuuXn91lK7McfIi+Yj7ckWEdINgqNUuOpXLOdbwm1JHJURk0t5Uc=
Subject: [PATCH] kgdb: trivial sparse fixes in kgdb test-suite
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 11:31:15 -0700
Message-Id: <1208543475.17196.44.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shadowed variable and integer as NULL pointer fixes:
drivers/misc/kgdbts.c:877:6: warning: symbol 'sys_open_test' shadows an earlier one
drivers/misc/kgdbts.c:537:27: originally declared here
drivers/misc/kgdbts.c:378:22: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:386:22: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:468:30: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:472:15: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:502:30: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:506:30: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:509:30: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:523:20: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:527:20: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:530:15: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:541:21: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:545:21: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:548:15: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:559:30: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:563:15: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:573:16: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:574:19: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:578:15: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:588:16: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:589:19: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:593:15: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:602:16: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:604:15: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:925:3: warning: Using plain integer as NULL pointer
drivers/misc/kgdbts.c:938:3: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Introduced since v2.6.25

 drivers/misc/kgdbts.c |   60 ++++++++++++++++++++++++------------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 6d6286c..eef66b6 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -375,7 +375,7 @@ static void emul_sstep_get(char *arg)
 		break;
 	case 1:
 		/* set breakpoint */
-		break_helper("Z0", 0, sstep_addr);
+		break_helper("Z0", NULL, sstep_addr);
 		break;
 	case 2:
 		/* Continue */
@@ -383,7 +383,7 @@ static void emul_sstep_get(char *arg)
 		break;
 	case 3:
 		/* Clear breakpoint */
-		break_helper("z0", 0, sstep_addr);
+		break_helper("z0", NULL, sstep_addr);
 		break;
 	default:
 		eprintk("kgdbts: ERROR failed sstep get emulation\n");
@@ -465,11 +465,11 @@ static struct test_struct sw_breakpoint_test[] = {
 	{ "?", "S0*" }, /* Clear break points */
 	{ "kgdbts_break_test", "OK", sw_break, }, /* set sw breakpoint */
 	{ "c", "T0*", }, /* Continue */
-	{ "g", "kgdbts_break_test", 0, check_and_rewind_pc },
+	{ "g", "kgdbts_break_test", NULL, check_and_rewind_pc },
 	{ "write", "OK", write_regs },
 	{ "kgdbts_break_test", "OK", sw_rem_break }, /*remove breakpoint */
 	{ "D", "OK" }, /* Detach */
-	{ "D", "OK", 0,  got_break }, /* If the test worked we made it here */
+	{ "D", "OK", NULL,  got_break }, /* If the test worked we made it here */
 	{ "", "" },
 };
 
@@ -499,14 +499,14 @@ static struct test_struct singlestep_break_test[] = {
 	{ "?", "S0*" }, /* Clear break points */
 	{ "kgdbts_break_test", "OK", sw_break, }, /* set sw breakpoint */
 	{ "c", "T0*", }, /* Continue */
-	{ "g", "kgdbts_break_test", 0, check_and_rewind_pc },
+	{ "g", "kgdbts_break_test", NULL, check_and_rewind_pc },
 	{ "write", "OK", write_regs }, /* Write registers */
 	{ "kgdbts_break_test", "OK", sw_rem_break }, /*remove breakpoint */
 	{ "s", "T0*", emul_sstep_get, emul_sstep_put }, /* Single step */
-	{ "g", "kgdbts_break_test", 0, check_single_step },
+	{ "g", "kgdbts_break_test", NULL, check_single_step },
 	{ "kgdbts_break_test", "OK", sw_break, }, /* set sw breakpoint */
 	{ "c", "T0*", }, /* Continue */
-	{ "g", "kgdbts_break_test", 0, check_and_rewind_pc },
+	{ "g", "kgdbts_break_test", NULL, check_and_rewind_pc },
 	{ "write", "OK", write_regs }, /* Write registers */
 	{ "D", "OK" }, /* Remove all breakpoints and continues */
 	{ "", "" },
@@ -520,14 +520,14 @@ static struct test_struct do_fork_test[] = {
 	{ "?", "S0*" }, /* Clear break points */
 	{ "do_fork", "OK", sw_break, }, /* set sw breakpoint */
 	{ "c", "T0*", }, /* Continue */
-	{ "g", "do_fork", 0, check_and_rewind_pc }, /* check location */
+	{ "g", "do_fork", NULL, check_and_rewind_pc }, /* check location */
 	{ "write", "OK", write_regs }, /* Write registers */
 	{ "do_fork", "OK", sw_rem_break }, /*remove breakpoint */
 	{ "s", "T0*", emul_sstep_get, emul_sstep_put }, /* Single step */
-	{ "g", "do_fork", 0, check_single_step },
+	{ "g", "do_fork", NULL, check_single_step },
 	{ "do_fork", "OK", sw_break, }, /* set sw breakpoint */
 	{ "7", "T0*", skip_back_repeat_test }, /* Loop based on repeat_test */
-	{ "D", "OK", 0, final_ack_set }, /* detach and unregister I/O */
+	{ "D", "OK", NULL, final_ack_set }, /* detach and unregister I/O */
 	{ "", "" },
 };
 
@@ -538,14 +538,14 @@ static struct test_struct sys_open_test[] = {
 	{ "?", "S0*" }, /* Clear break points */
 	{ "sys_open", "OK", sw_break, }, /* set sw breakpoint */
 	{ "c", "T0*", }, /* Continue */
-	{ "g", "sys_open", 0, check_and_rewind_pc }, /* check location */
+	{ "g", "sys_open", NULL, check_and_rewind_pc }, /* check location */
 	{ "write", "OK", write_regs }, /* Write registers */
 	{ "sys_open", "OK", sw_rem_break }, /*remove breakpoint */
 	{ "s", "T0*", emul_sstep_get, emul_sstep_put }, /* Single step */
-	{ "g", "sys_open", 0, check_single_step },
+	{ "g", "sys_open", NULL, check_single_step },
 	{ "sys_open", "OK", sw_break, }, /* set sw breakpoint */
 	{ "7", "T0*", skip_back_repeat_test }, /* Loop based on repeat_test */
-	{ "D", "OK", 0, final_ack_set }, /* detach and unregister I/O */
+	{ "D", "OK", NULL, final_ack_set }, /* detach and unregister I/O */
 	{ "", "" },
 };
 
@@ -556,11 +556,11 @@ static struct test_struct hw_breakpoint_test[] = {
 	{ "?", "S0*" }, /* Clear break points */
 	{ "kgdbts_break_test", "OK", hw_break, }, /* set hw breakpoint */
 	{ "c", "T0*", }, /* Continue */
-	{ "g", "kgdbts_break_test", 0, check_and_rewind_pc },
+	{ "g", "kgdbts_break_test", NULL, check_and_rewind_pc },
 	{ "write", "OK", write_regs },
 	{ "kgdbts_break_test", "OK", hw_rem_break }, /*remove breakpoint */
 	{ "D", "OK" }, /* Detach */
-	{ "D", "OK", 0,  got_break }, /* If the test worked we made it here */
+	{ "D", "OK", NULL,  got_break }, /* If the test worked we made it here */
 	{ "", "" },
 };
 
@@ -570,12 +570,12 @@ static struct test_struct hw_breakpoint_test[] = {
 static struct test_struct hw_write_break_test[] = {
 	{ "?", "S0*" }, /* Clear break points */
 	{ "hw_break_val", "OK", hw_write_break, }, /* set hw breakpoint */
-	{ "c", "T0*", 0, got_break }, /* Continue */
-	{ "g", "silent", 0, check_and_rewind_pc },
+	{ "c", "T0*", NULL, got_break }, /* Continue */
+	{ "g", "silent", NULL, check_and_rewind_pc },
 	{ "write", "OK", write_regs },
 	{ "hw_break_val", "OK", hw_rem_write_break }, /*remove breakpoint */
 	{ "D", "OK" }, /* Detach */
-	{ "D", "OK", 0,  got_break }, /* If the test worked we made it here */
+	{ "D", "OK", NULL,  got_break }, /* If the test worked we made it here */
 	{ "", "" },
 };
 
@@ -585,12 +585,12 @@ static struct test_struct hw_write_break_test[] = {
 static struct test_struct hw_access_break_test[] = {
 	{ "?", "S0*" }, /* Clear break points */
 	{ "hw_break_val", "OK", hw_access_break, }, /* set hw breakpoint */
-	{ "c", "T0*", 0, got_break }, /* Continue */
-	{ "g", "silent", 0, check_and_rewind_pc },
+	{ "c", "T0*", NULL, got_break }, /* Continue */
+	{ "g", "silent", NULL, check_and_rewind_pc },
 	{ "write", "OK", write_regs },
 	{ "hw_break_val", "OK", hw_rem_access_break }, /*remove breakpoint */
 	{ "D", "OK" }, /* Detach */
-	{ "D", "OK", 0,  got_break }, /* If the test worked we made it here */
+	{ "D", "OK", NULL,  got_break }, /* If the test worked we made it here */
 	{ "", "" },
 };
 
@@ -599,9 +599,9 @@ static struct test_struct hw_access_break_test[] = {
  */
 static struct test_struct nmi_sleep_test[] = {
 	{ "?", "S0*" }, /* Clear break points */
-	{ "c", "T0*", 0, got_break }, /* Continue */
+	{ "c", "T0*", NULL, got_break }, /* Continue */
 	{ "D", "OK" }, /* Detach */
-	{ "D", "OK", 0,  got_break }, /* If the test worked we made it here */
+	{ "D", "OK", NULL,  got_break }, /* If the test worked we made it here */
 	{ "", "" },
 };
 
@@ -874,15 +874,15 @@ static void kgdbts_run_tests(void)
 {
 	char *ptr;
 	int fork_test = 0;
-	int sys_open_test = 0;
+	int do_sys_open_test = 0;
 	int nmi_sleep = 0;
 
 	ptr = strstr(config, "F");
 	if (ptr)
-		fork_test = simple_strtol(ptr+1, NULL, 10);
+		fork_test = simple_strtol(ptr + 1, NULL, 10);
 	ptr = strstr(config, "S");
 	if (ptr)
-		sys_open_test = simple_strtol(ptr+1, NULL, 10);
+		do_sys_open_test = simple_strtol(ptr + 1, NULL, 10);
 	ptr = strstr(config, "N");
 	if (ptr)
 		nmi_sleep = simple_strtol(ptr+1, NULL, 10);
@@ -922,7 +922,7 @@ static void kgdbts_run_tests(void)
 		repeat_test = fork_test;
 		printk(KERN_INFO "kgdbts:RUN do_fork for %i breakpoints\n",
 			repeat_test);
-		kthread_run(kgdbts_unreg_thread, 0, "kgdbts_unreg");
+		kthread_run(kgdbts_unreg_thread, NULL, "kgdbts_unreg");
 		run_do_fork_test();
 		return;
 	}
@@ -931,11 +931,11 @@ static void kgdbts_run_tests(void)
 	 * executed because a kernel thread will be spawned at the very
 	 * end to unregister the debug hooks.
 	 */
-	if (sys_open_test) {
-		repeat_test = sys_open_test;
+	if (do_sys_open_test) {
+		repeat_test = do_sys_open_test;
 		printk(KERN_INFO "kgdbts:RUN sys_open for %i breakpoints\n",
 			repeat_test);
-		kthread_run(kgdbts_unreg_thread, 0, "kgdbts_unreg");
+		kthread_run(kgdbts_unreg_thread, NULL, "kgdbts_unreg");
 		run_sys_open_test();
 		return;
 	}
-- 
1.5.5.144.g3e42



