Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbZEZOyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbZEZOyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZEZOyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:54:13 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42383 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbZEZOyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:54:13 -0400
Date: Tue, 26 May 2009 23:53:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090526145359.GA20760@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <20090526061532.GD9188@linux-sh.org> <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com> <20090526144357.GA20577@linux-sh.org> <1243349409.23657.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243349409.23657.17.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 04:50:09PM +0200, Peter Zijlstra wrote:
> On Tue, 2009-05-26 at 23:43 +0900, Paul Mundt wrote:
> > > Else you might want an additional criteria, like
> > > cyc2ns(1) (much less than) jiffies_to_usecs(1)*1000
> > > (however you do that the best way)
> > > so you don't pick something
> > > that isn't substantially faster than the jiffy counter atleast?
> > > 
> > This rather defeats the purpose of sched_clock() being fast. If we want
> > to add a flag that means this in to the clocksource instead of consulting
> > the rating, that is fine with me too. I know which clocksources I prefer
> > to use for a sched_clock() and they are all better than jiffies. The
> > semantics of how we tell sched_clock() that are not so important. Rating
> > seemed like a good choice from the documentation in struct clocksource at
> > least.
> 
> Am I confused or are we talking about fast HZ vs fast cycles?
> 
> sched_clock() should be fast cycles, that is, we don't want to read a
> clock that takes about 1000 cycles.
> 
> sched_clock() is about providing a high resolution clock that is fast
> (low cycle count) to acquire, and need not be strictly monotonic on smp.

I don't think there's any confusion here. My point is that I didn't want
to add too much logic in to sched_clock() given that it is supposed to be
fast. So if the rating test by itself is not sufficient, then we need
another way to flag a clocksource as being usable for sched_clock().
