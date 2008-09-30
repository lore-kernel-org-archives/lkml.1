Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYI3Rej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYI3Rej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYI3ReV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:34:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:59914 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbYI3ReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:34:19 -0400
Subject: Re: [PATCH v10 Golden] Unified trace buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
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
In-Reply-To: <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com>
	 <20080929233539.GA31143@Krystal>
	 <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>
	 <20080930000307.GA2929@Krystal>
	 <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>
	 <20080930034603.GA13801@Krystal>
	 <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>
	 <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins>
	 <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 19:00:43 +0200
Message-Id: <1222794043.24384.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-30 at 12:48 -0400, Steven Rostedt wrote:
> On Tue, 30 Sep 2008, Linus Torvalds wrote:
> > 
> > Trace buffers are different, though. Do people realize that doing the 
> > overloading means that you never EVER can use those buffers for anything 
> > else? Do people realize that it means that splice() and friends are out of 
> > the question?
> > 
> > > Trouble is, looking at it I see no easy way out,
> > 
> > Quite frankly, we could just put it at the head of the page itself. Having 
> > a "whole page" for the trace data is not possible anyway, since the trace 
> > header itself will always eat 8 bytes.
> > 
> > And I do think it would potentially be a better model. Or at least safer.
> 
> Actually, looking at the code, there is no reason I need to keep this in 
> the frame buffer itself. I've also encapsulated the accesses to the 
> incrementing of the pointers so it would be trivial to try other 
> approaches.
> 
> The problem we had with the big array struct is that we can want large 
> buffers and to do that with pointers means we would need to either come up 
> with a large allocator or use vmap.
> 
> But I just realized that I could also just make a link list of page 
> pointers and do the exact same thing without having to worry about page 
> frames.  Again, the way I coded this up, it is quite trivial to replace 
> the handling of the pages with other schemes.

The list_head in the page frame should be available regardless of
splice() stuffs.

