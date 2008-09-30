Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYI3Rlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYI3Rlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbYI3Rl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:41:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61808 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYI3Rl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:41:28 -0400
Date: Tue, 30 Sep 2008 13:41:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH v10 Golden] Unified trace buffer
In-Reply-To: <1222794043.24384.22.camel@twins>
Message-ID: <alpine.DEB.1.10.0809301339140.6224@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com>  <20080929233539.GA31143@Krystal>  <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>  <20080930000307.GA2929@Krystal> 
 <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>  <20080930034603.GA13801@Krystal>  <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>  <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins> 
 <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org>  <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <1222794043.24384.22.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Sep 2008, Peter Zijlstra wrote:
> > 
> > Actually, looking at the code, there is no reason I need to keep this in 
> > the frame buffer itself. I've also encapsulated the accesses to the 
> > incrementing of the pointers so it would be trivial to try other 
> > approaches.
> > 
> > The problem we had with the big array struct is that we can want large 
> > buffers and to do that with pointers means we would need to either come up 
> > with a large allocator or use vmap.
> > 
> > But I just realized that I could also just make a link list of page 
> > pointers and do the exact same thing without having to worry about page 
> > frames.  Again, the way I coded this up, it is quite trivial to replace 
> > the handling of the pages with other schemes.
> 
> The list_head in the page frame should be available regardless of
> splice() stuffs.

Regardless, there's more info we want to store for each page than the list 
head.  Especially when we start converting this to lockless. I rather get 
out of the overlaying of the page frames, its nice to save the space, but 
really scares the hell out of me. I can just imagine this blowing up if we 
redo the paging, and I dislike this transparent coupling between the 
tracer buffer and the pages.

-- Steve

