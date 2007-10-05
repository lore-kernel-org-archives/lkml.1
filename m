Return-Path: <linux-kernel-owner+w=401wt.eu-S1764277AbXJEXh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764277AbXJEXh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759093AbXJEXhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:37:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50476 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753265AbXJEXhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:37:19 -0400
Date: Fri, 5 Oct 2007 16:37:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: sukadev@us.ibm.com
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [PATCH] Rename is_cgroup_init()
Message-Id: <20071005163706.f93fd80c.akpm@linux-foundation.org>
In-Reply-To: <20071004161559.GA19451@us.ibm.com>
References: <20071004161559.GA19451@us.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007 09:15:59 -0700
>
> From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> Subject: [PATCH] Rename is_cgroup_init()
> 
> is_container_init() was accidentally renamed to is_cgroup_init() when
> renaming "container" to "control group". This patch restores the
> original name.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> ---
>  include/linux/sched.h |    4 ++--
>  kernel/capability.c   |    2 +-
>  kernel/pid.c          |    4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> Index: 2.6.23-rc8-mm2/include/linux/sched.h
> ===================================================================
> --- 2.6.23-rc8-mm2.orig/include/linux/sched.h	2007-10-02 22:05:18.000000000 -0700
> +++ 2.6.23-rc8-mm2/include/linux/sched.h	2007-10-03 10:26:12.000000000 -0700
> @@ -1303,10 +1303,10 @@ static inline int is_global_init(struct 
>  }
>  
>  /*
> - * is_cgroup_init:
> + * is_container_init:
>   * check whether in the task is init in its own pid namespace.
>   */
> -extern int is_cgroup_init(struct task_struct *tsk);
> +extern int is_container_init(struct task_struct *tsk);
>  
>  extern struct pid *cad_pid;
>  
> Index: 2.6.23-rc8-mm2/kernel/capability.c
> ===================================================================
> --- 2.6.23-rc8-mm2.orig/kernel/capability.c	2007-09-27 13:20:11.000000000 -0700
> +++ 2.6.23-rc8-mm2/kernel/capability.c	2007-10-03 10:26:35.000000000 -0700
> @@ -130,7 +130,7 @@ static inline int cap_set_all(kernel_cap
>       int found = 0;
>  
>       do_each_thread(g, target) {
> -             if (target == current || is_cgroup_init(target->group_leader))
> +             if (target == current || is_container_init(target->group_leader))
>                       continue;
>               found = 1;
>  	     if (security_capset_check(target, effective, inheritable,
> Index: 2.6.23-rc8-mm2/kernel/pid.c
> ===================================================================
> --- 2.6.23-rc8-mm2.orig/kernel/pid.c	2007-10-03 10:24:12.000000000 -0700
> +++ 2.6.23-rc8-mm2/kernel/pid.c	2007-10-03 10:24:45.000000000 -0700
> @@ -81,7 +81,7 @@ struct pid_namespace init_pid_ns = {
>  };
>  EXPORT_SYMBOL_GPL(init_pid_ns);
>  
> -int is_cgroup_init(struct task_struct *tsk)
> +int is_container_init(struct task_struct *tsk)
>  {
>  	int ret = 0;
>  	struct pid *pid;
> @@ -94,7 +94,7 @@ int is_cgroup_init(struct task_struct *t
>  
>  	return ret;
>  }
> -EXPORT_SYMBOL(is_cgroup_init);
> +EXPORT_SYMBOL(is_container_init);
>  
>  /*
>   * Note: disable interrupts while the pidmap_lock is held as an

This patch is splattered across approximately seven different patches - ugly.

I just edited the diffs and changelogs in place and replaced all
occurrences of is_cgroup_init with is_container_init
