Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbZB0GkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbZB0GkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 01:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbZB0GkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 01:40:10 -0500
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:42125 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbZB0GkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 01:40:08 -0500
Date: Fri, 27 Feb 2009 12:09:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kenchen@google.com, "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>, mingo@elte.hu,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] change cpuacct usage percpu format
Message-ID: <20090227063955.GS11421@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-27 14:05:37]:

> I'd like to change cpuacct.usage_percpu format before it's widely used.
> Current format is not easy to use in hardware with DR feature.
> 
> ==
> cpuacct.usage_percpu shows per cpu usage information via cgroupfs.
> It shows all present cpus information and "whose information ?"
> is explained just by index of data implicitly.
> 
> IIRC, there is physical cpu hotplug and it can remove
> cpus and change present map. Considering a software which records
> this information pediodically(like sar.), its better to show id of cpu
> in explict way.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  kernel/sched.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: mmotm-2.6.29-Feb24/kernel/sched.c
> ===================================================================
> --- mmotm-2.6.29-Feb24.orig/kernel/sched.c
> +++ mmotm-2.6.29-Feb24/kernel/sched.c
> @@ -9719,7 +9719,7 @@ static int cpuacct_percpu_seq_read(struc
> 
>  	for_each_present_cpu(i) {
>  		percpu = cpuacct_cpuusage_read(ca, i);
> -		seq_printf(m, "%llu ", (unsigned long long) percpu);
> +		seq_printf(m, "%d %llu\n", i, (unsigned long long) percpu);

Seems like a reasonable change, but I wonder if " " should the
separator between the CPU and data, I wounder if we should use
cpu:usage_per_cpu.
-- 
	Balbir
