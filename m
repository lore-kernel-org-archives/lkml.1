Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbZE0A3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbZE0A3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbZE0A3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:29:09 -0400
Received: from www.tglx.de ([62.245.132.106]:53884 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbZE0A3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:29:08 -0400
Date: Wed, 27 May 2009 02:27:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Paul Mundt <lethal@linux-sh.org>, Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback
 sched_clock().
In-Reply-To: <1243383730.3275.53.camel@localhost>
Message-ID: <alpine.LFD.2.00.0905270223550.1762@localhost.localdomain>
References: <20090526061532.GD9188@linux-sh.org>  <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>  <1243348681.23657.14.camel@twins>  <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain>  <20090526230855.GA27218@linux-sh.org>
 <1243380303.3275.40.camel@localhost>  <20090526234425.GB6295@linux-sh.org> <1243383730.3275.53.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On Tue, 26 May 2009, john stultz wrote:
> > See, this is what I thought the rating information was useful for, as the
> > rating is subsequently dropped if it is not usable. But perhaps it makes
> > more sense to just clear the bit at the same time that the rating is
> > lowered once it turns out to be unstable.
> 
> Yes, if we're dropping a clocksource we should also drop the bit. That
> shouldn't be a problem.
> 
> The point I was making, is that multiple clocksources may be registered
> at one time (TSC, ACPI_PM, etc). But only one is being managed by the
> timekeeping code (clock). So there may be the case where the
> sched_clock() is different then the timekeeping clock (which is common
> on x86). 
> 
> So I suspect we need a special hook that grabs the best _SCHED_CLOCK
> clocksource (as computed at clocksource registration time) and provides
> it to the generic sched_clock() interface.

this is not about x86 and its inferiour timer hardware
implementation. We talk about sane architectures which do not have
that problems at all. x86 takes a different code path and overrides
the generic weak sched_clock implememtation anyway. So what ?

Thanks,

	tglx
