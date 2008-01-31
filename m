Return-Path: <linux-kernel-owner+w=401wt.eu-S933627AbYAaRZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627AbYAaRZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762331AbYAaRZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:25:34 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43892 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762142AbYAaRZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:25:33 -0500
Subject: Re: [PATCH 06/23 -v8] handle accurate time keeping over long delays
From: John Stultz <johnstul@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
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
In-Reply-To: <20080131121037.GB8493@Krystal>
References: <20080130210357.927754294@goodmis.org>
	 <20080130210525.701268662@goodmis.org>  <20080131121037.GB8493@Krystal>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 09:24:57 -0800
Message-Id: <1201800297.6789.14.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 07:10 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: John Stultz <johnstul@us.ibm.com>
> > 
> > Handle accurate time even if there's a long delay between
> > accumulated clock cycles.
> > 
> 
> About this one.. we talked a lot about the importance of timekeeping at
> the first Montreal Tracing Summit this week. Actually, someone
> mentioned a very interesting point : in order to be able to synchronize
> traces taken from the machine with traces taken on external hardware
> (i.e. memory bus tracer on Freescale), taking the "real" counter value
> rather that using the "cumulated cycles" approach (which creates a
> virtual counted instead) would be better.
> 
> So I would recommend using an algorithm that would return a clock value
> which is the same as the underlying hardware counter.

Hmm. It is an interesting issue. Clearly having the raw cycle value
match up so hardware analysis could be mapped to software timestamps
would be useful(although obscure) feature. However with the variety of
clocksources, dealing properly with the clocksource wrap issue (ACPI PM
for instance wraps about every 5 seconds) also has to be addressed.

I think you were mentioning an idea that required some work on the read
side to handle the wraps, basically managing the high order bits by
hand. This sounds like it would be an additional feature that could be
added on to the infrastructure being provided in the
get_monotonic_cycles() patch. No?


However, all of the above is a separate issue then what this (the
timekeeping over long delay) patch addresses, as it is not really
directly related to the get_monotonic_cycles() patch, but instead allows
for correct timekeeping, making update_wall_time() to function properly
if it was deferred for longer then the clocksource's wrap time.

thanks
-john


