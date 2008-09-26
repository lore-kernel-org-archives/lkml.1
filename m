Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYIZLCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYIZLCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 07:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYIZLCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 07:02:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47981 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYIZLCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 07:02:42 -0400
Subject: Re: [RFC PATCH v4] Unified trace buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0809260641590.17102@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org>
	 <20080925185236.244343232@goodmis.org>
	 <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>
	 <48DC406D.1050508@redhat.com>
	 <alpine.DEB.1.10.0809252206260.8454@gandalf.stny.rr.com>
	 <20080926032045.GA28771@Krystal>
	 <1222413507.16700.235.camel@lappy.programming.kicks-ass.net>
	 <alpine.DEB.1.10.0809260641590.17102@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 13:00:54 +0200
Message-Id: <1222426855.16700.264.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-26 at 06:45 -0400, Steven Rostedt wrote:
> On Fri, 26 Sep 2008, Peter Zijlstra wrote:
> > On Thu, 2008-09-25 at 23:20 -0400, Mathieu Desnoyers wrote:
> > > 
> > > You could also fallback on a 2-level page array when buffer size is >
> > > 64MB. The cost is mainly a supplementary pointer dereference, but one
> > > more should not make sure a big difference overall.
> > 
> > I'm still not sure why we don't just link the pages using the page
> > frames, we don't need the random access, do we?
> 
> Yeah we can go back to that (as ftrace does).
> 
> 1) It can be very error prone. I will need to encapsulate the logic more.

Sure.

> 2) I'm still not sure if crash can handle it.

It ought to, and if it can't it should be fixed. Having easy access to
the pageframes is vital to debugging VM issues. So I'd not bother about
this issue too much.

> I was going to reply to Masami with this answer, but it makes things more 
> complex.  For v1 (non RFC v1) I wanted to start simple. v2 can have this 
> enhancement.

Right - I just object to having anything vmalloc.

