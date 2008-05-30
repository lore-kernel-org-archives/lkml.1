Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbYE3Bwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbYE3Bwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYE3Bwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:52:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbYE3Bwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:52:35 -0400
Message-ID: <483F5DAA.5060004@cn.fujitsu.com>
Date: Fri, 30 May 2008 09:51:38 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function update_cpumask()
 and update_nodemask()
References: <483E564A.5050807@cn.fujitsu.com> <20080529031656.cdc38001.pj@sgi.com>
In-Reply-To: <20080529031656.cdc38001.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2008-5-29 16:16 Paul Jackson wrote:
[snip]

>  4) Could you do me a little favor, and include the two minor fixes in
>     the following patch in your patch?  These two fixes aren't worth
>     making their own separate submission for.  I noticed them when I
>     was running the scripts/kernel-doc tool to check the comments for
>     my comment (3) above.  You can either just add the minor fixes to
>     your patch 1 of 2, or you can make the following a third patch in
>     your patch set, under your "Signed-off-by" line.  It does not matter
>     at all to me which way you do it.  Take the easy way, which is
>     probably just making these three minor changes as part of your
>     first patch, just as if they were your code all the time.  Thanks!
> 
> 
> ====================== Begin Patch ======================
> --- 2.6.26-rc2-mm1-pj_efi_patches.orig/kernel/cpuset.c	2008-05-29 00:20:35.000000000 -0700
> +++ 2.6.26-rc2-mm1-pj_efi_patches/kernel/cpuset.c	2008-05-29 00:53:42.478128805 -0700
> @@ -1938,7 +1938,6 @@ void __init cpuset_init_smp(void)
>  }
>  
>  /**
> -
>   * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
>   * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
>   * @pmask: pointer to cpumask_t variable to receive cpus_allowed set.
> @@ -1956,10 +1955,10 @@ void cpuset_cpus_allowed(struct task_str
>  	mutex_unlock(&callback_mutex);
>  }
>  
> -/**
> +/*
>   * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
>   * Must be called with callback_mutex held.
> - **/
> + */
>  void cpuset_cpus_allowed_locked(struct task_struct *tsk, cpumask_t *pmask)
>  {
>  	task_lock(tsk);
> ======================= End Patch =======================
>

I think that it is unnecessary to change cpuset_cpus_allowed_locked()'s comment
because it isn't a static function, it is a extern function and it is called by
move_task_off_dead_cpu() in kernel/sched.c 
 
> 
>  5) You wrote:
> 	This patch fixes this bug expect for root cpuset.
>     Then you analyze the root cpuset problem that remains.  I will try
>     to think more about that perhaps tomorrow; that won't impede progress
>     on this current patch set.
> 
> 
> 
> These patches look very good to me.  Please add my Acked-by line
> in your next and I expect final version:
> 
> Acked-by: Paul Jackson <pj@sgi.com>
> 



