Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbYIYVPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbYIYVPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYIYVPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:15:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:7727 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754051AbYIYVPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:15:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Vzk/vxBNs8NwdJHkLqNRqbYbpqw0H+rYNx/VEB8sY44dRrFi+PuSvKydPLWPhigI7
	AwUJO9Yu255zTQ0emQ8Qg==
Message-ID: <33307c790809251415u9d2146aw87ba2420724702ae@mail.gmail.com>
Date: Thu, 25 Sep 2008 14:15:08 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Martin Bligh" <mbligh@mbligh.org>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "David Wilder" <dwilder@us.ibm.com>, hch@lst.de,
       "Tom Zanussi" <zanussi@comcast.net>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <20080925205218.GA8997@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
	 <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com>
	 <20080925153635.GA12840@elte.hu>
	 <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com>
	 <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org>
	 <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu>
	 <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org>
	 <20080925205218.GA8997@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - save a GTOD+TSC pair at important events, such as to-idle and
>   from-idle, and in the periodic sched_tick(). [ perhaps also save it
>   when we change cpufreq. ]

We did GTOD, but I think it's a bad idea, because NTP moves it.

>  - save the (last_GTOD, _relative_-TSC) pair in the trace entry
>
> with that we have a chance to do good post-processed correlation - at
> the cost of having 12-16 bytes of timestamp, per trace entry.
>
> Or we could upscale the GTOD to 'TSC time', at go-idle and from-idle.
> Which is rather complicated with cpufreq - which frequency do we want to
> upscale to if we have a box with three available frequencies? We could
> ignore cpufreq altogether - but then there goes dependable tracing on
> another range of boxes.

Simple solution: turn off cpufreq whilst tracing is on ;-)

Harder: Keep a timebase and frequency divisor on a per-cpu basis
and calculate your offsets from there. This brings you down to
HPET resolution though
