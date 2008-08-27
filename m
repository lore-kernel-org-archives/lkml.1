Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbYH0PWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbYH0PWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbYH0PWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:22:07 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:44939 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757147AbYH0PWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:22:06 -0400
Date: Wed, 27 Aug 2008 11:21:39 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] make might_sleep() display the oopsing process
Message-ID: <20080827152139.GA11460@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand might_sleep's printk to indicate the oopsing process.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.27-rc4-git4/kernel/sched.c
===================================================================
--- 2.6.27-rc4-git4.orig/kernel/sched.c	2008-08-26 17:44:34.000000000 -0400
+++ 2.6.27-rc4-git4/kernel/sched.c	2008-08-26 18:24:08.000000000 -0400
@@ -8183,8 +8183,8 @@
 		prev_jiffy = jiffies;
 		printk(KERN_ERR "BUG: sleeping function called from invalid"
 				" context at %s:%d\n", file, line);
-		printk("in_atomic():%d, irqs_disabled():%d\n",
-			in_atomic(), irqs_disabled());
+		printk("in_atomic():%d, irqs_disabled():%d, pid: %d, name: %s\n",
+			in_atomic(), irqs_disabled(), current->pid, current->comm);
 		debug_show_held_locks(current);
 		if (irqs_disabled())
 			print_irqtrace_events(current);
