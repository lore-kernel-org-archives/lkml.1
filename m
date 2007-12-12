Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbXLLRfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbXLLRfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:35:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbXLLRey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:34:54 -0500
Received: from homer.mvista.com ([63.81.120.158]:25985 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750751AbXLLRex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:34:53 -0500
Message-Id: <20071212172256.360140744@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Dec 2007 09:22:56 -0800
Message-Id: <20071212172227.554694168@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Dec 2007 09:22:27 -0800
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: [PATCH -rt] Add wakeup timing to expose /proc/preempt_max_latency
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix my original mistake of using CONFIG_CRITICAL_TIMING , which only
covers preempt and irqs-off timing.. Convert to CONFIG_LATENCY_TIMING,
so wakeup timing also has these.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/kernel/sysctl.c
===================================================================
--- linux-2.6.23.orig/kernel/sysctl.c
+++ linux-2.6.23/kernel/sysctl.c
@@ -414,7 +414,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-#if defined(CONFIG_CRITICAL_TIMING)
+#if defined(CONFIG_LATENCY_TIMING)
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "preempt_max_latency",
-- 

-- 
