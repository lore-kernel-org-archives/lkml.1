Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab0BKS54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:57:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:14200 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab0BKS5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:57:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Mxx3GoJI3ZdYd1wL2K7L0+K0003ucqTJGYN3zDPX244rsHVEyHTJCENnfgfrR6ZY2A
         BhevRSd19OAhOc6hw7ax4oOBZbaI6LLqy5uXn4g/jNW70UB/F9jztnZZqvK8Abd38Rgs
         qfKlGraSroCXQlsDOQDscrB2XOwv5uA7hspBA=
Date: Thu, 11 Feb 2010 19:57:48 +0100
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
Message-ID: <20100211185744.GD4915@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com> <1265188475-23509-3-git-send-regression-fweisbec@gmail.com> <1265381266.24386.32.camel@gandalf.stny.rr.com> <1265381604.22001.682.camel@laptop> <1265382452.24386.38.camel@gandalf.stny.rr.com> <20100206122004.GF5062@nowhere> <1265462370.4561.12179.camel@frodo> <20100210100440.GA5035@nowhere> <1265810706.24386.58.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265810706.24386.58.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 09:05:06AM -0500, Steven Rostedt wrote:
> On Wed, 2010-02-10 at 11:04 +0100, Frederic Weisbecker wrote:
> 
> > > We can add a register_event_injector later. For now, why not just add
> > > the TRACE_EVENT() and then hook to it in perf using the normal
> > > tracepoint mechanism.
> > > 
> > > You could add some macro around the trace_init_lock_class() call that
> > > would facilitate finding all the locks you need. This would probably be
> > > a bit more straight forward than to overload TRACE_EVENT() again.
> > 
> > 
> > 
> > I'm not sure what you mean by that.
> 
> Looking back at where trace_lock_class_init() was placed, you don't need
> a wrapper. But instead, why not just have perf hook directly into the
> trace_lock_class_init trace point, and do its injection directly.
> Instead of needing to add some hack to TRACE_EVENT()?


We could. But we expect further events may need such catch-up by
injection system. And ftrace will also need to perform this injection.

That's why I think something more generic would be more reasonable.

