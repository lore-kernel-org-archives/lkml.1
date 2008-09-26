Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbYIZSkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbYIZSkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYIZSj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:39:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45388 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbYIZSj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:39:58 -0400
Date: Fri, 26 Sep 2008 14:39:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Richard Holden <aciddeath@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v6] Unified trace buffer
In-Reply-To: <C502866A.12064%aciddeath@gmail.com>
Message-ID: <alpine.DEB.1.10.0809261435540.21618@gandalf.stny.rr.com>
References: <C502866A.12064%aciddeath@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008, Richard Holden wrote:

> On 9/26/08 12:05 PM, "Steven Rostedt" <rostedt@goodmis.org> wrote:
> 
> > ring_buffer_alloc: create a new ring buffer. Can choose between
> > overwrite or consumer/producer mode. Overwrite will
> > overwrite old data, where as consumer producer will
> > throw away new data if the consumer catches up with the
> > producer.  The consumer/producer is the default.
> 
> Forgive me if I've gotten this wrong but the terminology seems backwards
> Here, I would think we only throw away new data if the producer catches up
> with the consumer, if the consumer catches up with the producer we're
> reading data as fast as it's being written.

Argh! Yes.  I'm the one that is backwards ;-)

Yeah, that is what I meant. Don't you know? You are suppose to understand 
what I mean, not what I say :)

> 
> > 
> > ring_buffer_write: writes some data into the ring buffer.
> > 
> > ring_buffer_peek: Look at a next item in the cpu buffer.
> > ring_buffer_consume: get the next item in the cpu buffer and
> > consume it. That is, this function increments the head
> > pointer.
> 
> Here too, I would think that consuming data would modify the tail pointer.

I always get confused with the translation of what the head/tail to 
producer/consumer.

Here I have the producer adding to the tail, and the consumer reading from
the head. Perhaps this is backwards? I could change it.

s/head/foobar/g
s/tail/head/g
s/foobar/tail/g

That could do it.


> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> Just trying to understand the terminology before I look at the code so I'm
> sorry if I have just completely misunderstood.

Sure, thanks.

-- Steve

