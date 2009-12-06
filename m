Return-Path: <linux-kernel-owner+w=401wt.eu-S933754AbZLFLw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754AbZLFLw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 06:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933723AbZLFLwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 06:52:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53294 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933722AbZLFLwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 06:52:24 -0500
Date: Sun, 6 Dec 2009 12:50:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf/sched: fix for getting task's execute time
Message-ID: <20091206115040.GB871@elte.hu>
References: <4B1B8E0E.3040007@cn.fujitsu.com>
 <1260097512.7818.341.camel@laptop>
 <1260097609.7818.349.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260097609.7818.349.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2009-12-06 at 12:05 +0100, Peter Zijlstra wrote:
> > On Sun, 2009-12-06 at 18:57 +0800, Xiao Guangrong wrote:
> > > In current code, we get task's execute time by reading
> > > "/proc/<pid>/sched" file, it's wrong if the task is created
> > > by pthread_create(), because every thread task has same pid.
> > > So, the correct way is reading "/proc/<ppid>/task/<tid>/sched"
> > > file.
> > > 
> > > This patch also remove redundant include files since <sys/types.h>
> > > is included in "perf.h"
> > 
> > We really should not be using these proc files but instead make sure
> > this information gets transferred through a tracepoint or similar.
> > 
> > Reading these proc files is too prone to races.

yeah. Ideally we'd want all valuable information that is available via 
/proc to be available via perf events as well. In the future it should 
be possible to run perf even without /proc mounted for example.

Furthermore it's good for consistency and simplicity as well, plus it's 
faster too to get the information from the perf syscall and mmap-ed 
ringbuffer than to read things via /proc. No need for ASCII conversion, 
fixed record formats, fast streaming and buffering, no read() overhead, 
etc.

> We can probably get the runtime by grouping a task-clock swcounter 
> with an appropriate other event.

Would be lovely.

	Ingo
