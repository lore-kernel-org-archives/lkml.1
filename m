Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0BJKEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:04:52 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:51466 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab0BJKEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:04:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qJT1FhQr3htm8J63/g0KZPJUzLy2nti/aQRTckOlDkO8H/NwPx4gBAHBrecwZzHlwq
         lg5p4xPyJ9Of1wmaKAeveqeaUYyLG94vsUL4qrdFLw6mFFfLeX2nGyIDA6tdZBqejij/
         wR+wsOqk7zRq1x7nJo7SYoLqYZE5FpAF2EVqk=
Date: Wed, 10 Feb 2010 11:04:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 02/11] tracing: Introduce TRACE_EVENT_INJECT
Message-ID: <20100210100440.GA5035@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com> <1265188475-23509-3-git-send-regression-fweisbec@gmail.com> <1265381266.24386.32.camel@gandalf.stny.rr.com> <1265381604.22001.682.camel@laptop> <1265382452.24386.38.camel@gandalf.stny.rr.com> <20100206122004.GF5062@nowhere> <1265462370.4561.12179.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265462370.4561.12179.camel@frodo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 08:19:30AM -0500, Steven Rostedt wrote:
> On Sat, 2010-02-06 at 13:20 +0100, Frederic Weisbecker wrote:
> 
> > I agree with you that creating a new trace event macro is a bit
> > insane. ftrace.h is already a nightmare. I just thought that
> > having the injector set inside the same macro that the synchronous
> > event is defined helped to make it clear about its nature: that
> > it needs a secondary async catch up thing.
> > 
> > But a register_event_injector thing will work too, we probably
> > better want that, given the maintainance pain otherwise.
> 
> We can add a register_event_injector later. For now, why not just add
> the TRACE_EVENT() and then hook to it in perf using the normal
> tracepoint mechanism.
> 
> You could add some macro around the trace_init_lock_class() call that
> would facilitate finding all the locks you need. This would probably be
> a bit more straight forward than to overload TRACE_EVENT() again.



I'm not sure what you mean by that.


 
> > 
> > I really would like to make something useful for everyone, could
> > you tell me more about johill needs?
> 
> Well, basically he needed a way to cause polling to happen using an
> event. From what I understood, the polling called the trace point. Just
> enabling the trace point did nothing because the polling did not take
> place. I thought about ways to enable this command when the trace point
> was enabled. But in the end, it was specific to a driver and another
> debugfs file seemed a better fit to initiate it.


Ok, thanks.

