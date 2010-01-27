Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710Ab0A0JhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab0A0JhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440Ab0A0JhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:37:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49251 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab0A0JhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:37:21 -0500
Date: Wed, 27 Jan 2010 10:37:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Subject: Re: [PATCH 0/5][GIT PULL][v2.6.33] tracing: fixes and documentation
 updates
Message-ID: <20100127093704.GB8596@elte.hu>
References: <20100126220923.534282809@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126220923.534282809@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I found that reading the trace file and the raw_trace_pipe using splice, at 
> the same time could cause a kernel oops. Not a major one, that is, the oops 
> only crashes the user task that is performing the read of the trace file. 
> But still urgent enough to go into 2.6.33.
> 
> The issue is with the iterator that is stored to access multiple reads of 
> the ring buffer without consuming the data. If a user process starts reading 
> the contents of the ring buffer with the iterator, and in the mean time a 
> consuming read is done, then the iterator can become stale and return a 
> bogus entry.
> 
> The first patch fixes the pid to cmdline mapping function to not crash when 
> given a negative pid (which happened when we had a bogus entry).
> 
> The next two patches fix the ring buffer to detect when a consuming
> read is done and to reset the iterator.
> 
> Since I'm pushing these patches up, I've also incuded two
> documentation changes. One of the patches touches a Kconfig file
> but only the help portion of it.
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Mike Frysinger (1):
>       tracing/documentation: Cover new frame pointer semantics
> 
> Steven Rostedt (3):
>       tracing: Prevent kernel oops with corrupted buffer
>       ring-buffer: Check if ring buffer iterator has stale data
>       ring-buffer: Check for end of page in iterator
> 
> Yang Hongyang (1):
>       tracing/documentation: Fix a typo in ftrace.txt
> 
> ----
>  Documentation/trace/ftrace-design.txt |   26 +++++++++++++++++++++++---
>  Documentation/trace/ftrace.txt        |    2 +-
>  kernel/trace/Kconfig                  |    4 +---
>  kernel/trace/ring_buffer.c            |   24 +++++++++++++++++++++---
>  kernel/trace/trace.c                  |    5 +++++
>  5 files changed, 51 insertions(+), 10 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
