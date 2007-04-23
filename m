Return-Path: <linux-kernel-owner+w=401wt.eu-S965692AbXDWKFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692AbXDWKFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161223AbXDWKFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:05:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965692AbXDWKFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:05:42 -0400
Date: Mon, 23 Apr 2007 12:03:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zach Carter <linux@zachcarter.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5 (build problem - make headers_check fails)
Message-ID: <20070423100356.GA17231@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <462C25C9.9040107@zachcarter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462C25C9.9040107@zachcarter.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zach Carter <linux@zachcarter.com> wrote:

> FYI, make headers_check seems to fail on this:
> 
> [carter@hoth linux-2.6]$ make headers_check

> make[2]: *** No rule to make target 
> `/src/linux-2.6/usr/include/linux/.check.sched.h', needed by 
> `__headerscheck'.  Stop.
> make[1]: *** [linux] Error 2
> make: *** [headers_check] Error 2
> [carter@hoth linux-2.6]$
> 
> This also fails if I have CONFIG_HEADERS_CHECK=y in my .config

ah, indeed - the patch below should fix this. It will be in -v6.

	Ingo

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -2,7 +2,6 @@
 #define _LINUX_SCHED_H
 
 #include <linux/auxvec.h>	/* For AT_VECTOR_SIZE */
-#include <linux/rbtree.h>	/* For run_node */
 /*
  * cloning flags:
  */
@@ -37,6 +36,8 @@
 
 #ifdef __KERNEL__
 
+#include <linux/rbtree.h>	/* For run_node */
+
 struct sched_param {
 	int sched_priority;
 };
