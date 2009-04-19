Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbZDSMgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbZDSMgL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 08:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756986AbZDSMf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 08:35:56 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:42594 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169AbZDSMfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 08:35:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KFpnW18+VGolQBy8qzFb605akq3saeFGlvPNS1Bx+2UVPbh2K7dDqzQhQwLN8rSuaP
         dza0/+unhuP8wJYr54//eXXk/E4fzxaQVkwTCKOdZNKZ1cXppSVE+5JVay2jgiXDKUMX
         UeCzTbftCkstyAtAsu8aklf09giLFAQkq+WLA=
Date: Sun, 19 Apr 2009 14:35:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2 v3] tracing/events: provide string with undefined
	size support
Message-ID: <20090419123550.GB5967@nowhere>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <1240117295-6873-2-git-send-email-fweisbec@gmail.com> <49EAC188.1040409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EAC188.1040409@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 02:15:36PM +0800, Li Zefan wrote:
> > @@ -417,18 +495,22 @@ static struct ftrace_event_call event_##call;				\
> >  									\
> >  static void ftrace_raw_event_##call(proto)				\
> >  {									\
> > +	struct ftrace_str_offsets_##call __maybe_unused __str_offsets;  \
> >  	struct ftrace_event_call *call = &event_##call;			\
> >  	struct ring_buffer_event *event;				\
> >  	struct ftrace_raw_##call *entry;				\
> >  	unsigned long irq_flags;					\
> > +	int __str_size = 0;						\
> >  	int pc;								\
> >  									\
> >  	local_save_flags(irq_flags);					\
> >  	pc = preempt_count();						\
> >  									\
> > +	tstruct;							\
> > +									\
> >  	event = trace_current_buffer_lock_reserve(event_##call.id,	\
> > -				  sizeof(struct ftrace_raw_##call),	\
> > -				  irq_flags, pc);			\
> > +				 sizeof(struct ftrace_raw_##call) + __str_size,\
> 
> sizeof(*entry) will make it much shorter. ;)


Heh, you're right :-)
I will update that.


> 
> > +				 irq_flags, pc);			\
> >  	if (!event)							\
> >  		return;							\
> >  	entry	= ring_buffer_event_data(event);			\
> 

