Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbYGPHVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbYGPHVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYGPHV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:21:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:26795 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbYGPHV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:21:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=PB4kY9YPOUgo8S94fDr//7yY9CfAUOUSgW/wjm6OQeJQZw1nZZp/ceMujZY4Z9MSx
	57ZHVCT+D6iK6TjubO5mA==
Message-ID: <6599ad830807160021n2d09a7c3mfc3122e7be768db5@mail.gmail.com>
Date: Wed, 16 Jul 2008 00:21:20 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 3/3] cpuset: two minor code-cleanups
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Paul Jackson" <pj@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <487D6E51.1000907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <487D6E51.1000907@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 8:43 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> in function cpuset_update_task_memory_state()
> local variable
> struct task_struct *tsk = current;
>
> and local variable tsk is used 14 times and
> statement task_cs(tsk) is used twice in this function.
> So using task_cs(tsk) instead of task_cs(current) is
> better for readability.
>
> And "(struct cgroup_scanner *)&scan" is not good for
> readability also. (and "container_of" is used in cpuset_do_move_task(),
> not "(cpuset_hotplug_scanner *)scan")
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks.

> ---
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 798b3ab..4513deb 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -369,7 +369,7 @@ void cpuset_update_task_memory_state(void)
>                my_cpusets_mem_gen = top_cpuset.mems_generation;
>        } else {
>                rcu_read_lock();
> -               my_cpusets_mem_gen = task_cs(current)->mems_generation;
> +               my_cpusets_mem_gen = task_cs(tsk)->mems_generation;
>                rcu_read_unlock();
>        }
>
> @@ -1778,7 +1778,7 @@ static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)
>        scan.scan.heap = NULL;
>        scan.to = to->css.cgroup;
>
> -       if (cgroup_scan_tasks((struct cgroup_scanner *)&scan))
> +       if (cgroup_scan_tasks(&scan.scan))
>                printk(KERN_ERR "move_member_tasks_to_cpuset: "
>                                "cgroup_scan_tasks failed\n");
>  }
>
>
>
>
>
>
