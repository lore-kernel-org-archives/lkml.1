Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYLHPTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYLHPTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYLHPTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:19:31 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:46098 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbYLHPT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:19:29 -0500
Date: Mon, 8 Dec 2008 20:52:49 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [BUG] idle_balance() does not call load_balance_newidle()
Message-ID: <20081208152249.GI5457@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

load_balance_newidle() does not get called if SD_BALANCE_NEWIDLE is
set at higher level domain (3-CPU) and not in low level domain (2-MC).

pulled_task is initialised to -1 and checked for non-zero which is
always true if the lowest level sched_domain does not have
SD_BALANCE_NEWIDLE flag set.

Trivial fix to initialise pulled_task to zero.
Patch against 2.6.28-rc7

Thanks,
Vaidy

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/kernel/sched.c b/kernel/sched.c
index f79c7c4..4abdce1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3801,7 +3801,7 @@ out_balanced:
 static void idle_balance(int this_cpu, struct rq *this_rq)
 {
 	struct sched_domain *sd;
-	int pulled_task = -1;
+	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 	cpumask_t tmpmask;
 
