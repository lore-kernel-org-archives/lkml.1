Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZKELEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZKELEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbZKELD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:03:58 -0500
Received: from ozlabs.org ([203.10.76.45]:41662 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbZKELDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:03:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19186.45127.262567.839766@cargo.ozlabs.ibm.com>
Date: Thu, 5 Nov 2009 22:00:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: prasad@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <20091105060008.GA3261@in.ibm.com>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
	<1257275474-5285-5-git-send-email-fweisbec@gmail.com>
	<19186.5488.320389.567026@cargo.ozlabs.ibm.com>
	<20091105060008.GA3261@in.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K.Prasad writes:

> On Thu, Nov 05, 2009 at 10:59:44AM +1100, Paul Mackerras wrote:
> > What I haven't managed to understand yet is how you provide reliable
> > breakpoints for debugging purposes.  If I'm debugging a program and I
> > have set a breakpoint, I'll be very unhappy if the breakpoint should
> > trigger but doesn't because the perf_event infrastructure has decided
> > it can't schedule that breakpoint in.  If the breakpoint isn't going
> > to work then I want to know that at the time that I set it.
> >
> 
> The hw-breakpoint layer avoids such issues by not over-committing debug
> registers i.e. 'n' number of debug registers are reserved for user-space
> where n = max(no. of breakpoints requested by any given process/thread).
> And book-keeping certainly helps here too.

Yes, I missed the fact that there was still a little bit of the
hw-breakpoints layer underneath the perf_event layer.  I'm not sure
that what Frederic has now will suit those Power CPUs that have both
an IABR and DABR, but we can fix that later.

Paul.
