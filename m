Return-Path: <linux-kernel-owner+w=401wt.eu-S932510AbZHUUIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbZHUUIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932299AbZHUUIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:08:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbZHUUIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:08:00 -0400
Date: Fri, 21 Aug 2009 16:06:44 -0400
From: Jason Baron <jbaron@redhat.com>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH v2 1/2] tracing: Move tracepoint callbacks into DEFINE
Message-ID: <20090821200644.GA7099@redhat.com>
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250795373-32363-1-git-send-email-jistone@redhat.com> <20090821175212.GA2684@redhat.com> <4A8EF6C4.9010708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8EF6C4.9010708@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 12:34:28PM -0700, Josh Stone wrote:
> On 08/21/2009 10:52 AM, Jason Baron wrote:
> > this means that when CONFIG_EVENT_TRACING is set, the 'generic' syscall
> > enter/exit will show up as events in the debugfs, but enabling them
> > wouldn't do anything. I think we should simply drop the
> > 'CONFIG_FTRACE_SYSCALLS' 'ifdef' and 'else' clause. That will give us
> > what we want - tying these callbacks directly to tracepoint.
> 
> But only x86 and s390 have TIF_SYSCALL_FTRACE, while kernel/tracepoint.c
> must still compile everywhere that has CONFIG_TRACEPOINTS=y.
> 

ok.

> Maybe it would be better to make that #ifdef TIF_SYSCALL_FTRACE, and
> then also #ifdef the TRACE_EVENT declaration, so it will only show up on
> kernels that actually support it.
> 

hmm...maybe then we move these functions to an arch specific file, such
as arch/x86{s390}/kernel/ftrace.c, making the code contigent on
CONFIG_TRACEPOINTS? (I think that required less ifdefs...).

> Also, since this event is now usable outside of ftrace, would you object
> to renaming the flag TIF_SYSCALL_TRACEPOINT?
> 

sure.

thanks,

-Jason
