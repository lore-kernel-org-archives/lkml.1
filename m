Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbZLKLCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbZLKLCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbZLKLC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:02:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51060 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbZLKLC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:02:28 -0500
Date: Fri, 11 Dec 2009 12:02:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Will Deacon <will.deacon@arm.com>
Cc: "'Jamie Iles'" <jamie.iles@picochip.com>, linux-kernel@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] perf tools: allow building for ARM
Message-ID: <20091211110225.GA20831@elte.hu>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com>
 <20091211102316.GB16882@elte.hu>
 <20091211103030.GC4164@wear.picochip.com>
 <000101ca7a50$b3e2ad70$1ba80850$@deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000101ca7a50$b3e2ad70$1ba80850$@deacon@arm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Will Deacon <will.deacon@arm.com> wrote:

> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org]
> > On Behalf Of Jamie Iles
> > Sent: 11 December 2009 10:31
> >
> > The implementation of the barriers depend on the CPU arch revision 
> > which is defined in the kernel config. As the perf tools don't use 
> > the kernel config, we don't know here what arch revision we're 
> > building for. Perhaps we need a LINUX_ARM_ARCH parameter when 
> > building for ARM so we can pick the correct one.
> 
> Hi Jamie, Ingo,
> 
> Surely a better way to proceed with this would be to build the perf 
> tool as a side effect of building the kernel? That way the relevant 
> definitions from system.h could be included directly and there would 
> be no need to duplicate the architectural conditionals in perf.h.

Might make sense.

> I'm also working on perf-events for ARM and am using:
> 
> #define rmb()           asm volatile("mcr p15, 0, %0, c7, c10, 5" :: "r" (0) : "memory")
> 
> This will work on v6 and v7 [although the dmb instruction is preferred 
> here] cores.

Note that the codepath where it's used isnt very performance sensitive 
(we call it about once per batch of event processing), so we could use 
the broadest instruction that works on as many cores as possible - to 
keep things simple.

	Ingo
