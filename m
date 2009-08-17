Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbZHQXJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbZHQXJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbZHQXJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:09:30 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:36371 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZHQXJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mCTAFfwvcvAtRAxnC/0isoDCPDDfgyF4sYnBGsXFDb3ecpgKe0dWlAabGxm1YvCXua
         MBLeB2RB1FhbWVatFuuAK1IHwbYN7At2F/jCKnG9ZPt3/Gzq6V+047UM0LSeZYYE+hlD
         aVUfw6ptrNfdRnVN+CHWzN2WtmJEx3qBWdoWk=
Date: Tue, 18 Aug 2009 01:09:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH 07/12] add ftrace_event_call void * 'data' field
Message-ID: <20090817230926.GC4962@nowhere>
References: <cover.1249932670.git.jbaron@redhat.com> <2f63f892c862efd4f58f9d3e72cb5bc55f2d0025.1249932670.git.jbaron@redhat.com> <20090811100904.GA4938@nowhere> <alpine.DEB.2.00.0908171818420.25890@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908171818420.25890@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 06:19:33PM -0400, Steven Rostedt wrote:
> 
> On Tue, 11 Aug 2009, Frederic Weisbecker wrote:
> 
> > On Mon, Aug 10, 2009 at 04:52:44PM -0400, Jason Baron wrote:
> > > add an optional * void pointer to 'ftrace_event_call' that is
> > > passed in for regfunc and unregfunc.
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > 
> > > ---
> > >  include/linux/ftrace_event.h |    5 +++--
> > >  include/trace/ftrace.h       |    4 ++--
> > >  kernel/trace/trace_events.c  |    4 ++--
> > >  3 files changed, 7 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> > > index ac8c6f8..8544f12 100644
> > > --- a/include/linux/ftrace_event.h
> > > +++ b/include/linux/ftrace_event.h
> > > @@ -112,8 +112,8 @@ struct ftrace_event_call {
> > >  	struct dentry		*dir;
> > >  	struct trace_event	*event;
> > >  	int			enabled;
> > > -	int			(*regfunc)(void);
> > > -	void			(*unregfunc)(void);
> > > +	int			(*regfunc)(void *);
> > > +	void			(*unregfunc)(void *);
> > >  	int			id;
> > >  	int			(*raw_init)(void);
> > >  	int			(*show_format)(struct trace_seq *s);
> > > @@ -122,6 +122,7 @@ struct ftrace_event_call {
> > >  	int			filter_active;
> > >  	struct event_filter	*filter;
> > >  	void			*mod;
> > > +	void			*data;
> > >  
> > >  	atomic_t		profile_count;
> > >  	int			(*profile_enable)(struct ftrace_event_call *);
> > > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > > index 80e5f6c..a0de384 100644
> > > --- a/include/trace/ftrace.h
> > > +++ b/include/trace/ftrace.h
> > > @@ -568,7 +568,7 @@ static void ftrace_raw_event_##call(proto)				\
> > >  		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
> > >  }									\
> > >  									\
> > > -static int ftrace_raw_reg_event_##call(void)				\
> > > +static int ftrace_raw_reg_event_##call(void *ptr)			\
> > 
> > 
> > Shouldn't it have a __used attribute here, or something?
> 
> Do function parameters need that? There's lots of places where the 
> parameter of a function is not used by a function itself.
> 
> -- Steve


No actually, I thought gcc would warn, but it didn't :-)


