Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbYGJVk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbYGJVk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYGJVkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:40:15 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:4760 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbYGJVkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:40:13 -0400
X-Greylist: delayed 1908 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2008 17:40:13 EDT
Date: Thu, 10 Jul 2008 16:07:57 -0500 (CDT)
From: Milton Miller <miltonm@bga.com>
To: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
In-Reply-To: <200807081801.38026.rusty@rustcorp.com.au>
References: <200807081801.38026.rusty@rustcorp.com.au>,
	<200807081750.55536.rusty@rustcorp.com.au>,
	<200807081756.02838.rusty@rustcorp.com.au>,
	<200807081756.47140.rusty@rustcorp.com.au>
Message-Id: <for-27-patch0-1@bga.com>
Subject: [PATCH -next-20080709] fixup stop_machine use cpu mask vs ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Rusty, Ingo.

Rusty's patch [PATCH 3/3] stop_machine: use cpu mask rather than magic numbers
didn't find kernel/trace/ftrace.c in -next, causing an immediate almost NULL
pointer dereference in ftrace_dynamic_init.


Signed-off-by: Milton Miller <miltonm@bga.com>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0f271c4..c29acb5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -587,7 +587,7 @@ static int __ftrace_modify_code(void *data)
 
 static void ftrace_run_update_code(int command)
 {
-	stop_machine_run(__ftrace_modify_code, &command, NR_CPUS);
+	stop_machine_run(__ftrace_modify_code, &command, NULL);
 }
 
 void ftrace_disable_daemon(void)
@@ -787,7 +787,7 @@ static int ftrace_update_code(void)
 	    !ftrace_enabled || !ftraced_trigger)
 		return 0;
 
-	stop_machine_run(__ftrace_update_code, NULL, NR_CPUS);
+	stop_machine_run(__ftrace_update_code, NULL, NULL);
 
 	return 1;
 }
@@ -1564,7 +1564,7 @@ static int __init ftrace_dynamic_init(void)
 
 	addr = (unsigned long)ftrace_record_ip;
 
-	stop_machine_run(ftrace_dyn_arch_init, &addr, NR_CPUS);
+	stop_machine_run(ftrace_dyn_arch_init, &addr, NULL);
 
 	/* ftrace_dyn_arch_init places the return code in addr */
 	if (addr) {
