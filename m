Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbYHKMhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbYHKMhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 08:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYHKMhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 08:37:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58536 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYHKMhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 08:37:42 -0400
Date: Mon, 11 Aug 2008 14:36:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
Message-ID: <20080811123647.GA24311@elte.hu>
References: <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org> <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808121428.646a8b3c.akpm@linux-foundation.org> <1218223269.29098.12.camel@lappy.programming.kicks-ass.net> <1218224829.29098.19.camel@lappy.programming.kicks-ass.net> <20080811104526.GA15186@elte.hu> <1218452640.10800.58.camel@twins> <20080811115109.GB23529@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080811115109.GB23529@elte.hu>
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

> > I personally prefer this printk_tick() driven one over the RCU 
> > driven one because it doesn't trade deadlocks.
> 
> i've started testing it in tip/core/printk to give it some track 
> record - thanks Peter.

small build fixlet below.

	Ingo

-------------->
>From 99fc8ce41d639ce46f32c4e8618e8a571858e5aa Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 11 Aug 2008 14:38:12 +0200
Subject: [PATCH] printk: robustify printk, fix
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix:

 include/linux/kernel.h: In function ‘printk_needs_cpu':
 include/linux/kernel.h:217: error: parameter name omitted

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kernel.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c9ed24c..a012579 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -201,7 +201,7 @@ extern int printk_ratelimit(void);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 extern void printk_tick(void);
-extern int printk_needs_cpu(int);
+extern int printk_needs_cpu(int cpu);
 #else
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
@@ -214,7 +214,7 @@ static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
 		{ return false; }
 static inline void printk_tick(void) { }
-static inline int printk_needs_cpu(int) { return 0; }
+static inline int printk_needs_cpu(int cpu) { return 0; }
 #endif
 
 extern void asmlinkage __attribute__((format(printf, 1, 2)))
