Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZGCH4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZGCH4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZGCH4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:56:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49786 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbZGCH4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:56:17 -0400
Message-ID: <4A4DB9E4.9060500@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 15:57:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 4/9] [RFC] Allow cgroup hierarchies to be created with
 no	bound subsystems
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com> <20090702021113.14469.2703.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090702021113.14469.2703.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define MAX_TASKS_SHOWN_PER_CSS 25
> +static int cgroup_css_links_read(struct cgroup *cont,
> +				 struct cftype *cft,
> +				 struct seq_file *seq)
> +{
> +	struct cg_cgroup_link *link, *saved_link;

need a newline

> +	write_lock_irq(&css_set_lock);

can be read_lock(&css_set_lock);

> +	list_for_each_entry_safe(link, saved_link, &cont->css_sets,

can be list_for_each_entry()

> +				 cgrp_link_list) {
> +		struct css_set *cg = link->cg;
> +		struct task_struct *task, *saved_task;
> +		int count = 0;
> +		seq_printf(seq, "css_set %p\n", cg);
> +		list_for_each_entry_safe(task, saved_task, &cg->tasks,

ditto

> +					 cg_list) {
> +			if (count++ > MAX_TASKS_SHOWN_PER_CSS) {
> +				seq_puts(seq, "  ...\n");
> +				break;
> +			} else {
> +				seq_printf(seq, "  task %d\n",
> +					   task_pid_vnr(task));
> +			}
> +		}
> +	}
> +	write_unlock_irq(&css_set_lock);
> +	return 0;
> +}
