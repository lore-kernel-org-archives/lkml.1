Return-Path: <linux-kernel-owner+w=401wt.eu-S934081AbZHWUPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbZHWUPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 16:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934015AbZHWUPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 16:15:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:28326 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934027AbZHWUPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 16:15:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FmTC+8QUjJsIVdxdAncnRQqRI2fzZKg0CVSCuTELb2iHJF11aOsgJBNIIrkxFWDwDC
         VNQiPm19mnpljv4vdvWBlySA0yGT9ZmduUFfCXEXzhNQiVB64ClDz1dQlUByQ9YdhKWs
         RIPVD/wo/mjk42vnCs8LmOXbN9Psx1IJIyqto=
Date: Sun, 23 Aug 2009 22:15:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Stone <jistone@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH v2 1/2] tracing: Move tracepoint callbacks into DEFINE
Message-ID: <20090823201537.GE6256@nowhere>
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
> Maybe it would be better to make that #ifdef TIF_SYSCALL_FTRACE, and
> then also #ifdef the TRACE_EVENT declaration, so it will only show up on
> kernels that actually support it.


Instead of testing TIF_SYSCALL_FTRACE, I'd suggest testing HAVE_FTRACE_SYSCALLS.
This makes more sense and is more verbose wrt its role in the conditionnal definition,
given its macro name.

 
> Also, since this event is now usable outside of ftrace, would you object
> to renaming the flag TIF_SYSCALL_TRACEPOINT?
> 
> Josh

