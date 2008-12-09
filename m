Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYLIWTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYLIWTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYLIWTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:19:15 -0500
Received: from ozlabs.org ([203.10.76.45]:50603 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbYLIWTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:19:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18750.61143.101922.949701@cargo.ozlabs.ibm.com>
Date: Wed, 10 Dec 2008 09:19:03 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Subject: Re: [patch] Performance Counters for Linux, v2
In-Reply-To: <20081209134636.GA1926@elte.hu>
References: <20081208012211.GA23106@elte.hu>
	<7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com>
	<20081209134636.GA1926@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> yeah, but it's still the fundamentally wrong thing to do.
> 
> Being able to extract high-quality performance information from the 
> system is the cornerstone of our design, and chosing the right sampling 
> model permeates the whole issue of single-counter versus group-readout.

Thanks for taking the time to write all this down, and I will respond
in detail once I have thought about it some more.

The thing that stands out to me immediately, though, is that you are
concentrating entirely on _sampling_ as opposed to _counting_.
Perhaps this is the main reason we have been disagreeing.

Now of course sampling is interesting, but counting is also
interesting, whether over the whole execution of a program or over
short intervals during the execution of a program (based either on
time, or on the execution of certain functions).

It seems to me that a well-designed performance monitor infrastructure
should support both counting and sampling.  And for counting, getting
high-quality data requires synchronized counters (ones that all start
counting and stop counting at the same times).

Looking back at the discussion so far, I can see that your arguments
make more sense if you are only wanting to do sampling.  And I have
been arguing for what I believe we need to do counting properly (I
have focused more on counting because we already have infrastructure
for sampling, namely oprofile).

So, can we agree to discuss both sampling and counting, and design an
infrastructure that's good for both?

Paul.
