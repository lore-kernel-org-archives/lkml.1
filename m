Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYI3Qsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYI3Qsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYI3QsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:48:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52528 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYI3QsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:48:22 -0400
Date: Tue, 30 Sep 2008 12:48:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v10 Golden] Unified trace buffer
In-Reply-To: <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com>  <20080929233539.GA31143@Krystal>  <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>  <20080930000307.GA2929@Krystal> 
 <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>  <20080930034603.GA13801@Krystal>  <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>  <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins>
 <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Sep 2008, Linus Torvalds wrote:
> 
> Trace buffers are different, though. Do people realize that doing the 
> overloading means that you never EVER can use those buffers for anything 
> else? Do people realize that it means that splice() and friends are out of 
> the question?
> 
> > Trouble is, looking at it I see no easy way out,
> 
> Quite frankly, we could just put it at the head of the page itself. Having 
> a "whole page" for the trace data is not possible anyway, since the trace 
> header itself will always eat 8 bytes.
> 
> And I do think it would potentially be a better model. Or at least safer.

Actually, looking at the code, there is no reason I need to keep this in 
the frame buffer itself. I've also encapsulated the accesses to the 
incrementing of the pointers so it would be trivial to try other 
approaches.

The problem we had with the big array struct is that we can want large 
buffers and to do that with pointers means we would need to either come up 
with a large allocator or use vmap.

But I just realized that I could also just make a link list of page 
pointers and do the exact same thing without having to worry about page 
frames.  Again, the way I coded this up, it is quite trivial to replace 
the handling of the pages with other schemes.

-- Steve

