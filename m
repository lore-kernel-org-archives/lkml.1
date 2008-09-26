Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYIZX7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYIZX7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 19:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYIZX7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 19:59:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYIZX7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 19:59:00 -0400
Date: Fri, 26 Sep 2008 19:58:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arnaldo Carvalho de Melo <acme@redhat.com>
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
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v6] Unified trace buffer
In-Reply-To: <20080926223129.GF15446@ghostprotocols.net>
Message-ID: <alpine.DEB.1.10.0809261957001.21618@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <20080926223129.GF15446@ghostprotocols.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008, Arnaldo Carvalho de Melo wrote:

> Em Fri, Sep 26, 2008 at 02:05:44PM -0400, Steven Rostedt escreveu:
> > + */
> > +static inline void *
> > +ring_buffer_event_data(struct ring_buffer_event *event)
> > +{
> > +	BUG_ON(event->type != RB_TYPE_DATA);
> > +	/* If length is in len field, then array[0] has the data */
> > +	if (event->len)
> > +		return (void *)&event->array[0];
> > +	/* Otherwise length is in array[0] and array[1] has the data */
> > +	return (void *)&event->array[1];
> 
> Nitpick: Why cast to void *?

5 day hacking marathon, I cast everything ;-)

> 
> And sometimes you use the rb_ prefix, in other cases you use the longer
> for ring_buffer_, is the ring_ namespace already used? Or can we make it
> use rb_ consistently to shorten the names?

I started using the rb_ because I was constantly breaking the 80 character 
line limit with ring_buffer ;-)   OK, for v8, I'll rename all static 
internal functions to rb_ and keep the global ones ring_buffer_

Thanks,

-- Steve

