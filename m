Return-Path: <linux-kernel-owner+w=401wt.eu-S1752554AbYLPFuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbYLPFuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 00:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYLPFuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 00:50:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63562 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYLPFuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 00:50:05 -0500
Message-ID: <4947413B.5090400@cn.fujitsu.com>
Date: Tue, 16 Dec 2008 13:48:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
References: <494234B0.5@cn.fujitsu.com>	<20081212100044.GB18152@elte.hu>	<4944754F.8050503@cn.fujitsu.com>	<1229258890.17130.9.camel@lappy.programming.kicks-ass.net>	<4945B200.7020207@cn.fujitsu.com>	<1229328783.14605.11.camel@twins>	<49462890.1040002@cn.fujitsu.com>	<1229337829.14605.41.camel@twins> <20081215200849.94b1b8de.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081215200849.94b1b8de.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 15 Dec 2008 11:43:49 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
>>> +                if (cgroup_is_removed(cgroup) || !cgroup->dentry)
>>> +                        return;
>>>  		cgroup_path(cgroup, path, sizeof(path));
>>> +	}
>> Perhaps wrap that check in a cgroup_*() helper? That would avoid the
>> duplication, be clearer and not open code the ->dentry assumption.
>>
>> cgroup_is_active() perhaps?
>>

We are fixing this particular race, so open code and comment can document
the problem clearer.

And this wrapper shouldn't be used by other cgroup users, if one needs to
do these checks, he should have a reason and comment is needed to explain
what's happening.

Also, I can't think out an appropriate name..

> 
> I vote for cgroup_is_populated().
> 

But non-populated means the directory isn't filled up with control files,
this function name doesn't indicate if the dir dentry itself is valid or not..

