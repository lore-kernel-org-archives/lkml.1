Return-Path: <linux-kernel-owner+w=401wt.eu-S1762007AbZEGL0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007AbZEGL0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZEGL0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:26:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbZEGL03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:26:29 -0400
Date: Thu, 7 May 2009 13:26:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, mingo@redhat.com, dwmw2@infradead.org
Subject: Re: IOMMU and graphics cards
Message-ID: <20090507112601.GJ28398@elte.hu>
References: <20090507100114.GF4059@amd.com> <20090507191724N.fujita.tomonori@lab.ntt.co.jp> <20090507110135.GC28398@elte.hu> <20090507201538U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507201538U.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Thu, 7 May 2009 13:01:35 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > > The proprietary drivers make problems so far. For the ATI one I 
> > > > am in contact with the developers to try to fix it. But I can't 
> > > > do anything about the other proprietary driver I am aware of :-(
> > > 
> > > I don't know anything about the graphic drivers but are there any 
> > > other proprietary drivers except for ATI and AMD? Fixing only two 
> > > drivers to make the majority happy?
> > 
> > ATI ~== AMD these days. The problem is Nvidia cards stuck into AMD 
> > systems.
> 
> Oops, I meant ATI and Nvidia.
> 
> 
> > I guess refusing those DMA accesses (and printing something 
> > meaningful and relentlessly honest so that the user knows where the 
> > problem comes from) is the proper solution.
> 
> Refusing DMA means that we will break these broken drivers. That's 
> what David and I like. Yeah, telling users explicitly who is to 
> blame for the problem is even better.

If it means a non-working Xorg, then there might be nothing on the 
screen to report - just a seemingly hung box and people will blame 
the kernel. It might be better to just turn off all things IOMMU at 
that point, but still allow things to continue.

... which might break good drivers that relied on the IOMMU sorting 
out 32-bit DMA space limitations.

So it would be nice to make the failure mode somehow nicer. I.e. 
test how this affects the nvidia driver. Is there something on the 
screen to see? Could we print an URL to the Noveau driver perhaps 
too?

A bad solution in general is to crash/hang a significant proportion 
of Linux boxes. That is a foot-in-own-mouth masochistic excercise 
mostly, it creates a stigma for the IOMMU code, not for nvidia. So 
the failure mode has to be well thought out.

	Ingo
