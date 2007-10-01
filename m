Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbXJAKh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbXJAKh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXJAKhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:37:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45442 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbXJAKhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:37:15 -0400
Date: Mon, 1 Oct 2007 12:37:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch and kernel/sched.c
Message-ID: <20071001103705.GA15488@elte.hu>
References: <20070928105345.GC18163@shadowen.org> <20071001064448.GA4239@elte.hu> <20071001003007.4e90143b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001003007.4e90143b.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> > > #411: FILE: home/apw/git/linux-2.6/kernel/sched.c:408:
> > > +EXPORT_SYMBOL_GPL(cpu_clock);
> > 
> > yes, this is a legit warning and i fix it every time i see it. (I 
> > cannot fix this one now because mainline does not have an 
> > EXPORT_SYMBOL_GPL for cpu_clock(), it's added in -mm? But i cannot 
> > find it in mm either. I'll fix it once i find the patch :)
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/broken-out/make-rcutorture-rng-use-temporal-entropy.patch

ok - i have picked up the sched.c bit for sched-devel.git. (see below)

	Ingo

---------------->
Subject: sched: export cpu_clock()
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

export cpu_clock() - the preferred API instead of sched_clock().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -469,6 +469,7 @@ unsigned long long cpu_clock(int cpu)
 
 	return now;
 }
+EXPORT_SYMBOL_GPL(cpu_clock);
 
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
