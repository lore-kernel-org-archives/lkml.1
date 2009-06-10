Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZFJBcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZFJBcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZFJBcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:32:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59662 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZFJBb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:31:59 -0400
Date: Tue, 9 Jun 2009 21:31:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing/events/ring-buffer: block trace
 points and fix
In-Reply-To: <4A2F0C4A.8020109@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0906092131190.30552@gandalf.stny.rr.com>
References: <20090609163657.557589106@goodmis.org> <20090609234655.GA24118@elte.hu> <4A2F0C4A.8020109@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Li Zefan wrote:

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
> > include/linux/blktrace_api.h:223: warning: ?struct request? declared inside parameter list
> > include/linux/blktrace_api.h:223: warning: its scope is only this definition or declaration, which is probably not what you want
> > include/linux/blktrace_api.h: In function ?blk_cmd_buf_len?:
> > include/linux/blktrace_api.h:225: error: implicit declaration of function ?blk_pc_request?
> > include/linux/blktrace_api.h:225: error: dereferencing pointer to incomplete type
> > include/linux/blktrace_api.h: At top level:
> > include/linux/blktrace_api.h:228: warning: ?struct request? declared inside parameter list
> > include/linux/blktrace_api.h:230: warning: ?struct request? declared inside parameter list
> > distcc[15629] ERROR: compile mm/highmem.c on a/32 failed
> > 
> 
> I've fixed it. I'll post a new version after I've done some
> more building tests.

Ingo,

Should Li post a delta fix, or should we just rebase?

-- Steve

