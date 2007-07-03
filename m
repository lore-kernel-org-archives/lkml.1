Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbXGCUTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbXGCUTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbXGCUTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:19:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33584 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499AbXGCUTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:19:11 -0400
Date: Tue, 3 Jul 2007 22:19:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andre Noll <maan@systemlinux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc7
Message-ID: <20070703201900.GA6257@elte.hu>
References: <alpine.LFD.0.98.0707011427380.1172@woody.linux-foundation.org> <20070703155519.GY22589@skl-net.de> <alpine.LFD.0.98.0707030908390.9434@woody.linux-foundation.org> <Pine.LNX.4.64.0707030921400.4810@schroedinger.engr.sgi.com> <20070703194523.GC493@elte.hu> <Pine.LNX.4.64.0707031251160.7491@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707031251160.7491@schroedinger.engr.sgi.com>
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

> On Tue, 3 Jul 2007, Ingo Molnar wrote:
> 
> > yeah. Your change looks good to me. You could add a 
> > local_irq_enable_in_hardirq() to the original place, that will map 
> > to a local_irq_enable() on non-lockdep kernels and will be a NOP on 
> > lockdep kernels. (This is a bit hacky though.)
> 
> Then kernels with lockdep would spew out lots of messages later in 
> boot because kmem_cache_init disabled interrupts for good.

no, it would/should result in exactly the same kernel image and lockdep 
behavior as with your current patch. (but when lockdep is disabled in 
the .config then interrupts are enabled earlier on.) Not a big issue, 
just noted this possibility.

	Ingo
