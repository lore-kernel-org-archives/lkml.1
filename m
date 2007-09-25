Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbXIYGwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbXIYGwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 02:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbXIYGwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 02:52:45 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:47683 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751350AbXIYGwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 02:52:45 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git] CFS-devel, latest code
Date: Tue, 25 Sep 2007 09:50:56 +0300
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20070924214537.GA18980@elte.hu>
In-Reply-To: <20070924214537.GA18980@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709250950.59861.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

25 Eyl 2007 Sal tarihinde, Ingo Molnar şunları yazmıştı: 
> 
> The latest sched-devel.git tree can be pulled from:
>  
>   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> 
> Lots of scheduler updates in the past few days, done by many people. 
> Most importantly, the SMP latency problems reported and debugged by Mike 
> Galbraith should be fixed for good now.
> 
> I've also included the latest and greatest group-fairness scheduling 
> patch from Srivatsa Vaddagiri, which can now be used without containers 
> as well (in a simplified, each-uid-gets-its-fair-share mode). This 
> feature (CONFIG_FAIR_USER_SCHED) is now default-enabled.
> 
> Peter Zijlstra has been busy enhancing the math of the scheduler: we've 
> got the new 'vslice' forked-task code that should enable snappier shell 
> commands during load while still keeping kbuild workloads in check.
> 
> On my testsystems this codebase starts looking like something that could 
> be merged into v2.6.24, so please give it a good workout and let us know 
> if there's anything bad going on. (If this works out fine then i'll 
> propagate these changes back into the CFS backport, for wider testing.)

Seems like following trivial change needed to compile without CONFIG_SCHEDSTATS

caglar@zangetsu linux-2.6 $ LC_ALL=C make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      kernel/sched.o
In file included from kernel/sched.c:853:
kernel/sched_debug.c: In function `print_cfs_rq':
kernel/sched_debug.c:139: error: structure has no member named `bkl_cnt'
kernel/sched_debug.c:139: error: structure has no member named `bkl_cnt'
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index b68e593..4659c90 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -136,8 +136,10 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
+#ifdef CONFIG_SCHEDSTATS
 	SEQ_printf(m, "  .%-30s: %ld\n", "bkl_cnt",
 			rq->bkl_cnt);
+#endif
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
 }


Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
