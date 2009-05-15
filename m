Return-Path: <linux-kernel-owner+w=401wt.eu-S1761222AbZEOC1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761222AbZEOC1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 22:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZEOC1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 22:27:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43540 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbZEOC1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 22:27:41 -0400
Date: Thu, 14 May 2009 22:27:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] tracing: adding flags to events
In-Reply-To: <4A0CD0F1.5020208@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905142227250.30591@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0905141535360.30591@gandalf.stny.rr.com> <4A0CD0F1.5020208@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 May 2009, Li Zefan wrote:

> Steven Rostedt wrote:
> > Christoph has been asking about processing flags in the output. He rather 
> > not see c2, and rather see what those three bits are. This patch is 
> > an RFC to do just that. To test it out, I added the previous task state to 
> > sched switch and used the flag processing to the printk of the 
> > sched_switch event.
> > 
> > 
> > To add a flag, just add __print_flags to the TP_printk arguments.
> > 
> > 	TP_STRUCT__entry(
> > 		__field(	unsigned int,	flags		)
> > 	),
> > 
> > 	TP_printk("flags are %s", __print_flags(__entry->flags,
> > 			0, "BIT0", 1, "BIT1", 2, "BIT2", -1))
> > 
> > 
> > Thus __print_flags prototype would look like:
> > 
> > const char *__print_flags(long flags, ...);
> > 
> 
> How about __print_flags(long flags, char *delim, ...); ?
> 
> Take file mode for example, the output will be "rwx", but not "r|w|x".

Heh, sure, why not?

-- Steve

