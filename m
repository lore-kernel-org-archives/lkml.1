Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753402AbYLQRZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYLQRZN (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYLQRYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:24:38 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:57038 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbYLQRYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:24:36 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [PATCH v6 7/7] sched: idle_balance() does not call
	load_balance_newidle()
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
        Tim Connors <tconnors@astro.swin.edu.au>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Pavel Machek <pavel@suse.cz>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 17 Dec 2008 22:57:45 +0530
Message-ID: <20081217172745.534.46999.stgit@drishya.in.ibm.com>
In-Reply-To: <20081217172309.534.28847.stgit@drishya.in.ibm.com>
References: <20081217172309.534.28847.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_balance_newidle() does not get called if SD_BALANCE_NEWIDLE
is set at higher level domain (3-CPU) and not in low level domain
(2-MC).

pulled_task is initialised to -1 and checked for non-zero which
is always true if the lowest level sched_domain does not have
SD_BALANCE_NEWIDLE flag set.

Trivial fix to initialise pulled_task to zero.

This patch has been queued for 2.6.29
http://lkml.org/lkml/2008/12/8/213

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f82a7a0..e6a88bf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3773,7 +3773,7 @@ out_balanced:
 static void idle_balance(int this_cpu, struct rq *this_rq)
 {
 	struct sched_domain *sd;
-	int pulled_task = -1;
+	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 	cpumask_t tmpmask;
 

