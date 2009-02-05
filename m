Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbZBEWjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbZBEWjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZBEWjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:39:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38554 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbZBEWjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:39:08 -0500
Date: Thu, 5 Feb 2009 17:39:04 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/2] ring_buffer: remove unused flags parameter
In-Reply-To: <20090205221701.GA23999@nowhere>
Message-ID: <alpine.DEB.1.10.0902051737360.27358@gandalf.stny.rr.com>
References: <20090205181256.GH17653@ghostprotocols.net> <20090205221701.GA23999@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 5 Feb 2009, Frederic Weisbecker wrote:
> >  
> > -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> > -					 &irq_flags);
> > +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
> >  	if (!event)
> >  		goto out;
> >  	entry	= ring_buffer_event_data(event);
> >  	tracing_generic_entry_update(&entry->ent, 0, 0);
> >  	entry->ent.type = TRACE_POWER;
> >  	entry->state_data = *it;
> > -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> > +	ring_buffer_unlock_commit(tr->buffer, event);
> >  
> >  	trace_wake_up();
> >  
> > -- 
> > 1.6.0.6
> > 
> 
> 
> I don't what Steven planned (or not) with this flag.
> If it's not related to his lockless ring buffer project or anything, this
> cleanup is welcome.

The irq_flags is legacy from the original implementation. Arnaldo is just 
going through my todo list (without even me telling him what it is ;-)

Now only if I can get Arnaldo to do the TODO list my wife gives me ;-)

-- Steve

