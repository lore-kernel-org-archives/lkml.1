Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbYBBHMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbYBBHMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 02:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYBBHL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 02:11:58 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:63623 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbYBBHL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 02:11:57 -0500
Date: Sat, 2 Feb 2008 02:11:41 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 06/23 -v8] handle accurate time keeping over long delays
In-Reply-To: <20080201170219.GA19397@Krystal>
Message-ID: <Pine.LNX.4.58.0802020209230.21975@gandalf.stny.rr.com>
References: <20080130210357.927754294@goodmis.org> <20080130210525.701268662@goodmis.org>
 <20080131121037.GB8493@Krystal> <1201800297.6789.14.camel@jstultz-laptop>
 <20080201170219.GA19397@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Fri, 1 Feb 2008, Mathieu Desnoyers wrote:

> > > > accumulated clock cycles.
> > > >
> > >
> > > About this one.. we talked a lot about the importance of timekeeping at
> > > the first Montreal Tracing Summit this week. Actually, someone
> > > mentioned a very interesting point : in order to be able to synchronize
> > > traces taken from the machine with traces taken on external hardware
> > > (i.e. memory bus tracer on Freescale), taking the "real" counter value
> > > rather that using the "cumulated cycles" approach (which creates a
> > > virtual counted instead) would be better.
> > >
> > > So I would recommend using an algorithm that would return a clock value
> > > which is the same as the underlying hardware counter.
> >
> > Hmm. It is an interesting issue. Clearly having the raw cycle value
> > match up so hardware analysis could be mapped to software timestamps
> > would be useful(although obscure) feature. However with the variety of
> > clocksources, dealing properly with the clocksource wrap issue (ACPI PM
> > for instance wraps about every 5 seconds) also has to be addressed.
> >
> > I think you were mentioning an idea that required some work on the read
> > side to handle the wraps, basically managing the high order bits by
> > hand. This sounds like it would be an additional feature that could be
> > added on to the infrastructure being provided in the
> > get_monotonic_cycles() patch. No?
> >
>
> Yup, exactly.
>
> >
> > However, all of the above is a separate issue then what this (the
> > timekeeping over long delay) patch addresses, as it is not really
> > directly related to the get_monotonic_cycles() patch, but instead allows
> > for correct timekeeping, making update_wall_time() to function properly
> > if it was deferred for longer then the clocksource's wrap time.
> >
>
> I agree, that could apply on top of the monotonic cycles patch. It's
> just a different way to see it : dealing with wrapping TSC bits,
> returning the LSBs given by the hardware, rather than simply
> accumulating time. This is what the patch I sent earlier (which I use in
> LTTng) does. I currently expects 32 LSBs to be given by the hardware,
> but it would be trivial to extend it to support any given number of
> hardware LSBs.
>

So you are saying that you can trivally make it work with a clock that is,
say 24 bits? And this same code can work if we boot up with a clock with
32 bits or more?

-- Steve

