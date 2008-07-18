Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbYGRMEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbYGRMEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbYGRMEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:04:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35427 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbYGRMD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:03:59 -0400
Date: Fri, 18 Jul 2008 14:03:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
       vegard.nossum@gmail.com
Subject: Re: [PATCH] cpu hotplug: Make cpu_active_map synchronization
	dependency clear
Message-ID: <20080718120312.GA9926@elte.hu>
References: <1216180586-8313-1-git-send-email-maxk@qualcomm.com> <20080718112635.GA6875@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080718112635.GA6875@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Max Krasnyansky <maxk@qualcomm.com> wrote:
> 
> > This goes on top of the cpu_active_map (take 2) patch.
> 
> i've applied it to sched/devel. [...]

build fix below for UP.

	Ingo

---------------------------------------------->
commit 1b427c153a08fdbc092c2bdbf845b92fda58d857
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jul 18 14:01:39 2008 +0200

    sched: fix build error, provide partition_sched_domains() unconditionally
    
    provide an empty partition_sched_domains() definition for the UP case:
    
     include/linux/cpuset.h: In function ‘rebuild_sched_domains':
     include/linux/cpuset.h:163: error: implicit declaration of function ‘partition_sched_domains'
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1941d8b..26da921 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -824,7 +824,16 @@ extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 				    struct sched_domain_attr *dattr_new);
 extern int arch_reinit_sched_domains(void);
 
-#endif	/* CONFIG_SMP */
+#else /* CONFIG_SMP */
+
+struct sched_domain_attr;
+
+static inline void
+partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+			struct sched_domain_attr *dattr_new)
+{
+}
+#endif	/* !CONFIG_SMP */
 
 struct io_context;			/* See blkdev.h */
 #define NGROUPS_SMALL		32
