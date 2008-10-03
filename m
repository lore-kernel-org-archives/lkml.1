Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYJCIrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYJCIrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbYJCIqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:46:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45302 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbYJCIqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:46:52 -0400
Date: Fri, 3 Oct 2008 10:42:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       akpm@linux-foundation.org, laijs@cn.fujitsu.com,
       manfred@colorfullife.com, dipankar@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, josht@linux.vnet.ibm.com,
       ltt-dev@lists.casi.polymtl.ca
Subject: [PATCH] rcu: RCU-based detection of stalled CPUs for Classic RCU,
	fix
Message-ID: <20081003084233.GA15637@elte.hu>
References: <20081002003628.GA7877@linux.vnet.ibm.com> <20081002080726.GB17695@elte.hu> <20081002140507.GB6729@linux.vnet.ibm.com> <20081002151046.GB2473@Krystal> <20081002174318.GB7324@linux.vnet.ibm.com> <20081002185115.GA11047@Krystal> <20081002225537.GA6706@linux.vnet.ibm.com> <20081002230639.GA7522@linux.vnet.ibm.com> <20081003083947.GB7636@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003083947.GB7636@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-tip testing found a minor build bug - find the fix below.

	Ingo

-------------------->
>From 2ec2b482b10a1ed3493c224f1893cddd3d33833b Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 3 Oct 2008 10:41:00 +0200
Subject: [PATCH] rcu: RCU-based detection of stalled CPUs for Classic RCU, fix

fix the !CONFIG_RCU_CPU_STALL_DETECTOR path:

 kernel/rcuclassic.c: In function '__rcu_pending':
 kernel/rcuclassic.c:609: error: too few arguments to function 'check_cpu_stall'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcuclassic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 0d07e6e..37f72e5 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -239,7 +239,7 @@ static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
 {
 }
 
-static void check_cpu_stall(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
+static inline void check_cpu_stall(struct rcu_ctrlblk *rcp)
 {
 }
 
