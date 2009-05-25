Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZEYIcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZEYIcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZEYIcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:32:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:36302 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZEYIcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AzciCKUFpT0NEy7Y0fLuElN6uFLhtREjIMMKavX+wtIwMRNBsFrNsI6emF8KpWZYhL
         Yoiq4RQE7rC+mWltDz6OE1wi92T78nUHabme5auwpMOGZNXTrH9JlPwKhhW6Hw3vJCWb
         4JBj4nGJBhPKwLCDN3bNJnWvT5gAYwllAtiEU=
Date: Mon, 25 May 2009 10:32:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH v2 2/2] ftrace: clean up of using
	ftrace_event_enable_disable()
Message-ID: <20090525083207.GB6215@nowhere>
References: <4A14FDFE.2080402@cn.fujitsu.com> <4A16788F.2060802@cn.fujitsu.com> <4A16791C.8090501@cn.fujitsu.com> <20090524204620.GC6471@nowhere> <4A1A2DE2.6000304@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1A2DE2.6000304@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 01:34:26PM +0800, Zhaolei wrote:
> Frederic Weisbecker wrote:
> > On Fri, May 22, 2009 at 06:06:20PM +0800, Zhaolei wrote:
> >> Always use tracing_stop_cmdline_record() to enable/disable a event.
> >>
> >> Impact: cleanup, no functionality changed
> >>
> >> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> >> ---
> >>  kernel/trace/trace_events.c |   44 +++++++++++++-----------------------------
> >>  1 files changed, 14 insertions(+), 30 deletions(-)
> >>
> >> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> >> index df35e5e..16ef47a 100644
> >> --- a/kernel/trace/trace_events.c
> >> +++ b/kernel/trace/trace_events.c
> >> @@ -76,26 +76,9 @@ static void trace_destroy_fields(struct ftrace_event_call *call)
> >>  
> >>  #endif /* CONFIG_MODULES */
> >>  
> >> -static void ftrace_clear_events(void)
> >> -{
> >> -	struct ftrace_event_call *call;
> >> -
> >> -	mutex_lock(&event_mutex);
> >> -	list_for_each_entry(call, &ftrace_events, list) {
> > 
> > 
> > Don't we have a "for_each_event" ?
> 
> Hello, Frederic
> 
> Thanks for your review.
> 
> IMHO, for_each_event is for iter each tracepoints in one module(or kernel),
> but we need to iter whole tracepoints in manage.
> So, list_for_each_entry(call, &ftrace_events, list) maybe better here.
> 
> Thanks
> Zhaolei


Ah yeah, ok.

Thanks.

