Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYLPJl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYLPJl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYLPJlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:41:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbYLPJlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:41:16 -0500
Message-ID: <4947776C.10600@cn.fujitsu.com>
Date: Tue, 16 Dec 2008 17:39:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu>	 <4944754F.8050503@cn.fujitsu.com>	 <1229258890.17130.9.camel@lappy.programming.kicks-ass.net>	 <6599ad830812141347k5d7e7e08vfc17855ea0ac981c@mail.gmail.com>	 <4945B546.5040301@cn.fujitsu.com>	 <20081215105053.89263708.kamezawa.hiroyu@jp.fujitsu.com> <6599ad830812160123x4a088632re220d081788b7187@mail.gmail.com>
In-Reply-To: <6599ad830812160123x4a088632re220d081788b7187@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Sun, Dec 14, 2008 at 5:50 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> at creation:
>>  - cpu_cgroup_populate() should record "tg" that "this cgroup has valid dentry"
>> at deletion
> 
> Wouldn't moving the call to cgroup_create_dir() to before doing
> subsystem initialization fix this problem more straightforwardly? Then
> by the time the cpu subsytem create() callback is called, dentry will
> already be valid.
> 

Yes, it's true, and actually it was the first idea came into my mind when I
started to fix this bug. But I was not sure whether this is an apropriate way.
Now I think it's ok, and we'd better add a comment to indicate we want to
make cgrp->dentry valid before calling subsystem create() method.

Note in print_cfs_rq(), due to the race, tg->css.cgroup can be NULL.
Fortunately, the code checks this condition, but I think it's just by accident
but not awaring there is a race.
