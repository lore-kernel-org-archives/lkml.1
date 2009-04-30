Return-Path: <linux-kernel-owner+w=401wt.eu-S1763665AbZD3PD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763665AbZD3PD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762803AbZD3PDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:03:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762696AbZD3PDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:03:42 -0400
Date: Thu, 30 Apr 2009 17:01:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430150142.GC20580@elte.hu>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <alpine.DEB.1.10.0904300921290.22262@qirst.com> <20090430133859.GB8329@elte.hu> <alpine.DEB.1.10.0904300938220.22262@qirst.com> <20090430141446.GD14696@elte.hu> <alpine.DEB.1.10.0904301013110.14178@qirst.com> <20090430143819.GF14696@elte.hu> <alpine.DEB.1.10.0904301042170.4028@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904301042170.4028@qirst.com>
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


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 30 Apr 2009, Ingo Molnar wrote:
> 
> > > Yes but sometimes you are already irq safe and such a fallback
> > > would create significant irq/enable/disable stack operations etc
> > > overhead for architectures that are using the fallback.
> >
> > It's a fallback slowpath - non-x86 architectures should still fill
> > in a real implementation of course.
> 
> Arch code cannot provide an effective implementation since they
> always have to assume that interupts need to be disabled if we stay with
> the current implementation.
> 
> > So we first have to see the list of architectures that _cannot_
> > implement an irq-safe op here via a single machine instruction.
> > x86, ia64 and powerpc should be fine.
> 
> Look at Ia64, sparc, s/390, powerpc. They can fall back to atomic 
> ops but those are very ineffective on some of these platforms. 
> Since these are performance critical they will need to be 
> optimized depending on the context of their use in the core.

Could you cite a specific example / situation where you'd use __xxx 
ops?

	Ingo
