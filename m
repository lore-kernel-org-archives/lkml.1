Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZFJBax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZFJBax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZFJBaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:30:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42031 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbZFJBaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:30:46 -0400
Date: Wed, 10 Jun 2009 03:30:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing/events/ring-buffer: block trace
	points and fix
Message-ID: <20090610013037.GA30032@elte.hu>
References: <20090609163657.557589106@goodmis.org> <20090609234655.GA24118@elte.hu> <4A2F0C4A.8020109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A2F0C4A.8020109@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> >> Ingo,
> >>
> >> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> >> tip/tracing/ftrace
> >>
> >>
> >> Li Zefan (1):
> >>       tracing/events: convert block trace points to TRACE_EVENT()
> >>
> >> Steven Rostedt (1):
> >>       ring-buffer: fix ret in rb_add_time_stamp
> >>
> >> ----
> >>  block/blk-core.c             |   16 +-
> >>  block/elevator.c             |    8 +-
> >>  drivers/md/dm.c              |    5 +-
> >>  fs/bio.c                     |    3 +-
> >>  include/linux/blktrace_api.h |   13 ++
> >>  include/trace/block.h        |   76 -------
> >>  include/trace/events/block.h |  483 ++++++++++++++++++++++++++++++++++++++++++
> >>  kernel/trace/Makefile        |    5 +-
> >>  kernel/trace/blktrace.c      |   78 +++++++-
> >>  kernel/trace/ring_buffer.c   |    2 +-
> >>  mm/bounce.c                  |    5 +-
> >>  11 files changed, 589 insertions(+), 105 deletions(-)
> > 
> > I'm getting some build failures here:
> > 
> > In file included from mm/highmem.c:30:
> > include/linux/blktrace_api.h:223: warning: ‘struct request’ declared inside parameter list
> > include/linux/blktrace_api.h:223: warning: its scope is only this definition or declaration, which is probably not what you want
> > include/linux/blktrace_api.h: In function ‘blk_cmd_buf_len’:
> > include/linux/blktrace_api.h:225: error: implicit declaration of function ‘blk_pc_request’
> > include/linux/blktrace_api.h:225: error: dereferencing pointer to incomplete type
> > include/linux/blktrace_api.h: At top level:
> > include/linux/blktrace_api.h:228: warning: ‘struct request’ declared inside parameter list
> > include/linux/blktrace_api.h:230: warning: ‘struct request’ declared inside parameter list
> > distcc[15629] ERROR: compile mm/highmem.c on a/32 failed
> > 
> 
> I've fixed it. I'll post a new version after I've done some
> more building tests.

Please post a delta fix as Steve's already committed it.

	Ingo
