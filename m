Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZKEGAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZKEGAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZKEGAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:00:10 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:44215 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZKEGAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:00:08 -0500
Date: Thu, 5 Nov 2009 11:30:08 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf events
Message-ID: <20091105060008.GA3261@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-5-git-send-email-fweisbec@gmail.com> <19186.5488.320389.567026@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19186.5488.320389.567026@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 10:59:44AM +1100, Paul Mackerras wrote:
> Frederic Weisbecker writes:
> 
> > This patch rebase the implementation of the breakpoints API on top of
> > perf events instances.
> > 
> > Each breakpoints are now perf events that handle the
> > register scheduling, thread/cpu attachment, etc..
> 
> What I haven't managed to understand yet is how you provide reliable
> breakpoints for debugging purposes.  If I'm debugging a program and I
> have set a breakpoint, I'll be very unhappy if the breakpoint should
> trigger but doesn't because the perf_event infrastructure has decided
> it can't schedule that breakpoint in.  If the breakpoint isn't going
> to work then I want to know that at the time that I set it.
>

The hw-breakpoint layer avoids such issues by not over-committing debug
registers i.e. 'n' number of debug registers are reserved for user-space
where n = max(no. of breakpoints requested by any given process/thread).
And book-keeping certainly helps here too.

Thanks,
K.Prasad
 
