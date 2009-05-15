Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZEOCRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZEOCRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 22:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbZEOCRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 22:17:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53345 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbZEOCRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 22:17:24 -0400
Message-ID: <4A0CD0F1.5020208@cn.fujitsu.com>
Date: Fri, 15 May 2009 10:18:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] tracing: adding flags to events
References: <alpine.DEB.2.00.0905141535360.30591@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905141535360.30591@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Christoph has been asking about processing flags in the output. He rather 
> not see c2, and rather see what those three bits are. This patch is 
> an RFC to do just that. To test it out, I added the previous task state to 
> sched switch and used the flag processing to the printk of the 
> sched_switch event.
> 
> 
> To add a flag, just add __print_flags to the TP_printk arguments.
> 
> 	TP_STRUCT__entry(
> 		__field(	unsigned int,	flags		)
> 	),
> 
> 	TP_printk("flags are %s", __print_flags(__entry->flags,
> 			0, "BIT0", 1, "BIT1", 2, "BIT2", -1))
> 
> 
> Thus __print_flags prototype would look like:
> 
> const char *__print_flags(long flags, ...);
> 

How about __print_flags(long flags, char *delim, ...); ?

Take file mode for example, the output will be "rwx", but not "r|w|x".

> But it is actually converted to other helper functions to handle the 
> string. The trick that ftrace does, is disables preemption before calling 
> the printk, uses a percpu buffer, and passes that in to a helper function 
> that will print out the flags.
> 
>  You could see "flags are BIT1|BIT2"  if flags was 6 in the above case.
> 


