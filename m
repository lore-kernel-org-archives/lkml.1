Return-Path: <linux-kernel-owner+w=401wt.eu-S1161373AbXDQWVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161373AbXDQWVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161380AbXDQWVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:21:47 -0400
Received: from waste.org ([66.93.16.53]:54098 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161373AbXDQWVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:21:46 -0400
Date: Tue, 17 Apr 2007 17:08:09 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Davide Libenzi <davidel@xmailserver.org>, Nick Piggin <npiggin@suse.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417220809.GF11166@waste.org>
References: <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com> <20070417070949.GR8915@holomorphy.com> <20070417073308.GB30559@elte.hu> <20070417090538.GU8915@holomorphy.com> <20070417092422.GA19414@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417092422.GA19414@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 11:24:22AM +0200, Ingo Molnar wrote:
> 
> * William Lee Irwin III <wli@holomorphy.com> wrote:
> 
> > [...] Also rest assured that the tone of the critique is not hostile, 
> > and wasn't meant to sound that way.
> 
> ok :) (And i guess i was too touchy - sorry about coming out swinging.)
> 
> > Also, given the general comments it appears clear that some 
> > statistical metric of deviation from the intended behavior furthermore 
> > qualified by timescale is necessary, so this appears to be headed 
> > toward a sort of performance metric as opposed to a pass/fail test 
> > anyway. However, to even measure this at all, some statement of 
> > intention is required. I'd prefer that there be a Linux-standard 
> > semantics for nice so results are more directly comparable and so that 
> > users also get similar nice behavior from the scheduler as it varies 
> > over time and possibly implementations if users should care to switch 
> > them out with some scheduler patch or other.
> 
> yeah. If you could come up with a sane definition that also translates 
> into low overhead on the algorithm side that would be great!

How's this:

If you're running two identical CPU hog tasks A and B differing only by nice
level (Anice, Bnice), the ratio cputime(A)/cputime(B) should be a
constant f(Anice - Bnice).

Other definitions make things hard to analyze and probably not
well-bounded when confronted with > 2 tasks.

I -think- this implies keeping a separate scaled CPU usage counter,
where the scaling factor is a trivial exponential function of nice
level where f(0) == 1. Then you schedule based on this scaled usage
counter rather than unscaled.

I also suspect we want to keep the exponential base small so that the
maximal difference is 10x-100x.

-- 
Mathematics is the supreme nostalgia of our time.
