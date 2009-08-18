Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbZHRAG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbZHRAG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 20:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZHRAG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 20:06:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZHRAG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 20:06:26 -0400
Date: Mon, 17 Aug 2009 20:06:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH 07/12] add ftrace_event_call void * 'data' field
In-Reply-To: <20090817230926.GC4962@nowhere>
Message-ID: <alpine.DEB.2.00.0908172004531.25890@gandalf.stny.rr.com>
References: <cover.1249932670.git.jbaron@redhat.com> <2f63f892c862efd4f58f9d3e72cb5bc55f2d0025.1249932670.git.jbaron@redhat.com> <20090811100904.GA4938@nowhere> <alpine.DEB.2.00.0908171818420.25890@gandalf.stny.rr.com> <20090817230926.GC4962@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Aug 2009, Frederic Weisbecker wrote:
> > > > @@ -568,7 +568,7 @@ static void ftrace_raw_event_##call(proto)				\
> > > >  		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
> > > >  }									\
> > > >  									\
> > > > -static int ftrace_raw_reg_event_##call(void)				\
> > > > +static int ftrace_raw_reg_event_##call(void *ptr)			\
> > > 
> > > 
> > > Shouldn't it have a __used attribute here, or something?
> > 
> > Do function parameters need that? There's lots of places where the 
> > parameter of a function is not used by a function itself.
> > 
> > -- Steve
> 
> 
> No actually, I thought gcc would warn, but it didn't :-)

Yeah, that is the right thing too. Because functions can be passed as 
parameters (like this one) and every "stub function" we have will then 
need this attribute. It is OK to ignore parameters of functions without 
telling gcc that you plan on ignoring them.

-- Steve

