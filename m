Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbXKSS6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbXKSS6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXKSS6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:58:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44214 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbXKSS6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:58:11 -0500
Date: Mon, 19 Nov 2007 19:57:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David <david@livux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,
	v2.6.23.8,v2.6.22.13, v2.6.21.7
Message-ID: <20071119185759.GA12117@elte.hu>
References: <200711191925.12072.david@livux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711191925.12072.david@livux.com>
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


* David <david@livux.com> wrote:

> Hi Ingo,
> 
> Thnx a lot for theses backports...
> 
> Ran into this while compiling a 2.6.23.8 with CFS v24
> 
> Compiling with CONFIG_FAIR_GROUP_SCHED disabled :
> 
> kernel/sysctl.c:305: error: 'sysctl_sched_min_bal_int_shares' undeclared here (not in a function)
> kernel/sysctl.c:313: error: 'sysctl_sched_max_bal_int_shares' undeclared here (not in a function)
> 
> I made that patch to make it compile.

thanks - i've applied your fix and have re-uploaded under the same 
filenames - so if anyone hits this problem it can be fixed by 
re-downloading the same patch again. Find below the current set of -v24 
build fixlets.

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
