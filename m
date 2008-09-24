Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbYIXRzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbYIXRzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 13:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYIXRy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 13:54:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:26738 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYIXRyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:54:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=xh7q432KppOqlDg3Oam11fFrtWnQd9BLIs1QLtfKhqt3SoUMAo+b+KE4y2ed/LOEr
	cmqyfmmEJSmw1+kuT370w==
Message-ID: <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com>
Date: Wed, 24 Sep 2008 10:54:37 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "David Wilder" <dwilder@us.ibm.com>, hch@lst.de,
       "Tom Zanussi" <zanussi@comcast.net>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924051056.650388887@goodmis.org>
	 <20080924051400.195780424@goodmis.org>
	 <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>
	 <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
	 <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
	 <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com>
	 <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>
X-GMailtapped-By: 172.24.198.81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why "tsc_shifted"?
>
> I think 27 bits is probably fine, but not by removing precision. Instead
> of shifting it so it will fit (and dropping low bits as uninteresting), do
> it by encoding it as a delta against the previous thing. 27 bits would
> still be sufficient for any high-performance thing that has tons and tons
> of packets, and if you only have a few trace events you can afford to have
> the "TSC overflow" event type (and if you want it that dense, you could
> just make 'data' be the high bits, for a total of 59 bits rather than 64
> bits of TSC.
>
> 59 bits of cycle counters is perfectly fine unless you are talking trace
> events over a year or so (I didn't do the math, but let's assume a 4GHz
> TSC as a reasonable thing even going forward - even _if_ CPU's get faster
> than that, the TSC is unlikely to tick faster since it's just not worth it
> from a power standpoint).
>
> Ok, I did the math. 1<<27 seconds (assuming the low 32 bits are just
> fractions) is something like 4+ years. I _really_ don't think we need more
> than that (or even close to that) in TSC timestamps for tracing within one
> single buffer.

Mmm. Either I'm confused, or we're talking about different things.

If we just record the TSC unshifted, in 27 bits, at 4GHz, that gives us
about 1/30 of a second? So we either shift, use > 27 bits, or record
at least 30 events a second, none of which I like much ...
