Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZBEX1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZBEX1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBEX1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:27:24 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:19248 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZBEX1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QMHO13OkfMqee4uKh5DueJqsq4EL5F2xitvJTDcRtH+NX7c1g88GQAv7b3Ep/x5qZD
         +HUiWW1xMY/NdJnbx4BqqXzPp52/OQjsxg3kXtZ+rgju8GHQSFwpTe7YPsuqcXqmub68
         Pvw4ookmP1nl6jPhFokaw7qMK17p+Ag1stP3A=
Date: Fri, 6 Feb 2009 00:27:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/2] ring_buffer: remove unused flags parameter
Message-ID: <20090205232717.GD23999@nowhere>
References: <20090205181256.GH17653@ghostprotocols.net> <20090205221701.GA23999@nowhere> <alpine.DEB.1.10.0902051737360.27358@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902051737360.27358@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 05:39:04PM -0500, Steven Rostedt wrote:
> 
> On Thu, 5 Feb 2009, Frederic Weisbecker wrote:
> > >  
> > > -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> > > -					 &irq_flags);
> > > +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
> > >  	if (!event)
> > >  		goto out;
> > >  	entry	= ring_buffer_event_data(event);
> > >  	tracing_generic_entry_update(&entry->ent, 0, 0);
> > >  	entry->ent.type = TRACE_POWER;
> > >  	entry->state_data = *it;
> > > -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> > > +	ring_buffer_unlock_commit(tr->buffer, event);
> > >  
> > >  	trace_wake_up();
> > >  
> > > -- 
> > > 1.6.0.6
> > > 
> > 
> > 
> > I don't what Steven planned (or not) with this flag.
> > If it's not related to his lockless ring buffer project or anything, this
> > cleanup is welcome.
> 
> The irq_flags is legacy from the original implementation. Arnaldo is just 
> going through my todo list (without even me telling him what it is ;-)
> 
> Now only if I can get Arnaldo to do the TODO list my wife gives me ;-)


Can we pull it from somewhere? :-)
 
> -- Steve
> 

