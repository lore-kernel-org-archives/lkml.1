Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbZEHBXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbZEHBXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZEHBXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:23:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49894 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbZEHBXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:23:20 -0400
Date: Thu, 7 May 2009 21:23:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] tracing: add hierarchical enabling of events
In-Reply-To: <4A0386A8.6030501@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905072120580.28378@gandalf.stny.rr.com>
References: <20090507031335.815354104@goodmis.org> <20090507031434.807772092@goodmis.org> <4A025AAC.2000201@cn.fujitsu.com> <alpine.DEB.2.00.0905070912120.32734@gandalf.stny.rr.com> <4A0386A8.6030501@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 May 2009, Li Zefan wrote:

> >> Like this:
> >>
> >> $ cat events/irq/enable
> >> 0 irq_handler_entry
> >> 0 irq_handler_exit
> >> 1 softirq_entry
> >> 1 softirq_exit
> > 
> > I thought about doing something like this, but this idea for the 
> > hierarchical enabling came to me around 11pm, and I had the code written 
> > by 11:15pm ;-)
> > 
> > Which means, I figured I would do it as simple as possible. We do have 
> > "set_event" that gives you a list of enabled events. My thought was still 
> > having a "1" or "0" if all are either enabled or disabled. And when it is 
> > a mixture, I would have a list of enabled events.
> > 
> > Though, it is useful. Maybe in the future. But really, the information is 
> > there, and I did not expect this to be a "what is enabled" file, but 
> > instead a "I want to enable/disable all these events". In other words, I 
> > was much more interested in the "write" ability than the read. But who 
> > knows, maybe this will change in the future.
> > 
> 
> I have no strong opinion on this. So I'm fine with it, if
> no one else has objections.
> 
> >> How about:
> >>
> >> int set = 0;
> >>
> >> ...
> >> set |= (1 << call->enabled);
> > 
> > * paranoid *
> > 
> >   set |= (1 << !!call->enabled);
> > 
> >> ...
> >>
> >> set == 0: '?'
> >> set == 1: '0'
> >> set == 2: '1'
> >> set == 3: 'X'
> >>
> >> Will this make the code simpler? :)
> >>
> >> Or we can go even further:
> >>
> >> char result[4] = { '?', '0', '1', 'X' };
> >> ...
> >> buf[0] = result[set];
> > 
> > cute, mind sending a patch ;-)
> > 
> 
> Sure. :)

Great, looking forward to it.

> 
> >>> +	ret = ftrace_set_clr_event(command, val);
> >> I think we should pass "sched:" or "sched:*", instead of "sched",
> >> the comment in ftrace_set_clr_event():
> >>
> >>          *  <name> (no ':') means all events in a subsystem with
> >>          *  the name <name> or any event that matches <name>
> > 
> > Yeah, I thought about it too. But writing the patch in 15 minutes, I 
> > decided that a "kstrdup" was easier than adding a ":" ;-)
> > 
> 
> I think we can just avoid any kstrdup() or kmalloc(). I'll send a patch.

Hmm, careful. The ftrace_set_clr_event will modify the string passed in.

-- Steve

