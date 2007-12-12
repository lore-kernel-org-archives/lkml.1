Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbXLLKWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbXLLKWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759273AbXLLKWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:22:40 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:57323 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758228AbXLLKWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:22:39 -0500
Date: Wed, 12 Dec 2007 11:22:47 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysctl : proc_dointvec_minmax() expects int values for
 min/max guard values
Message-Id: <20071212112247.9c30f0d0.dada1@cosmosbay.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

min_sched_granularity_ns, max_sched_granularity_ns, min_wakeup_granularity_ns 
and max_wakeup_granularity_ns are declared "unsigned long".

This is incorrect since proc_dointvec_minmax() expects plain "int" guard values.

This bug only triggers on big endian 64 bit arches.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8ac5171..707a26b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -225,10 +225,10 @@ static struct ctl_table root_table[] = {
 };
 
 #ifdef CONFIG_SCHED_DEBUG
-static unsigned long min_sched_granularity_ns = 100000;		/* 100 usecs */
-static unsigned long max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
-static unsigned long min_wakeup_granularity_ns;			/* 0 usecs */
-static unsigned long max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
+static int min_sched_granularity_ns = 100000;		/* 100 usecs */
+static int max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
+static int min_wakeup_granularity_ns;			/* 0 usecs */
+static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 #endif
 
 static struct ctl_table kern_table[] = {
