Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYFEMtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYFEMtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbYFEMt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:49:26 -0400
Received: from vilipendio.investici.org ([216.17.130.5]:51110 "EHLO
	vilipendio.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbYFEMtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:49:25 -0400
X-Greylist: delayed 1836 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 08:49:25 EDT
To: rostedt@goodmis.org
Subject: about 2.6.25.4-rt5 (missing =?UTF-8?Q?global=5Frt=5Fruntime=29?=
MIME-Version: 1.0
Date: Thu, 05 Jun 2008 12:18:49 +0000
From: ciaby <ciaby@autistici.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <4dff8905a55309d233e35c924d5abb61@localhost>
User-Agent: A/I Webmail (roundcube 0.1rc2)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Small patch to make it compile (missing global_rt_runtime function):

diff -uNr linux-2.6.25.4.orig/kernel/sched.c linux-2.6.25.4/kernel/sched.c
--- linux-2.6.25.4.orig/kernel/sched.c  2008-06-05 14:12:30.000000000 +0200
+++ linux-2.6.25.4/kernel/sched.c       2008-06-05 13:58:48.000000000 +0200
@@ -671,6 +671,15 @@
  */
 #define RUNTIME_INF    ((u64)~0ULL)
 
+static u64 global_rt_runtime(void)
+{
+       if (sysctl_sched_rt_period < 0)
+               return RUNTIME_INF;
+       return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
+}
+
+
+
 /*
  * We really dont want to do anything complex within switch_to()
  * on PREEMPT_RT - this check enforces this.

Cheers

Ciaby


