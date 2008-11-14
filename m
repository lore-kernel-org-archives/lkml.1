Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbYKNCbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbYKNCbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbYKNCbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:31:05 -0500
Received: from waste.org ([66.93.16.53]:42713 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYKNCbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:31:03 -0500
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
From: Matt Mackall <mpm@selenic.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
In-Reply-To: <491CD1DD.3020201@zytor.com>
References: <20081104122839.GA22864@mailshack.com>
	 <20081104150729.GC21470@localhost>
	 <20081104170501.GE29626@one.firstfloor.org>
	 <1225822006.21441.1282961299@webmail.messagingengine.com>
	 <20081104204400.GC10825@elte.hu>
	 <1226243805.27361.1283784629@webmail.messagingengine.com>
	 <20081110085846.GG22392@elte.hu>
	 <1226321061.23701.1283927805@webmail.messagingengine.com>
	 <20081110130709.GA32613@elte.hu>
	 <1226352907.25721.1284024167@webmail.messagingengine.com>
	 <49191185.2000102@zytor.com> <1226615039.3343.53.camel@calx>
	 <491CD1DD.3020201@zytor.com>
Content-Type: text/plain
Date: Thu, 13 Nov 2008 20:29:36 -0600
Message-Id: <1226629776.3343.84.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 17:18 -0800, H. Peter Anvin wrote:
> Matt Mackall wrote:
> > On Mon, 2008-11-10 at 21:00 -0800, H. Peter Anvin wrote:
> >> Okay, after spending most of the day trying to get something that isn't
> >> completely like white noise (interesting problem, otherwise I'd have
> >> given up long ago) I did, eventually, come up with something that looks
> >> like it's significant.  I did a set of multiple runs, and am looking for
> >> the "waterfall points" in the cumulative statistics.
> >>
> >> http://www.zytor.com/~hpa/baseline-hpa-3000-3600.pdf
> >>
> >> This particular set of data points was gathered on a 64-bit kernel, so I
> >> didn't try the segment technique.
> >>
> >> It looks to me that the collection of red lines is enough to the left of
> >> the black ones that one can assume there is a significant effect,
> >> probably by about a cache miss worth of time.
> > 
> > This graph is a little confusing. Is the area under each curve here
> > supposed to be a constant?
> > 
> 
> No, they reflect individual runs.  They start at 1 at the top left and
> drop to 0 at the far right in each case.  What matters is the horizontal
> position of large vertical drops.

Still confused. If, say, the top blue line on the left represents the
same number of interrupts as the bottom red one, then at some point it
must cross under the red one as it goes to the right, which it does not
appear to do. Thus, it does not appear the scale on the left is actually
in units of constant probability, no?

Though I'll agree that even if they're not scaled so that the area under
the curve sums to a probability of 1, the centerpoint of the vertical
drop is what matters. But that's rather hard to read off this chart, as
the blue line I mentioned has a center point point well above the red
one, so while it looks like a shift of 80 cycles, it's more like 30.

Is there any theoretical reason you can't just sum the histograms for
runs of the same code and then divide by event count? Is there some sort
of alignment/cache-coloring issue across boots?

> > Is this latency from all interrupts as seen by userspace? Or does a
> > particular interrupt dominate?
> > 
> 
> All interrupts, but rather inherently the difference between interrupt
> handlers is going to be bigger than the differences between
> implementations of the same handler.  I *believe* all the interrupts
> you're seeing in that graph are probably timer interrupts.  The other
> major interrupt source that was active on the system was USB.

That's what I'd expect on an idle system, certainly.

Anyway, I'm actually surprised your red graph is visibly better than
your blue one. FWIW, I was leaning towards your simpler variant (and
away from the magical segment register proposal). I'd be happy to see
either of your versions submitted.

-- 
Mathematics is the supreme nostalgia of our time.

