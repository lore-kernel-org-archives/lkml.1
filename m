Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYLOBwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYLOBwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 20:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYLOBvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 20:51:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51454 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYLOBvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 20:51:53 -0500
Date: Mon, 15 Dec 2008 10:50:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
Message-Id: <20081215105053.89263708.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4945B546.5040301@cn.fujitsu.com>
References: <494234B0.5@cn.fujitsu.com>
	<20081212100044.GB18152@elte.hu>
	<4944754F.8050503@cn.fujitsu.com>
	<1229258890.17130.9.camel@lappy.programming.kicks-ass.net>
	<6599ad830812141347k5d7e7e08vfc17855ea0ac981c@mail.gmail.com>
	<4945B546.5040301@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008 09:39:18 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Paul Menage wrote:
> > I sent out some patches last week (search for hierarchy_mutex) that would
> > mean that you'd only need to take a subsystem-local lock to keep a cgroup
> > alive. People seemed to like them so I'll tweak them based on feedback and
> > send them on to Andrew.
> > 
> 
> Unfortunately, AFAICS the proposed hierarchy_mutex can't solve this bug. :(
> 
Hmm ? how about this way if cgroup->dentry is problem ?

at creation:
  - cpu_cgroup_populate() should record "tg" that "this cgroup has valid dentry"
at deletion
  - css_tryget() will be useful to avoid the race.

thx,
-Kame

> > Paul
> > 
> > On Dec 14, 2008 4:48 AM, "Peter Zijlstra" <a.p.zijlstra@chello.nl> wrote:
> > 
> > On Sun, 2008-12-14 at 10:54 +0800, Li Zefan wrote: > > i merged it up in
> > tip/master, could you pleas...
> > Can't we detect a dead task-group and skip those instead of adding this
> > global lock?
> > 
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com> > --- > kernel/sched_fair.c
> > | 6 ++++++ > kerne...
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

