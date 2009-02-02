Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZBBUjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZBBUjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZBBUjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:39:04 -0500
Received: from smtp-out.google.com ([216.239.33.17]:8480 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbZBBUjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:39:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=KY5aopLYaS6RZYdlyQniZwppUvZAHbEWO6qMD1yBESEitJty8w1DKWplCDpVoXvDT
	8ojhXx59SlxdOpNhIq4kQ==
Date: Mon, 2 Feb 2009 12:37:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM
In-Reply-To: <20090202141705.GE918@balbir.in.ibm.com>
Message-ID: <alpine.DEB.2.00.0902021235500.26971@chino.kir.corp.google.com>
References: <20090202125240.GA918@balbir.in.ibm.com> <20090202215527.EC92.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090202141705.GE918@balbir.in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.75
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009, Balbir Singh wrote:

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8e4be9c..954b0d5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -813,6 +813,25 @@ bool mem_cgroup_oom_called(struct task_struct *task)
>  	rcu_read_unlock();
>  	return ret;
>  }
> +
> +void mem_cgroup_print_mem_info(struct mem_cgroup *memcg)
> +{
> +	if (!memcg)
> +		return;
> +
> +	printk(KERN_WARNING "Memory cgroups's name %s\n",
> +		memcg->css.cgroup->dentry->d_name.name);
> +	printk(KERN_WARNING "Cgroup memory: usage %llu, limit %llu"
> +		" failcnt %llu\n", res_counter_read_u64(&memcg->res, RES_USAGE),
> +		res_counter_read_u64(&memcg->res, RES_LIMIT),
> +		res_counter_read_u64(&memcg->res, RES_FAILCNT));
> +	printk(KERN_WARNING "Cgroup memory+swap: usage %llu, limit %llu "
> +		"failcnt %llu\n",
> +		res_counter_read_u64(&memcg->memsw, RES_USAGE),
> +		res_counter_read_u64(&memcg->memsw, RES_LIMIT),
> +		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
> +}
> +
>  /*
>   * Unlike exported interface, "oom" parameter is added. if oom==true,
>   * oom-killer can be invoked.

I think you'd want a less critical log level for these messages such as 
KERN_INFO.
