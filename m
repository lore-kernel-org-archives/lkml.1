Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbZABWH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbZABWH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbZABWHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:07:18 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:20320 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125AbZABWHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:07:16 -0500
Date: Fri, 2 Jan 2009 14:06:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, jidanni@jidanni.org,
       330403@bugs.debian.org
Subject: [PATCH] sysrq: more explicit, less terse help messages
Message-Id: <20090102140652.aaae96ae.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.495E9000.01D0:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Eliminate sysrq terse help mode; make sysrq help messages more
meaningful (more explicit/verbose).
Make the sysrq action letter clearer by listing it explicitly
in more sysrq help messages (when it is not simple/clear).

The SysRq help message now looks like this:

SysRq : HELP : loglevel(0-9) reBoot terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) 

Addresses http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=330403.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: jidanni@jidanni.org
cc: 330403@bugs.debian.org
---
 drivers/char/sysrq.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- lnx-2628.orig/drivers/char/sysrq.c
+++ lnx-2628/drivers/char/sysrq.c
@@ -82,7 +82,7 @@ static void sysrq_handle_loglevel(int ke
 }
 static struct sysrq_key_op sysrq_loglevel_op = {
 	.handler	= sysrq_handle_loglevel,
-	.help_msg	= "loglevel0-8",
+	.help_msg	= "loglevel(0-9)",
 	.action_msg	= "Changing Loglevel",
 	.enable_mask	= SYSRQ_ENABLE_LOG,
 };
@@ -233,7 +233,7 @@ static void sysrq_handle_showallcpus(int
 
 static struct sysrq_key_op sysrq_showallcpus_op = {
 	.handler	= sysrq_handle_showallcpus,
-	.help_msg	= "aLlcpus",
+	.help_msg	= "show-backtrace-all-active-cpus(L)",
 	.action_msg	= "Show backtrace of all active CPUs",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -247,7 +247,7 @@ static void sysrq_handle_showregs(int ke
 }
 static struct sysrq_key_op sysrq_showregs_op = {
 	.handler	= sysrq_handle_showregs,
-	.help_msg	= "showPc",
+	.help_msg	= "show-registers(P)",
 	.action_msg	= "Show Regs",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -258,7 +258,7 @@ static void sysrq_handle_showstate(int k
 }
 static struct sysrq_key_op sysrq_showstate_op = {
 	.handler	= sysrq_handle_showstate,
-	.help_msg	= "showTasks",
+	.help_msg	= "show-task-states(T)",
 	.action_msg	= "Show State",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -269,7 +269,7 @@ static void sysrq_handle_showstate_block
 }
 static struct sysrq_key_op sysrq_showstate_blocked_op = {
 	.handler	= sysrq_handle_showstate_blocked,
-	.help_msg	= "shoW-blocked-tasks",
+	.help_msg	= "show-blocked-tasks(W)",
 	.action_msg	= "Show Blocked State",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -281,7 +281,7 @@ static void sysrq_handle_showmem(int key
 }
 static struct sysrq_key_op sysrq_showmem_op = {
 	.handler	= sysrq_handle_showmem,
-	.help_msg	= "showMem",
+	.help_msg	= "show-memory-usage(M)",
 	.action_msg	= "Show Memory",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -307,7 +307,7 @@ static void sysrq_handle_term(int key, s
 }
 static struct sysrq_key_op sysrq_term_op = {
 	.handler	= sysrq_handle_term,
-	.help_msg	= "tErm",
+	.help_msg	= "terminate-all-tasks(E)",
 	.action_msg	= "Terminate All Tasks",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
@@ -325,7 +325,7 @@ static void sysrq_handle_moom(int key, s
 }
 static struct sysrq_key_op sysrq_moom_op = {
 	.handler	= sysrq_handle_moom,
-	.help_msg	= "Full",
+	.help_msg	= "memory-full-oom-kill(F)",
 	.action_msg	= "Manual OOM execution",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
@@ -337,7 +337,7 @@ static void sysrq_handle_kill(int key, s
 }
 static struct sysrq_key_op sysrq_kill_op = {
 	.handler	= sysrq_handle_kill,
-	.help_msg	= "kIll",
+	.help_msg	= "kill-all-tasks(I)",
 	.action_msg	= "Kill All Tasks",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
@@ -348,7 +348,7 @@ static void sysrq_handle_unrt(int key, s
 }
 static struct sysrq_key_op sysrq_unrt_op = {
 	.handler	= sysrq_handle_unrt,
-	.help_msg	= "Nice",
+	.help_msg	= "nice-all-RT-tasks(N)",
 	.action_msg	= "Nice All RT Tasks",
 	.enable_mask	= SYSRQ_ENABLE_RTNICE,
 };
