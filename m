Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbZGCHGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbZGCHGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZGCHGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:06:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64368 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbZGCHGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:06:10 -0400
Message-ID: <4A4DAE21.4000806@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 15:07:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/9] [RFC] Add a back-pointer from struct cg_cgroup_link
 to	struct cgroup
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com> <20090702021108.14469.39645.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090702021108.14469.39645.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int current_css_set_cg_links_read(struct cgroup *cont,
> +					 struct cftype *cft,
> +					 struct seq_file *seq)
> +{
> +	struct cg_cgroup_link *link, *saved_link;
> +	struct css_set *cg;

call for a newline

> +	write_lock_irq(&css_set_lock);

can be read_lock(&css_set_lock);

> +	task_lock(current);
> +	cg = current->cgroups;
> +	list_for_each_entry_safe(link, saved_link, &cg->cg_links,
> +				 cg_link_list) {
> +		struct cgroup *c = link->cgrp;
> +		const char *name;

call for a newline

> +		rcu_read_lock();
> +		if (c->dentry)
> +			name = c->dentry->d_name.name;
> +		else
> +			name = "?";
> +		seq_printf(seq, "Root %lu group %s\n",
> +			   c->root->subsys_bits, name);
> +		rcu_read_unlock();
> +	}
> +	task_unlock(current);
> +	write_unlock_irq(&css_set_lock);
> +	return 0;
> +}
> +
