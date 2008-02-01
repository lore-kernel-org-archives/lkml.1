Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbYBARHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbYBARHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbYBARH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:07:28 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:59490 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325AbYBARH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:07:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAM3gokdMQWYq/2dsb2JhbACBWK0O
Date: Fri, 1 Feb 2008 12:02:19 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: John Stultz <johnstul@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20080201170219.GA19397@Krystal>
References: <20080130210357.927754294@goodmis.org> <20080130210525.701268662@goodmis.org> <20080131121037.GB8493@Krystal> <1201800297.6789.14.camel@jstultz-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1201800297.6789.14.camel@jstultz-laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:58:34 up 89 days, 22:04,  5 users,  load average: 2.74, 1.27,
	0.83
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* John Stultz (johnstul@us.ibm.com) wrote:
> 
> On Thu, 2008-01-31 at 07:10 -0500, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > From: John Stultz <johnstul@us.ibm.com>
> > > 
> > > Handle accurate time even if there's a long delay between
> > > accumulated clock cycles.
> > > 
> > 
> > About this one.. we talked a lot about the importance of timekeeping at
> > the first Montreal Tracing Summit this week. Actually, someone
> > mentioned a very interesting point : in order to be able to synchronize
> > traces taken from the machine with traces taken on external hardware
> > (i.e. memory bus tracer on Freescale), taking the "real" counter value
> > rather that using the "cumulated cycles" approach (which creates a
> > virtual counted instead) would be better.
> > 
> > So I would recommend using an algorithm that would return a clock value
> > which is the same as the underlying hardware counter.
> 
> Hmm. It is an interesting issue. Clearly having the raw cycle value
> match up so hardware analysis could be mapped to software timestamps
> would be useful(although obscure) feature. However with the variety of
> clocksources, dealing properly with the clocksource wrap issue (ACPI PM
> for instance wraps about every 5 seconds) also has to be addressed.
> 
> I think you were mentioning an idea that required some work on the read
> side to handle the wraps, basically managing the high order bits by
> hand. This sounds like it would be an additional feature that could be
> added on to the infrastructure being provided in the
> get_monotonic_cycles() patch. No?
> 

Yup, exactly.

> 
> However, all of the above is a separate issue then what this (the
> timekeeping over long delay) patch addresses, as it is not really
> directly related to the get_monotonic_cycles() patch, but instead allows
> for correct timekeeping, making update_wall_time() to function properly
> if it was deferred for longer then the clocksource's wrap time.
> 

I agree, that could apply on top of the monotonic cycles patch. It's
just a different way to see it : dealing with wrapping TSC bits,
returning the LSBs given by the hardware, rather than simply
accumulating time. This is what the patch I sent earlier (which I use in
LTTng) does. I currently expects 32 LSBs to be given by the hardware,
but it would be trivial to extend it to support any given number of
hardware LSBs.

Mathieu

> thanks
> -john
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
