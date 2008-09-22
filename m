Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYIVOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYIVOqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYIVOqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:46:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40034 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYIVOqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:46:06 -0400
Subject: Re: Unified tracing buffer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: prasad@linux.vnet.ibm.com
Cc: Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, zanussi@comcast.net
In-Reply-To: <20080922140740.GB5279@in.ibm.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	 <20080922140740.GB5279@in.ibm.com>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 16:45:24 +0200
Message-Id: <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 19:37 +0530, K.Prasad wrote:

> > > INPUT_FUNCTIONS
> > > ---------------
> > > 
> > > allocate_buffer (name, size)
> > >         return buffer_handle
> > > 
> > > register_event (buffer_handle, event_id, print_function)
> > >         You can pass in a requested event_id from a fixed set, and
> > > will be given it, or an error
> > >         0 means allocate me one dynamically
> > >         returns event_id     (or -E_ERROR)
> > > 
> > > record_event (buffer_handle, event_id, length, *buf)
> > 
> > I'd hoped for an interface like:
> > 
> > struct ringbuffer *ringbuffer_alloc(const char *name, size_t size);
> > void ringbuffer_free(struct ringbuffer *buffer);
> > int ringbuffer_write(struct ringbuffer *buffer, const char *buf, size_t size);
> > int ringbuffer_read(struct ringbuffer *buffer, int cpu, char *buf, size_t size);
> > 
> > On top of which you'd do the event thing, the register event with a
> > callback idea makes sense, except I'd split the consumption into two:
> >  - one method to pull the binary event out, which knows how long it
> > ought to be etc..
> >  - one method to convert the binary event to ASCII
> >
> In conjunction with the previous email on this thread
> (http://lkml.org/lkml/2008/9/22/160), may I suggest
> the equivalent interfaces in -mm tree (2.6.27-rc5-mm1) to be:
> 
> relay_printk(<some struct with default filenames/pathnames>, <string>,
> ....) ;
> relay_dump(<some struct with default filenames/pathnames>, <binary
> data>);
> and
> relay_cleanup_all(<the struct name>); - Single interface that cleans up
> all files/directories/output data created under a logical entity.

Dude, relayfs is such a bad performing mess that extending it seems like
a bad idea. Better to write something new and delete everything relayfs
related.

Also, it seems prudent to separate the ring-buffer implementation from
the event encoding/decoding facilities.



