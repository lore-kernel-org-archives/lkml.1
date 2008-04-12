Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbYDLEZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbYDLEZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 00:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbYDLEZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 00:25:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbYDLEZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 00:25:04 -0400
Date: Fri, 11 Apr 2008 21:24:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <menage@google.com>, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc8-mm2 -- kernel/sched.c:8294: error: unknown field
 =?UTF-8?Q?=E2=80=98read=5Fuint=E2=80=99?= specified in initializer
Message-Id: <20080411212403.a9d863fa.akpm@linux-foundation.org>
In-Reply-To: <1207940124.7427.1.camel@twins>
References: <a44ae5cd0804110648g3256805fob917f31eeff4f6db@mail.gmail.com>
	<1207932902.7157.4.camel@twins>
	<6599ad830804111146k2c3db442y3708f95a3fbee83@mail.gmail.com>
	<1207940124.7427.1.camel@twins>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 20:55:24 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2008-04-11 at 11:46 -0700, Paul Menage wrote:
> > On Fri, Apr 11, 2008 at 9:55 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Fri, 2008-04-11 at 09:48 -0400, Miles Lane wrote:
> > >  > CC      kernel/sched.o
> > >  > kernel/sched.c:8294: error: unknown field 'read_uint' specified in initializer
> > >  > kernel/sched.c:8294: warning: initialization makes integer from
> > >  > pointer without a cast
> > >  > kernel/sched.c:8295: error: unknown field 'write_uint' specified in initializer
> > >  > kernel/sched.c:8295: warning: initialization from incompatible pointer type
> > >
> > >  someone mucked around with the cgroup api; this should fix it:
> > >
> > >  Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > >  ---
> > >  diff --git a/kernel/sched.c b/kernel/sched.c
> > >  index 7119895..8b4e0b6 100644
> > >  --- a/kernel/sched.c
> > >  +++ b/kernel/sched.c
> > >  @@ -8291,8 +8291,8 @@ static struct cftype cpu_files[] = {
> > >         },
> > >         {
> > >                 .name = "rt_period_us",
> > >  -               .read_uint = cpu_rt_period_read_uint,
> > >  -               .write_uint = cpu_rt_period_write_uint,
> > >  +               .read_u64 = cpu_rt_period_read_uint,
> > >  +               .write_u64 = cpu_rt_period_write_uint,
> > >         },
> > >   #endif
> > >
> > 
> > Sorry - this change was in my original API patch (plus renaming the
> > read/write functions to have u64 suffices) but I think it collided
> > with the git-sched instability around the end of February.
> 
> Yeah, no worries, I recognised it the moment I looked at it. This is
> just a merge artefact from changes in different trees.

Yeahm, this is poor old me trying to herd a million mad monkeys, only one
escaped.

Not enough .configs, I guess :(
