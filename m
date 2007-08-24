Return-Path: <linux-kernel-owner+w=401wt.eu-S1765125AbXHXJOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765125AbXHXJOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 05:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbXHXJO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 05:14:28 -0400
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:52186 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbXHXJO1 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 05:14:27 -0400
Subject: [PATCH RT] - rebalance_domains incorrect parameter
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: RT Users List <linux-rt-users@vger.kernel.org>,
       LKML <Linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: The Big Corporation
Date: Fri, 24 Aug 2007 02:09:22 -0700
Message-Id: <1187946562.16573.47.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

the RT patches for .22 and .23 are passing an incorrect parameter to
rebalance_domains.

I had this queued up for a few days - its still wrong in .22 and .23 RT
patches.

Same issue has been fixed in mainline by: 

diff-tree de0cf899bbf06b6f64a5dce9c59d74c41b6b4232 (from
5d2b3d3695a841231b65b55
Author: Oleg Nesterov <oleg@tv-sign.ru>
Date:   Sun Aug 12 18:08:19 2007 +0200

    sched: run_rebalance_domains: s/SCHED_IDLE/CPU_IDLE/
    
    rebalance_domains(SCHED_IDLE) looks strange (typo), change it to
CPU_IDLE.
    
    the effect of this bug was slightly more agressive idle-balancing on
    SMP than intended.
    
    Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


Thanks,

Sven



This parameter was missed when SCHED_IDLE was replaced by CPU_IDLE.

Fixed in mainline by:
commit de0cf899bbf06b6f64a5dce9c59d74c41b6b4232
Author: Oleg Nesterov <oleg@tv-sign.ru>
Date:   Sun Aug 12 18:08:19 2007 +0200


signed-off-by: Sven-Thorsten Dietrich <sven@thebigcorporation.com>


Index: linux-2.6.22.1-rt9-broken-out/kernel/sched.c
===================================================================
--- linux-2.6.22.1-rt9-broken-out.orig/kernel/sched.c
+++ linux-2.6.22.1-rt9-broken-out/kernel/sched.c
@@ -3479,7 +3479,7 @@ static void run_rebalance_domains(struct
 			if (need_resched())
 				break;
 
-			rebalance_domains(balance_cpu, SCHED_IDLE);
+			rebalance_domains(balance_cpu, CPU_IDLE);
 
 			rq = cpu_rq(balance_cpu);
 			if (time_after(this_rq->next_balance, rq->next_balance))

