Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZEZOuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZEZOuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZEZOuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:50:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:38680 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbZEZOug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:50:36 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
 fallback sched_clock().
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090526144357.GA20577@linux-sh.org>
References: <20090526061532.GD9188@linux-sh.org>
	 <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
	 <20090526144357.GA20577@linux-sh.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 26 May 2009 16:50:09 +0200
Message-Id: <1243349409.23657.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 23:43 +0900, Paul Mundt wrote:
> > Else you might want an additional criteria, like
> > cyc2ns(1) (much less than) jiffies_to_usecs(1)*1000
> > (however you do that the best way)
> > so you don't pick something
> > that isn't substantially faster than the jiffy counter atleast?
> > 
> This rather defeats the purpose of sched_clock() being fast. If we want
> to add a flag that means this in to the clocksource instead of consulting
> the rating, that is fine with me too. I know which clocksources I prefer
> to use for a sched_clock() and they are all better than jiffies. The
> semantics of how we tell sched_clock() that are not so important. Rating
> seemed like a good choice from the documentation in struct clocksource at
> least.

Am I confused or are we talking about fast HZ vs fast cycles?

sched_clock() should be fast cycles, that is, we don't want to read a
clock that takes about 1000 cycles.

sched_clock() is about providing a high resolution clock that is fast
(low cycle count) to acquire, and need not be strictly monotonic on smp.
