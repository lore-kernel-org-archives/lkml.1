Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbZCYNez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbZCYNez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbZCYNer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:34:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:62997 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458AbZCYNeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KYNMGRfzofd9tt1sbiYig6GnnuiUD80d/g2QrItP9LrrEXfpTsZN87RFNJc/rriK9E
         SGoECkpjw/pKhQtCSksp8hgHhNgqqKKx67MkAgnM8vuEi6yTiHbFEylJSkt/WwNgdvL4
         ITyQUecm9eeyh2cruNdJydyYvwMkvl4XVnSNo=
Date: Wed, 25 Mar 2009 14:34:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] trace_workqueues: fix empty line's output
Message-ID: <20090325133439.GF5976@nowhere>
References: <49C9F266.2060706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C9F266.2060706@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 04:59:18PM +0800, Lai Jiangshan wrote:
> 
> Empty lines separate cpus stat. After previous
> fix(trace_stat: keep original order) applied, the empty lines
> are displayed at incorrect position.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
> index 9ab035b..797201e 100644
> --- a/kernel/trace/trace_workqueue.c
> +++ b/kernel/trace/trace_workqueue.c
> @@ -196,6 +196,11 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
>  	struct pid *pid;
>  	struct task_struct *tsk;
>  
> +	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> +	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
> +		seq_printf(s, "\n");
> +	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> +
>  	pid = find_get_pid(cws->pid);
>  	if (pid) {
>  		tsk = get_pid_task(pid, PIDTYPE_PID);
> @@ -208,18 +213,13 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
>  		put_pid(pid);
>  	}
>  
> -	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> -	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
> -		seq_printf(s, "\n");
> -	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> -
>  	return 0;
>  }
>  
>  static int workqueue_stat_headers(struct seq_file *s)
>  {
>  	seq_printf(s, "# CPU  INSERTED  EXECUTED   NAME\n");
> -	seq_printf(s, "# |      |         |          |\n\n");
> +	seq_printf(s, "# |      |         |          |\n");
>  	return 0;
>  }
>  
> 
> 

Looks good.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

