Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYIWCvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYIWCvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 22:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYIWCvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 22:51:38 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:39576 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754439AbYIWCvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 22:51:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAOXv10hMQWq+/2dsb2JhbACBXbUXgWY
Date: Mon, 22 Sep 2008 22:49:26 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: prasad@linux.vnet.ibm.com, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, zanussi@comcast.net
Subject: Re: Unified tracing buffer
Message-ID: <20080923024926.GG24937@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <1221869279.8359.31.camel@lappy.programming.kicks-ass.net> <20080922140740.GB5279@in.ibm.com> <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:47:24 up 110 days,  7:27,  7 users,  load average: 1.07, 0.56,
	0.47
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Mon, 2008-09-22 at 19:37 +0530, K.Prasad wrote:
> 
> > > > INPUT_FUNCTIONS
> > > > ---------------
> > > > 
> > > > allocate_buffer (name, size)
> > > >         return buffer_handle
> > > > 
> > > > register_event (buffer_handle, event_id, print_function)
> > > >         You can pass in a requested event_id from a fixed set, and
> > > > will be given it, or an error
> > > >         0 means allocate me one dynamically
> > > >         returns event_id     (or -E_ERROR)
> > > > 
> > > > record_event (buffer_handle, event_id, length, *buf)
> > > 
> > > I'd hoped for an interface like:
> > > 
> > > struct ringbuffer *ringbuffer_alloc(const char *name, size_t size);
> > > void ringbuffer_free(struct ringbuffer *buffer);
> > > int ringbuffer_write(struct ringbuffer *buffer, const char *buf, size_t size);
> > > int ringbuffer_read(struct ringbuffer *buffer, int cpu, char *buf, size_t size);
> > > 
> > > On top of which you'd do the event thing, the register event with a
> > > callback idea makes sense, except I'd split the consumption into two:
> > >  - one method to pull the binary event out, which knows how long it
> > > ought to be etc..
> > >  - one method to convert the binary event to ASCII
> > >
> > In conjunction with the previous email on this thread
> > (http://lkml.org/lkml/2008/9/22/160), may I suggest
> > the equivalent interfaces in -mm tree (2.6.27-rc5-mm1) to be:
> > 
> > relay_printk(<some struct with default filenames/pathnames>, <string>,
> > ....) ;
> > relay_dump(<some struct with default filenames/pathnames>, <binary
> > data>);
> > and
> > relay_cleanup_all(<the struct name>); - Single interface that cleans up
> > all files/directories/output data created under a logical entity.
> 
> Dude, relayfs is such a bad performing mess that extending it seems like
> a bad idea. Better to write something new and delete everything relayfs
> related.
> 

LTTng only uses relay for buffer mapping and mmap to userspace. The rest
of internal buffer management is done within LTTng by overriding relay
callbacks. One thing we could think of is to incrementally fix relay
rather than deleting it completely.

> Also, it seems prudent to separate the ring-buffer implementation from
> the event encoding/decoding facilities.
> 

Sure, but still I think both are needed, even if they are separated as
two different layers (as they should).

Mathieu

> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
