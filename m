Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYITI0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYITI0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 04:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbYITI0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 04:26:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38101 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYITI0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 04:26:05 -0400
Date: Sat, 20 Sep 2008 04:26:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Martin Bligh <mbligh@google.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <33307c790809191457y3ebffa28xa6d9ab6431554618@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809200424050.9362@gandalf.stny.rr.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>  <20080919144258.ac787fdf.randy.dunlap@oracle.com> <33307c790809191457y3ebffa28xa6d9ab6431554618@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Sep 2008, Martin Bligh wrote:

> >> Event ids are 16 bit, dynamically allocated.
> >
> > What are these (like)?
> 
> u16
> 
> Sorry, probably lots of implicit assumptions in there that I forgot to explain
> 
> > Arch-specific "word"?
> > or some fixed-size-for-all-systems (so that trace buffers can be
> > shared/used on other systems?)  Preferably the latter.
> 
> Mmmm. I don't see anything wrong with making it just 8 byte aligned, personally.
> Steven - this was your thing?

I'm fine with 8 byte aligned for all.

> 
> >> Variable record length, header will start with length record.
> >> Timestamps in fixed timebase, monotonically increasing (across all CPUs)
> >
> > what timestamp resolution?
> 
> ns is probably sufficient for output, but may need to be higher
> internally to get
> correct ordering of events across CPUs. So, as long as we record this in
> the buffer header, the internal resolution shouldn't be critical. The text
> print output ... I'd say ns? We can put it relative to wall time in there,
> as long as we record it in the buffer header at trace start. I guess we should
> document the buffer header ;-)
> 

ftrace has two outputs. One is ns from start of boot, the other is ns from 
start of trace. Not sure we need to make wall time in there, unless we add 
it in the trace header (as you stated). Probably best for Version #2.

-- Steve

