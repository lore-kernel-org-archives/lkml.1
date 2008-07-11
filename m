Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYGKF7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYGKF7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 01:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYGKF72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 01:59:28 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:53305 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752488AbYGKF71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 01:59:27 -0400
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: a.p.zijlstra@chello.nl, linux-mm@kvack.org, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] dirty balancing for cgroups
In-Reply-To: Your message of "Fri, 11 Jul 2008 14:15:11 +0900"
	<20080711141511.515e69a5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080711141511.515e69a5.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Cue version 0.8 (080625-0732/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080711055926.9AF4F5A03@siro.lan>
Date: Fri, 11 Jul 2008 14:59:26 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  - This looks simple but, could you merge this into memory resource controller ?
> > 
> > why?
> > 
> 3 points.
>  1. Is this useful if used alone ?

it can be.  why not?

>  2. memcg requires this kind of feature, basically.
> 
>  3. I wonder I need more work to make this work well under memcg.

i'm not sure if i understand these points.  can you explain a bit?

my patch penalizes heavy-writer cgroups as task_dirty_limit does
for heavy-writer tasks.  i don't think that it's necessary to be
tied to the memory subsystem because i merely want to group writers.

otoh, if you want to limit the number (or percentage or whatever) of
dirty pages in a memory cgroup, it can't be done independently from
the memory subsystem, of course.  it's another story, tho.

YAMAMOTO Takashi

> 
> If chasing page->cgroup and memcg make this patch much more complex,
> I think this style of implimentation is a choice.
> 
>  About 3. 
>     Does this works well if I changes get_dirty_limit()'s
>     determine_dirtyable_memory() calculation under memcg ?
>     But to do this seems not valid if dirty_ratio cgroup and memcg cgroup 
>     containes different set of tasks.
>  
> Thanks,
> -Kame
