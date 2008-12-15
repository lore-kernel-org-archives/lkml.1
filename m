Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbYLOBku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbYLOBku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 20:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYLOBkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 20:40:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63784 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYLOBkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 20:40:39 -0500
Message-ID: <4945B546.5040301@cn.fujitsu.com>
Date: Mon, 15 Dec 2008 09:39:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu>	 <4944754F.8050503@cn.fujitsu.com>	 <1229258890.17130.9.camel@lappy.programming.kicks-ass.net> <6599ad830812141347k5d7e7e08vfc17855ea0ac981c@mail.gmail.com>
In-Reply-To: <6599ad830812141347k5d7e7e08vfc17855ea0ac981c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> I sent out some patches last week (search for hierarchy_mutex) that would
> mean that you'd only need to take a subsystem-local lock to keep a cgroup
> alive. People seemed to like them so I'll tweak them based on feedback and
> send them on to Andrew.
> 

Unfortunately, AFAICS the proposed hierarchy_mutex can't solve this bug. :(

> Paul
> 
> On Dec 14, 2008 4:48 AM, "Peter Zijlstra" <a.p.zijlstra@chello.nl> wrote:
> 
> On Sun, 2008-12-14 at 10:54 +0800, Li Zefan wrote: > > i merged it up in
> tip/master, could you pleas...
> Can't we detect a dead task-group and skip those instead of adding this
> global lock?
> 
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com> > --- > kernel/sched_fair.c
> | 6 ++++++ > kerne...
> 

