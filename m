Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbZFANQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbZFANQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 09:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756998AbZFANQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 09:16:35 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:65526 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbZFANQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 09:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jmKG/m1/mRWRxbilC7VNqSolFQcvkOafUT3T/LdVskHa9hB+In9tBaRHz8GQdpj2Sx
         fyWa9u7HaYBOmFi97WDwPLEoV9LxdRCUD9xuITqJbbKnB6LRk9OzKhl6MD3YSQroEl09
         dzHBAHSHpAXKH+r4AdjYUf/aaIWCvbUPGaBsc=
Date: Mon, 1 Jun 2009 15:16:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/events: put TP_fast_assign into braces
Message-ID: <20090601131631.GB6000@nowhere>
References: <4A2384B1.90100@cn.fujitsu.com> <alpine.DEB.2.00.0906010911370.14994@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906010911370.14994@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 09:11:52AM -0400, Steven Rostedt wrote:
> 
> 
> 
> On Mon, 1 Jun 2009, Li Zefan wrote:
> 
> > Currently TP_fast_assin has a limitation that we can't define local
> > variables in it.
> > 
> > Here's one use case when we introduce __dynamic_array():
> > 
> > TP_fast_assign(
> > 	type *p = __get_dynamic_array(item);
> > 
> > 	foo(p);
> > 	bar(p);
> > ),
> > 
> > [ Impact: allow defining local variables in TP_fast_assign ]
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Thanks Li,
> 
> I'll pull it in.
> 
> -- Steve

Hi Steve,

Note, they depend on the following patch:

tracing/events: fix a typo in __string() format output

You can pick it from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Thanks!

 
> > ---
> >  include/trace/ftrace.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > index 9276ec4..ee92682 100644
> > --- a/include/trace/ftrace.h
> > +++ b/include/trace/ftrace.h
> > @@ -471,7 +471,7 @@ static void ftrace_raw_event_##call(proto)				\
> >  		return;							\
> >  	entry	= ring_buffer_event_data(event);			\
> >  									\
> > -	assign;								\
> > +	{ assign; }							\
> >  									\
> >  	if (!filter_current_check_discard(event_call, entry, event))	\
> >  		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
> > -- 
> > 1.5.4.rc3
> > 
> > 
> > 

