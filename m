Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbXLGLSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbXLGLSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 06:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbXLGLSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 06:18:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58662 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbXLGLSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 06:18:00 -0500
Date: Fri, 7 Dec 2007 12:17:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071207111720.GA10543@elte.hu>
References: <20071207021952.6f0ac922@morte> <20071207084559.GA11162@elte.hu> <200712072213.06530.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712072213.06530.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > ah, printk_clock() still uses sched_clock(), not jiffies. So it's 
> > not the jiffies counter that goes back and forth, it's sched_clock() 
> > - so this is a printk timestamps anomaly, not related to jiffies. I 
> > thought we have fixed this bug in the printk code already: 
> > sched_clock() is a 'raw' interface that should not be used directly 
> > - the proper interface is cpu_clock(cpu).
> 
> It's a single CPU box, so sched_clock() jumping would still be 
> problematic, no?

sched_clock() is an internal API - the non-jumping API to be used by 
printk is cpu_clock().

	Ingo
