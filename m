Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbZLRG6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbZLRG6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 01:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZLRG6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 01:58:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36134 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbZLRG6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 01:58:08 -0500
Date: Fri, 18 Dec 2009 07:57:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Some load-balancer cleanups
Message-ID: <20091218065755.GA23808@elte.hu>
References: <20091217185021.684424629@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217185021.684424629@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Since RT has since grown its own load-balancer which is totally independent 
> from CFS, we can remove some of the left-overs from back when.
> 
> Gets rid of the ->load_balance and ->move_one_task sched_class calls and 
> removed the rq_iterator stuff.
> 
> Also carries a lock-break recently found wanted by -rt.
> 
> Compile tested with CGROUP/SMP/UP and booted on x86_64-SMP.
> 
>  include/linux/sched.h   |    8 -
>  kernel/sched.c          | 1945 ++---------------------------------------------
>  kernel/sched_fair.c     | 1778 +++++++++++++++++++++++++++++++++++++++++--
>  kernel/sched_idletask.c |   21 -
>  kernel/sched_rt.c       |   20 -
>  5 files changed, 1805 insertions(+), 1967 deletions(-)

Nice cleanups! I think we want to delay its application to the scheduler tree 
for a week or two, to not interact with any urgent fixes for the .33 code.

Thanks,

	Ingo
