Return-Path: <linux-kernel-owner+w=401wt.eu-S1761633AbZANLEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633AbZANLEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZANLEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:04:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56896 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbZANLEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:04:10 -0500
Date: Wed, 14 Jan 2009 12:03:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gregory Haskins <ghaskins@novell.com>, rostedt@home.goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: fix build error in kernel/sched_rt.c when
	RT_GROUP_SCHED && !SMP
Message-ID: <20090114110356.GK2913@elte.hu>
References: <20090113014333.GA23448@elte.hu> <20090113023345.32433.28954.stgit@dev.haskins.net> <20090114080111.GC18649@elte.hu> <1231930476.7141.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231930476.7141.27.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-01-14 at 09:01 +0100, Ingo Molnar wrote:
> > * Gregory Haskins <ghaskins@novell.com> wrote:
> > 
> > > +#define dec_rt_group(rt_se, rt_rq) do { } while (0)
> > 
> > Please dont _ever_ introduce new CPP macros into core kernel code, and if 
> > you see existing once, please fix them to be proper C inline functions. 
> > (there's a few other new macros in your patchset)
> 
> Generally good advice, and certainly doable in this case. But in some 
> very rare occasions I've had to use CPP in order to avoid silly header 
> dependency hell -- I think we should add comments in such cases as to 
> why we use CPP.

yeah - that's why i qualified it with 'core kernel code', not 'headers'. 

(But even in the dependency spaghetti case the right solution is to clean 
up the header dependencies. It's just very hard in most cases due to most 
folks running on x86 and there being 20+ other architectures they cannot 
really test. So the dependency hell tends to grow not shrink. )

	Ingo
