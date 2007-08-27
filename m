Return-Path: <linux-kernel-owner+w=401wt.eu-S1761670AbXH0U7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761670AbXH0U7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbXH0U7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:59:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:43015 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880AbXH0U7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UwENH6HEuR88Q9ctom9S4V4RsHPET0VZoJqXnjq6LrWG3KhBl075rNlfCOYbOUbtiW2wr62D930MIsOTXgIZqLl4Ppc0xTwK16XZOviJrr3ysSufcWArwJWD9b9IJm5lAFo/2uXu52IDTe5PART44zz9IozvFIWxUAy3FcB39t8=
Message-ID: <46D33B3E.9080105@gmail.com>
Date: Mon, 27 Aug 2007 22:59:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] trivial - constify sched.h
References: <1188247231.18004.129.camel@localhost>
In-Reply-To: <1188247231.18004.129.camel@localhost>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches napsal(a):
> Add const to some struct task_struct * uses

Does this have any impact on generated code? What (some objdumps or something)?
Or more descriptive log, why is this about to be done, please.

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> ---
> 
>  include/linux/sched.h |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ba78807..71d40a1 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1222,22 +1222,22 @@ static inline int rt_prio(int prio)
>  	return 0;
>  }
>  
> -static inline int rt_task(struct task_struct *p)
> +static inline int rt_task(const struct task_struct *p)
>  {
>  	return rt_prio(p->prio);
>  }
>  
> -static inline pid_t process_group(struct task_struct *tsk)
> +static inline pid_t process_group(const struct task_struct *tsk)
>  {
>  	return tsk->signal->pgrp;
>  }
>  
> -static inline pid_t signal_session(struct signal_struct *sig)
> +static inline pid_t signal_session(const struct signal_struct *sig)
>  {
>  	return sig->__session;
>  }
>  
> -static inline pid_t process_session(struct task_struct *tsk)
> +static inline pid_t process_session(const struct task_struct *tsk)
>  {
>  	return signal_session(tsk->signal);
>  }
> @@ -1247,22 +1247,22 @@ static inline void set_signal_session(struct signal_struct *sig, pid_t session)
>  	sig->__session = session;
>  }
>  
> -static inline struct pid *task_pid(struct task_struct *task)
> +static inline struct pid *task_pid(const struct task_struct *task)
>  {
>  	return task->pids[PIDTYPE_PID].pid;
>  }
>  
> -static inline struct pid *task_tgid(struct task_struct *task)
> +static inline struct pid *task_tgid(const struct task_struct *task)
>  {
>  	return task->group_leader->pids[PIDTYPE_PID].pid;
>  }
>  
> -static inline struct pid *task_pgrp(struct task_struct *task)
> +static inline struct pid *task_pgrp(const struct task_struct *task)
>  {
>  	return task->group_leader->pids[PIDTYPE_PGID].pid;
>  }
>  
> -static inline struct pid *task_session(struct task_struct *task)
> +static inline struct pid *task_session(const struct task_struct *task)
>  {
>  	return task->group_leader->pids[PIDTYPE_SID].pid;
>  }
> @@ -1275,7 +1275,7 @@ static inline struct pid *task_session(struct task_struct *task)
>   * If pid_alive fails, then pointers within the task structure
>   * can be stale and must not be dereferenced.
>   */
> -static inline int pid_alive(struct task_struct *p)
> +static inline int pid_alive(const struct task_struct *p)
>  {
>  	return p->pids[PIDTYPE_PID].pid != NULL;
>  }
> @@ -1286,7 +1286,7 @@ static inline int pid_alive(struct task_struct *p)
>   *
>   * Check if a task structure is the first user space task the kernel created.
>   */
> -static inline int is_init(struct task_struct *tsk)
> +static inline int is_init(const struct task_struct *tsk)
>  {
>  	return tsk->pid == 1;
>  }
> @@ -1639,7 +1639,7 @@ extern void wait_task_inactive(struct task_struct * p);
>   * all we care about is that we have a task with the appropriate
>   * pid, we don't actually care if we have the right task.
>   */
> -static inline int has_group_leader_pid(struct task_struct *p)
> +static inline int has_group_leader_pid(const struct task_struct *p)
>  {
>  	return p->pid == p->tgid;
>  }
> @@ -1650,7 +1650,7 @@ static inline struct task_struct *next_thread(const struct task_struct *p)
>  			  struct task_struct, thread_group);
>  }
>  
> -static inline int thread_group_empty(struct task_struct *p)
> +static inline int thread_group_empty(const struct task_struct *p)
>  {
>  	return list_empty(&p->thread_group);
>  }
> 
> 



-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
