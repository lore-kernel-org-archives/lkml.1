Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbXGCTpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbXGCTpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbXGCTpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:45:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58784 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012AbXGCTpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:45:33 -0400
Date: Tue, 3 Jul 2007 21:45:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andre Noll <maan@systemlinux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc7
Message-ID: <20070703194523.GC493@elte.hu>
References: <alpine.LFD.0.98.0707011427380.1172@woody.linux-foundation.org> <20070703155519.GY22589@skl-net.de> <alpine.LFD.0.98.0707030908390.9434@woody.linux-foundation.org> <Pine.LNX.4.64.0707030921400.4810@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707030921400.4810@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> > However, it might be worth avoiding the warning, even if it seems 
> > bogus in this case. Christoph? Do you agree with the analysis? And 
> > the patch might be as simple as changing 
> > early_kmem_cache_node_alloc() to enable interrupts at the _end_ of 
> > the function, rather than immediately after calling new_slab().
> 
> new_slab() enables and disables interrupts during usual operations. 
> During bootstrap interrupts are enabled and so new_slab() falsely 
> disables interrupts when we do the alloc by hand thing in 
> early_kmem_cache_node_alloc for NUMA. We need to enable interrupts 
> there since otherwise boot will continue with interrupts disabled.

yeah. Your change looks good to me. You could add a 
local_irq_enable_in_hardirq() to the original place, that will map to a 
local_irq_enable() on non-lockdep kernels and will be a NOP on lockdep 
kernels. (This is a bit hacky though.)

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
