Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYIZTwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYIZTwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYIZTwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:52:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62748 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYIZTwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:52:22 -0400
Date: Fri, 26 Sep 2008 15:52:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Martin Bligh <mbligh@google.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v6] Unified trace buffer
In-Reply-To: <33307c790809261246o47148443j49fee9197d18a3f1@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809261549150.21618@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org>  <20080925185236.244343232@goodmis.org>  <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>  <48DC406D.1050508@redhat.com>  <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>  <1222455557.16700.285.camel@lappy.programming.kicks-ass.net> <33307c790809261246o47148443j49fee9197d18a3f1@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008, Martin Bligh wrote:

> On Fri, Sep 26, 2008 at 11:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2008-09-26 at 14:05 -0400, Steven Rostedt wrote:
> >
> >> +struct buffer_page {
> >> +     u64             time_stamp;
> >> +     unsigned char   body[];
> >> +};
> >> +
> >> +#define BUF_PAGE_SIZE (PAGE_SIZE - sizeof(u64))
> >
> > Since you're already using the page frame, you can stick this per page
> > timestamp in there as well, and get the full page for data.
> >
> > You can either use a struct page overlay like slob does, or add a u64 in
> > the union that contains struct {private, mapping}.
> 
> What did you guys think of Mathieu's idea of sticking the buffer length
> in the header here, rather than using padding events? Seemed cleaner
> to me.

Actually I like the padding. This way when I move the event pointer 
forward, I only need to compare it to a constant (PAGE_SIZE), or test to 
see if the event is padding.  Placing this into the buffer page, I will 
have to always compare it to that pointer.

But I guess I could change it to that if needed. That doesn't affect the 
API, as it is only internal.

I'm almost done with v7, perhaps I might try that with v8 to see if I like 
it better.

-- Steve

