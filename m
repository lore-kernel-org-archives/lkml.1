Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYI3RJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYI3RJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYI3RIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:08:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbYI3RIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:08:53 -0400
Date: Tue, 30 Sep 2008 10:01:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
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
In-Reply-To: <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com>  <20080929233539.GA31143@Krystal>  <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>  <20080930000307.GA2929@Krystal> 
 <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>  <20080930034603.GA13801@Krystal>  <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>  <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins>
 <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Sep 2008, Steven Rostedt wrote:
> 
> But I just realized that I could also just make a link list of page 
> pointers and do the exact same thing without having to worry about page 
> frames.  Again, the way I coded this up, it is quite trivial to replace 
> the handling of the pages with other schemes.

That might be the best option.

Yes, doing it in the 'struct page' itself is obviously going to save us 
some memory over having specially allocated page headers, but it's not 
like we'd expect to have _that_ many of these, and having a separate 
structure is actually good in that it also would make it simpler/clearer 
when/if you want to add larger pages (or other non-page allocations) into 
the mix.

For example, if somebody really wants bigger areas, they can allocate them 
with vmalloc and/or multi-page allocations, and then add them as easily to 
the list of pages as if it was a normal page. Doing the same with playing 
tricks on 'struct page' would be pretty damn painful.

		Linus
