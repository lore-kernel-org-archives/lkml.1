Return-Path: <linux-kernel-owner+w=401wt.eu-S1761001AbZCYAyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001AbZCYAyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759972AbZCYArs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:47:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56818 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759968AbZCYArr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:47:47 -0400
Message-ID: <49C97F43.7080302@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 08:48:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v5
References: <20090324125710.GG3891@in.ibm.com>
In-Reply-To: <20090324125710.GG3891@in.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> cpuacct: Add stime and utime statistics
> 
> Add per-cgroup cpuacct controller statistics like the system and user
> time consumed by the group of tasks.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

except a bug below.

> +	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
> +		if (percpu_counter_init(&ca->cpustat[i], 0))
> +			goto out_free_counters;
>  
>  	if (cgrp->parent)
>  		ca->parent = cgroup_ca(cgrp->parent);
>  
>  	return &ca->css;
> +
> +out_free_counters:
> +	i--;
> +	while (i-- >= 0)
> +		percpu_counter_destroy(&ca->cpustat[i]);

replace "i--; while (i-- >=0)" to "while (--i >=0)", otherwise
you'll be accessing ca->cpustat[-1].

> +	free_percpu(ca->cpuusage);
> +out_free_ca:
> +	kfree(ca);
> +out:
> +	return ERR_PTR(-ENOMEM);
>  }
