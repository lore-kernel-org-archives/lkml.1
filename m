Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZAGN1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZAGN1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbZAGN1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:27:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58330 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757982AbZAGN1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:27:12 -0500
Date: Wed, 7 Jan 2009 14:26:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [3/5] Mark complex bitops.h inlines as __always_inline
Message-ID: <20090107132653.GA22229@elte.hu>
References: <200901051236.281008835@firstfloor.org> <20090104233640.6A7453E6653@basil.firstfloor.org> <20090106101710.GA22134@elte.hu> <20090106143215.GD496@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106143215.GD496@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > Your patch is wrong because it prevents a good compiler from doing the 
> > right inlining decisions.
> 
> One or two instruction bitops should be always inlined, not inlining 
> them always generates much worse code than inlining them. That's easy to 
> prove just based on code size: the call overhead is larger than the 
> inlined code.

You are arguing this backwards. Firstly, CONFIG_OPTIMIZE_INLINING is 
disabled by default. If you enable it, and if CONFIG_OPTIMIZE_INLINING=y 
creates a larger kernel for you, then either do not enable it - or send 
numbers so that we can see the true impact of this change.

Yes, simple functions should always be inlined, nobody will argue about 
that. But GCC's inliner will never be fixed (for the kernel domain at 
least) if we keep working it around and if we keep micro-managing it.

We work around GCC bugs only if it hurts visibly (and generally if it 
affects default-enabled features/optimizations): if it can be quantified 
either via stability/robustness problems or there's excesssive size / 
efficiency problems.

You simply have not made that argument via any numbers here. So i have no 
reason to take your patch just yet, unless you provide some clear, 
documented, measurable benefit.

	Ingo
