Return-Path: <linux-kernel-owner+w=401wt.eu-S934125AbZHWU3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125AbZHWU3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 16:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934115AbZHWU3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 16:29:42 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:50112 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934114AbZHWU3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 16:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pWa/GkYSG9hZJgJUH6ifNVSUhbCNFKSSm/DL6xxrEl24Zt/byXDcQK5QUWSO3Ia0qS
         T8yCbiBbvjCCKPROdC0GJ/Lk8Yn5VdBEenczsVT0lY9XmSgbExSc8YjUEsprbxRgyKYf
         aMLhm7uaBv6snLDoXfRWqNGGnQFJJTOh586K8=
Date: Sun, 23 Aug 2009 22:29:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH v2 1/2] tracing: Move tracepoint callbacks into DEFINE
Message-ID: <20090823202939.GF6256@nowhere>
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250795373-32363-1-git-send-email-jistone@redhat.com> <20090821175212.GA2684@redhat.com> <4A8EF6C4.9010708@redhat.com> <20090821200644.GA7099@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821200644.GA7099@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 04:06:44PM -0400, Jason Baron wrote:
> On Fri, Aug 21, 2009 at 12:34:28PM -0700, Josh Stone wrote:
> > On 08/21/2009 10:52 AM, Jason Baron wrote:
> > > this means that when CONFIG_EVENT_TRACING is set, the 'generic' syscall
> > > enter/exit will show up as events in the debugfs, but enabling them
> > > wouldn't do anything. I think we should simply drop the
> > > 'CONFIG_FTRACE_SYSCALLS' 'ifdef' and 'else' clause. That will give us
> > > what we want - tying these callbacks directly to tracepoint.
> > 
> > But only x86 and s390 have TIF_SYSCALL_FTRACE, while kernel/tracepoint.c
> > must still compile everywhere that has CONFIG_TRACEPOINTS=y.
> > 
> 
> ok.
> 
> > Maybe it would be better to make that #ifdef TIF_SYSCALL_FTRACE, and
> > then also #ifdef the TRACE_EVENT declaration, so it will only show up on
> > kernels that actually support it.
> > 
> 
> hmm...maybe then we move these functions to an arch specific file, such
> as arch/x86{s390}/kernel/ftrace.c, making the code contigent on
> CONFIG_TRACEPOINTS? (I think that required less ifdefs...).


But the code of these functions is generic and should then keep beeing
factorized.

We could put them in kernel/trace/trace_syscalls.c and keep ftrace related
things inside CONFIG_TRACE_SYSCALLS and the above inside
CONFIG_TRACEPOINT + CONFIG_HAVE_SYSCALL_TRACING (then also change
the Makefile).

Or if you find that too dirty, may be create a separate file in kernel/trace/.


> 
> > Also, since this event is now usable outside of ftrace, would you object
> > to renaming the flag TIF_SYSCALL_TRACEPOINT?
> > 
> 
> sure.
> 
> thanks,
> 
> -Jason

