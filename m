Return-Path: <linux-kernel-owner+w=401wt.eu-S934643AbYBHS0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934643AbYBHS0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934694AbYBHSZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:25:51 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:45289 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934691AbYBHSZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:25:50 -0500
Date: Fri, 8 Feb 2008 18:25:13 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Paul Mackerras <paulus@samba.org>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: fix DEBUG_PREEMPT warning when warning
Message-ID: <Pine.LNX.4.64.0802081823400.6273@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The powerpc show_regs prints CPU using smp_processor_id: change that to
raw_smp_processor_id, so that when it's showing a WARN_ON backtrace without
preemption disabled, DEBUG_PREEMPT doesn't mess up that warning with its own.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 powerpc/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.24-git18/arch/powerpc/kernel/process.c	2008-01-24 22:58:37.000000000 +0000
+++ linux/arch/powerpc/kernel/process.c	2008-02-08 12:01:31.000000000 +0000
@@ -462,7 +462,7 @@ void show_regs(struct pt_regs * regs)
 	       current, task_pid_nr(current), current->comm, task_thread_info(current));
 
 #ifdef CONFIG_SMP
-	printk(" CPU: %d", smp_processor_id());
+	printk(" CPU: %d", raw_smp_processor_id());
 #endif /* CONFIG_SMP */
 
 	for (i = 0;  i < 32;  i++) {
