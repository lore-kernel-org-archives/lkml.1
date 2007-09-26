Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbXIZNsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbXIZNsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbXIZNsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:48:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58248 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXIZNsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:48:14 -0400
Date: Wed, 26 Sep 2007 15:48:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8,
	v2.6.22.8, v2.6.21.7, v2.6.20.20
Message-ID: <20070926134800.GA6220@elte.hu>
References: <20070926111357.GA10655@elte.hu> <200709261633.24283.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200709261633.24283.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> Compilation [against 2.6.20.20] fails with
> 
> buildfarm linux-2.6.20 # make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CHK     include/linux/compile.h
>   CC      kernel/sched.o
> In file included from kernel/sched.c:850:
> kernel/sched_fair.c:49: error: sysctl_sched_nr_latency causes a section type 
> conflict
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2

oops, indeed! This happens with certain .config combinations only and it 
didnt trigger on mine.

> @kernel/sched_fair.c
> -const_debug unsigned int sysctl_sched_nr_latency __read_mostly = 20;
> +const_debug unsigned int sysctl_sched_nr_latency = 20;
> 
> seems solve that issue but i'm not sure this is the right thing to do 
> or not :)

your fix is the right one - and i've updated the patches with this small 
fix. Anyone who hits this issue should re-download the same patch once 
more, or should apply the small patch below.

	Ingo

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -46,7 +46,7 @@ const_debug unsigned int sysctl_sched_ch
  * Minimal preemption granularity for CPU-bound tasks:
  * (default: 2 msec, units: nanoseconds)
  */
-const_debug unsigned int sysctl_sched_nr_latency __read_mostly = 20;
+const_debug unsigned int sysctl_sched_nr_latency = 20;
 
 /*
  * sys_sched_yield() compat mode
