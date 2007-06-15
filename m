Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbXFOTff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbXFOTff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbXFOTfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:35:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40575 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbXFOTfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:35:20 -0400
Date: Fri, 15 Jun 2007 21:35:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ludovic Vaugeois-Pepin <ludovicvp@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v17
Message-ID: <20070615193515.GB24881@elte.hu>
References: <20070614224908.GA9412@elte.hu> <20070615132841.5ee01f4d@localhost> <a014cde70706150952o716220e5uaafe111f5ca400fc@mail.gmail.com> <a014cde70706150958o1e684e0bme582536505b1fe48@mail.gmail.com> <a014cde70706151023l51fb03b2md01f703ad44112bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a014cde70706151023l51fb03b2md01f703ad44112bf@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ludovic Vaugeois-Pepin <ludovicvp@gmail.com> wrote:

> >kernel/built-in.o:sched.c:(.text+0x407b): more undefined references to
> >`cpu_of' follow
> >make: *** [.tmp_vmlinux1] Error 1
> >
> >I attached the .config file (config-2.6.22-rc4-cfs17)
> >
> >--
> >Ludovic Vaugeois-Pepin
> >
> >
> 
> Here is the config :

thx - this too has !CONFIG_SMP - please apply the fix below or 
re-download the v17 patch.

	Ingo

Index: linux-cfs-2.6.22-rc4.q/kernel/sched.c
===================================================================
--- linux-cfs-2.6.22-rc4.q.orig/kernel/sched.c
+++ linux-cfs-2.6.22-rc4.q/kernel/sched.c
@@ -248,6 +249,15 @@ static unsigned int static_prio_timeslic
 		return SCALE_PRIO(DEF_TIMESLICE, static_prio);
 }
 
+static inline int cpu_of(struct rq *rq)
+{
+#ifdef CONFIG_SMP
+	return rq->cpu;
+#else
+	return 0;
+#endif
+}
+
 #ifdef CONFIG_SMP
 /*
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
@@ -258,15 +268,6 @@ static inline u32 sg_div_cpu_power(const
 	return reciprocal_divide(load, sg->reciprocal_cpu_power);
 }
 
-static inline int cpu_of(struct rq *rq)
-{
-#ifdef CONFIG_SMP
-	return rq->cpu;
-#else
-	return 0;
-#endif
-}
-
 /*
  * Each time a sched group cpu_power is changed,
  * we must compute its reciprocal value
