Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbZEOVvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbZEOVvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbZEOVup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:50:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44307 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbZEOVuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:50:44 -0400
Date: Fri, 15 May 2009 17:50:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/3] tracing: add flag output for kmem events
In-Reply-To: <20090515212328.GA6156@nowhere>
Message-ID: <alpine.DEB.2.00.0905151745080.3647@gandalf.stny.rr.com>
References: <20090515210342.488025506@goodmis.org> <20090515210718.211132919@goodmis.org> <20090515212328.GA6156@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 15 May 2009, Frederic Weisbecker wrote:

> On Fri, May 15, 2009 at 05:03:45PM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > This patch changes the output for gfp_flags from being a simple hex value
> > to the actual names.
> > 
> >   gfp_flags=GFP_ATOMIC  instead of gfp_flags=00000020
> > 
> > And even
> > 
> >   gfp_flags=GFP_KERNEL instead of gfp_flags=000000d0
> > 
> > [ Impact: more human readable output from tracer ]
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> 
> Nice!
> 
> 
> > ---
> >  include/trace/events/kmem.h |   43 +++++++++++++++++++++++++++++++++++--------
> >  1 files changed, 35 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
> > index c22c42f..9b3886b 100644
> > --- a/include/trace/events/kmem.h
> > +++ b/include/trace/events/kmem.h
> > @@ -7,6 +7,33 @@
> >  #undef TRACE_SYSTEM
> >  #define TRACE_SYSTEM kmem
> >  
> > +#define show_gfp_flags(flags)						\
> > +	(flags) ? __print_flags(flags, "|",				\
> > +	(unsigned long)GFP_KERNEL,		"GFP_KERNEL",		\
> > +	(unsigned long)GFP_NOFS,		"GFP_NOFS",		\
> > +	(unsigned long)GFP_TEMPORARY,		"GFP_TEMPORARY",	\
> > +	(unsigned long)GFP_USER,		"GFP_USER",		\
> 
> 
> Because you clear the mask value after finding out a matching mask
> string, you should sort the masks from the highest number of bits
> to the lowest.
> 
> GFP_USER should be placed before GFP_KERNEL otherwise it will always be
> eaten.
> Instead of GFP_USER, you will get:
> 
> GFP_KERNEL | __GFP_HARDWALL

Ug, I was thinking the code only printed the mask if the mask matched 
fully.

> 
> 
> > +	(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER",		\
> 
> 
> Ditto, it should be placed before GFP_USER otherwise you will get:
> 
> GFP_USER | __GFP_HIGHMEM
> 
> 
> > +	(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE",	\
> 
> And this one before HIGH_USER otherwise:
> 
> GFP_HIGHUSER__GFP_MOVABLE

Anyway, I thought I did sort it out, but I did not realize that some masks 
have masks within. I need more sleep.

Will fix in take two. Still waiting for comments from the MM folks.

-- Steve
