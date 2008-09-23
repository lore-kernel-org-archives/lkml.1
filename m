Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYIWTDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYIWTDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYIWTD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:03:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972AbYIWTD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:03:28 -0400
Date: Tue, 23 Sep 2008 11:56:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <zanussi@comcast.net>, prasad@linux.vnet.ibm.com,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, linux-mm@kvack.org
Subject: Re: Unified tracing buffer
In-Reply-To: <48D93665.8030200@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809231154420.3265@nehalem.linux-foundation.org>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <1221869279.8359.31.camel@lappy.programming.kicks-ass.net> <20080922140740.GB5279@in.ibm.com> <1222094724.16700.11.camel@lappy.programming.kicks-ass.net> <1222147545.6875.135.camel@charm-linux>
 <1222162270.16700.57.camel@lappy.programming.kicks-ass.net> <20080923181313.GA4947@Krystal> <48D93665.8030200@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Sep 2008, Christoph Lameter wrote:

> Mathieu Desnoyers wrote:
> > 
> > I think we should instead try to figure out what is currently missing in
> > the kernel vmap mechanism (probably the ability to vmap from large 4MB
> > pages after boot), and fix _that_ instead (if possible), which would not
> > only benefit to tracing, but also to module support.

No. Don't go there. Piece of absolute shit.

The problem with VMAP is that it's _limited_. We don't have reasonable 
virtual address space holes for x86-32.

The other is that physically contiguos buffers are hard to come by. 
Certainly not an acceptable solution.

The third is that if you have multiple buffers, you need to look them up 
in software anyway, so the whole notion of mis-using the TLB to avoid a 
software lookup is TOTAL CRAP.

Don't do virtual mapping. IT IS BROKEN. IT IS A TOTAL AND UTTER PIECE OF 
SHIT.

I will absolutely not take any general-purpse tracing code if I'm aware of 
it mis-using the TLB to play games.

		Linus
