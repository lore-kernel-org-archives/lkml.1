Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYFJRST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYFJRST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYFJRSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:18:08 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40815 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbYFJRSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:18:07 -0400
Date: Tue, 10 Jun 2008 21:19:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Question about task_struct::state
Message-ID: <20080610171957.GB6038@tv-sign.ru>
References: <20080610155055.GC4345@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610155055.GC4345@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10, Dhaval Giani wrote:
> 
> sched.h has a comment in task_struct
> 
>         volatile long state;    /* -1 unrunnable, 0 runnable, >0 stopped */
> 
> After some searching, I've not been able to figure out how state can
> become -1 (or unrunnable). Can you let me know how that happens?
> 
> If it cannot reach that state, then maybe this patch is needed.
> 
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h	2008-06-10 21:13:02.000000000 +0530
> +++ linux-2.6/include/linux/sched.h	2008-06-10 21:14:44.000000000 +0530
> @@ -1024,7 +1024,7 @@ struct sched_rt_entity {
>  };
>  
>  struct task_struct {
> -	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
> +	volatile long state;	/* 0 runnable, >0 stopped */

I think you are right, the comment is wrong (obsolete?).

Perhaps it is better to just remove it, or add a note about TASK_RUNNING/etc
above. ">0 stopped" looks a bit confusing too.

I'd suggest you to change the subject and send the patch to Andrew.

Oleg.

