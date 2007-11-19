Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbXKSS7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbXKSS7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbXKSS71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:59:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44515 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbXKSS70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:59:26 -0500
Date: Mon, 19 Nov 2007 19:59:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,
	v2.6.23.8,v2.6.22.13, v2.6.21.7
Message-ID: <20071119185920.GB12117@elte.hu>
References: <20071119151756.GA25446@elte.hu> <F1D642E5A91BC94D9504EC83AE19E6B0B897BE@ecqcmtlmail3.quebec.int.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0B897BE@ecqcmtlmail3.quebec.int.ec.gc.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Fortier,Vincent [Montreal] <Vincent.Fortier1@EC.GC.CA> wrote:

> Hi Ingo,
> 
> Thnx a lot for theses backports...
> 
> Ran into this while compiling a 2.6.22.13 with CFS v24
> 
>   CC      kernel/sched.o
> kernel/sched.c: In function 'cpu_to_core_group':
> kernel/sched.c:6056: error: 'per_cpu__cpu_sibling_map' undeclared (first

find below the current set of fixlets - it should fix the 
cpu_sibling_map build error too. (or re-download the v24 patch again to 
get the fixes)

	Ingo

--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -309,6 +309,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 644,
 		.proc_handler	= &proc_dointvec,
 	},
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_min_bal_int_shares",
@@ -326,6 +327,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_compat_yield",
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -10,7 +10,7 @@
 #define COMPAT_REGISTER_SYSCTL
 
 /* backporting helper macro: */
-#define cpu_sibling_map(cpu) per_cpu(cpu_sibling_map, cpu)
+#define cpu_sibling_map(cpu) cpu_sibling_map[cpu]
 
 /*
  * cloning flags:
