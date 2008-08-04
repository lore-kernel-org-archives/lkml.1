Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbYHDGym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbYHDGym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758909AbYHDGya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:54:30 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:36176 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761650AbYHDGy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:54:29 -0400
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20080804055339.GB5444@linux.vnet.ibm.com>
References: <1217474425.25608.150.camel@ymzhang>
	 <1217489463.25608.157.camel@ymzhang> <1217489949.8157.78.camel@twins>
	 <1217490560.25608.168.camel@ymzhang> <1217551154.25608.169.camel@ymzhang>
	 <20080801051407.GA5232@linux.vnet.ibm.com>
	 <1217826278.25608.198.camel@ymzhang>
	 <20080804052228.GA5444@linux.vnet.ibm.com>
	 <1217828278.25608.206.camel@ymzhang>
	 <20080804055339.GB5444@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 08:54:26 +0200
Message-Id: <1217832866.9016.45.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 11:23 +0530, Dhaval Giani wrote:

> Peter, vatsa, any ideas?

---
Subject: sched: scale sysctl_sched_shares_ratelimit with nr_cpus

David reported that his Niagra spend a little too much time in
tg_shares_up(), which considering he has a large cpu count makes sense.

So scale the ratelimit value with the number of cpus like we do for
other controls as well.

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 9a76e92..7eddaea 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -809,9 +809,9 @@ const_debug unsigned int sysctl_sched_nr_migrate = 32;
 
 /*
  * ratelimit for updating the group shares.
- * default: 0.5ms
+ * default: 0.25ms
  */
-const_debug unsigned int sysctl_sched_shares_ratelimit = 500000;
+const_debug unsigned int sysctl_sched_shares_ratelimit = 250000;
 
 /*
  * period over which we measure -rt task cpu usage in us.
@@ -5732,6 +5732,8 @@ static inline void sched_init_granularity(void)
 		sysctl_sched_latency = limit;
 
 	sysctl_sched_wakeup_granularity *= factor;
+
+	sysctl_sched_shares_ratelimit *= factor;
 }
 
 #ifdef CONFIG_SMP


