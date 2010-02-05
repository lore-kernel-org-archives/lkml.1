Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab0BEOos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:44:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab0BEOor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:44:47 -0500
X-Authority-Analysis: v=1.0 c=1 a=45efoH4BFn8A:10 a=7U3hwN5JcxgA:10 a=9Z1gkl8m1grKNVAiKDEA:9 a=va_0jIROo2jyHueNLpvwXh9H94oA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 03/11] tracing: Inject lock_class_init events on
 registration
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1265380207.22001.654.camel@laptop>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
	 <1265188475-23509-4-git-send-regression-fweisbec@gmail.com>
	 <1265379199.24386.26.camel@gandalf.stny.rr.com>
	 <1265380207.22001.654.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 05 Feb 2010 09:44:44 -0500
Message-ID: <1265381084.24386.30.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 15:30 +0100, Peter Zijlstra wrote:
> On Fri, 2010-02-05 at 09:13 -0500, Steven Rostedt wrote:

> > register_event_callback("event", "command", command_func, 
> > 		command_enable_func,
> > 		command_disable_func);
> > 
> > Where command_func, command_enable_func and command_disable_func can all
> > be a function pointer or NULL.
> > 
> > command_func gets called every time the event is hit while enabled.
> > 
> > command_enable_func gets called when the event is enabled
> > 
> > command_disable_func gets called when the event is disabled.
> 
> Well, that will solve johill's polling thing, but not work nicely with
> the proposed collection iteration stuff.
> 

Actually, johill and I decided that this was not the proper solution for
him ;-)

I wanted to do this so we could add a lot more functionality and
flexibility to events. Start the tracer when this event is hit, stop in
on that event, but only when the filters match. Things like that. And
I'm sure people could come up with much better and more imaginative
commands that would be useful for tracing.

What does not fit with this proposal? I really hate adding more macros
for every new feature or functionality we need. It is ugly and will
become a maintenance nightmare.

-- Steve




