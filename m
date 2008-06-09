Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbYFIJvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbYFIJvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 05:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbYFIJvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 05:51:35 -0400
Received: from vilipendio.investici.org ([216.17.130.5]:33179 "EHLO
	vilipendio.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726AbYFIJvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 05:51:35 -0400
To: rostedt@goodmis.org
Subject: [PATCH] 2.6.25.4-rt6: missing =?UTF-8?Q?global=5Frt=5Fruntime=28=29=20in?=
 =?UTF-8?Q?=20sched=2Ec?=
MIME-Version: 1.0
Date: Mon, 09 Jun 2008 09:51:34 +0000
From: ciaby <ciaby@autistici.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Message-ID: <7688fdc041a8f848b0627dccccddcf12@localhost>
User-Agent: A/I Webmail (roundcube 0.1rc2)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I already sent this patch, but seems that nobody cared... the last 2
revisions of the -rt kernel don't compile properly.
Second patch to fix this.
Regards

Giovanni "ciaby" Civardi

diff -uNr linux-2.6.25.4-rt6.orig/kernel/sched.c
linux-2.6.25.4-rt6/kernel/sched.c
--- linux-2.6.25.4-rt6.orig/kernel/sched.c      2008-06-09
11:35:57.000000000 +0200
+++ linux-2.6.25.4-rt6/kernel/sched.c   2008-06-09 11:40:45.000000000 +0200
@@ -672,6 +672,13 @@
  */
 #define RUNTIME_INF    ((u64)~0ULL)
 
+static u64 global_rt_runtime(void)
+{
+       if (sysctl_sched_rt_period < 0)
+               return RUNTIME_INF;
+       return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
+}              
+
 /*
  * We really dont want to do anything complex within switch_to()
  * on PREEMPT_RT - this check enforces this.


