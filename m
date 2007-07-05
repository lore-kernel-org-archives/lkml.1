Return-Path: <linux-kernel-owner+w=401wt.eu-S1761926AbXGEUVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761926AbXGEUVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758951AbXGEUVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:21:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757909AbXGEUVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:21:34 -0400
Date: Thu, 5 Jul 2007 13:21:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-Id: <20070705132120.8edbc1f3.akpm@linux-foundation.org>
In-Reply-To: <20070703185748.GA4047@Krystal>
References: <20070703164046.645090494@polymtl.ca>
	<20070703164516.377240547@polymtl.ca>
	<20070703181151.GB5800@martell.zuzino.mipt.ru>
	<20070703185748.GA4047@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007 14:57:48 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Measuring the overall impact on the system of this single modification
> results in the difference brought by one site within the standard
> deviation of the normal samples. It will become significant when the
> number of immediate values used instead of global variables at hot
> kernel paths (need to ponder with the frequency at which the data is
> accessed) will start to be significant compared to the L1 data cache
> size. We could characterize this in memory to L1 cache transfers per
> seconds.
> 
> On 3GHz P4:
> 
> memory read: ~48 cycles
> 
> So we can definitely say that 48*HZ (approximation of the frequency at
> which the scheduler is called) won't make much difference, but as it
> grows, it will.
> 
> On a 1000HZ system, it results in:
> 
> 48000 cycles/second, or 16__s/second, or 0.000016% speedup.
> 
> However, if we place this in code called much more often, such as
> do_page_fault, we get, with an hypotetical scenario of approximation
> of 100000 page faults per second:
> 
> 4800000 cycles/s, 1.6ms/second or 0.0016% speedup.
> 
> So as the number of immediate values used increase, the overall memory
> bandwidth required by the kernel will go down.


Is that 48 cycles measured when the target of the read is in L1 cache, as
it would be in any situation which we actually care about?  I guess so...

Boy, this is a tiny optimisation and boy, you added a pile of tricky new
code to obtain it.

Frankly, I'm thinking that life would be simpler if we just added static
markers and stopped trying to add lots of tricksy
maintenance-load-increasing things like this.

Ho hum.  Need more convincing, please.




Also: a while back (maybe as much as a year) we had an extensive discussion
regarding whether we want static markers at all in the kernel.  The
eventual outcome was, I believe, "yes".

But our reasons for making that decision appear to have been lost.  So if I
were to send the markers patches to Linus and he were to ask me "why are
you sending these", I'd be forced to answer "I don't know".  This is not a
good situation.

Please prepare and maintain a short document which describes the
justification for making all these changes to the kernel.  The changelog
for the main markers patch wold be an appropriate place for this.  The
target audience would be kernel developers and it should capture the pro-
and con- arguments which were raised during that discussion.

Bascially: tell us why we should merge _any_ of this stuff, because I for
one have forgotten.  Thanks.
