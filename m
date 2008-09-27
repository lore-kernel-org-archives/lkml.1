Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbYI0SSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbYI0SSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYI0SS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:18:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbYI0SS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:18:29 -0400
Date: Sat, 27 Sep 2008 14:18:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <1222537829.16700.304.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0809271412390.11231@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org>  <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu>  <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org>
  <20080925211017.GA12689@elte.hu> <20080925214134.GA23025@elte.hu>  <alpine.LFD.1.10.0809251458020.3265@nehalem.linux-foundation.org>  <20080925221441.GA29060@elte.hu>  <alpine.LFD.1.10.0809251631460.3265@nehalem.linux-foundation.org>  <20080927171640.GA1990@elte.hu>
  <alpine.DEB.1.10.0809271335001.10534@gandalf.stny.rr.com> <1222537829.16700.304.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Sep 2008, Peter Zijlstra wrote:

> On Sat, 2008-09-27 at 13:38 -0400, Steven Rostedt wrote:
> 
> >  It does not even implement the merge sort. That's up to the 
> > tracer to handle. 
> 
> You could though, as you have the timestamps..

Yep, and the first version did just that. I could add it back, but it gets 
interesting if we want to read from a buffer not on the same CPU, if we 
want to implement lockless.

I started (but pushed it aside) a tracing_buffer.c layer, that would do 
the merges and such based on the timestamps, as well as events and event
registration. It was because of you that I pulled this stuff out of the 
bottom ring buffer layer ;-)


 > 
> > So yes, the tracer can implement anything it wants on top of the ring 
> > buffer ;-)
> 
> Mathieu seems to disagree, it would be good if he can share some
> specifics so we can work on resolving those.

Mathieu always disagrees ;-)

Well the ring buffer interface should never interact directly with the 
user interface. There should always be a layer between the buffer and the 
user interface. This means that V2 can change drastically from V1. But I 
want V1 to get in now so that we can start unifying the existing tracers 
in the kernel.

Also, I like Linus's proposal that anything bigger than a page needs to be 
kept outside the ring buffer and the ring buffer can simply add a pointer 
to it.

-- Steve

