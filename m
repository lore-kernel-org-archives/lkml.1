Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbZHXUMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbZHXUMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbZHXUMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:12:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:15226 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZHXUMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pq69bnUrIo4Zyy7fQRVZlQqtwMzunx2cDcH71keOLsSH2uW8EYADiZxiBMezkk9qWx
         3iYaumJsoxb8g4hUsZmtQU51wLo9Hgc4Llk93rndynKeFQcfWEe0LklVe9DWqSjh8dYe
         CrENpUWQD83LTul0uzvcnimG7mlV9o5W5TTCc=
Date: Mon, 24 Aug 2009 22:12:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
Message-ID: <20090824201209.GB5050@nowhere>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere> <4A92EA8E.8020400@redhat.com> <20090824195759.GA5050@nowhere> <4A92F157.9040709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A92F157.9040709@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 01:00:23PM -0700, Josh Stone wrote:
> On 08/24/2009 12:58 PM, Frederic Weisbecker wrote:
> > On Mon, Aug 24, 2009 at 12:31:26PM -0700, Josh Stone wrote:
> >> On 08/23/2009 02:14 PM, Frederic Weisbecker wrote:
> >>> I really don't like that.
> >>> See how the s390 and x86 version of the above code are completely
> >>> identical?
> >>>
> >>> Please put this in kernel/ptrace.c
> >>
> >> Yes, I see your point, and I think kernel/ptrace.c is a fine place for
> >> it.  Making it conditional on CONFIG_TRACEPOINTS and
> >> CONFIG_HAVE_FTRACE_SYSCALLS is probably best too, though I think the
> >> latter should now be HAVE_SYSCALL_TRACEPOINTS.
> > 
> > 
> > As you prefer, this new name can be indeed more verbose.
> 
> Actually, now I'm second-guessing the need to move these at all.  Since
> they only make sense for CONFIG_TRACEPOINTS, can't they stay in
> kernel/tracepoint.c and just be conditional on HAVE_SYSCALL_TRACEPOINTS?
>  The only real change needed is for the tracepoint declarations to also
> be conditional.
> 
> Josh
> 

Both ways make sense to me, although I generally see the role of
kernel/tracepoint.c to only host the general core tracepoints mechanism.

And here these two callbacks are more about specific tracepoints coverage,
somewhat tied to the ptrace background because we are using a ptrace
bridge to reach these tracepoints.

Well, either ways look good:

- tracepoint.c: to solve the lack of a functionnality in very
  specific cases.

- ptrace.c: because it's part of a ptrace mechanism.


I don't feel strongly about that :-)

