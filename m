Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYKEGUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYKEGUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 01:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYKEGUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 01:20:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYKEGU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 01:20:29 -0500
Message-ID: <49113A81.60809@cn.fujitsu.com>
Date: Wed, 05 Nov 2008 14:17:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting	controller
References: <20081024050830.GA4387@in.ibm.com> <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com> <20081025060157.GA4614@in.ibm.com> <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com> <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com> <20081027044319.GA4386@in.ibm.com> <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com> <49057ADD.1050705@cn.fujitsu.com> <20081030171622.GA19872@linux.vnet.ibm.com> <20081031094041.194a32d9.kamezawa.hiroyu@jp.fujitsu.com> <20081104124937.GB4898@in.ibm.com>
In-Reply-To: <20081104124937.GB4898@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +The CPU accounting controller is used to group tasks using cgroups and
> +account the CPU usage of these group of tasks.

this group or these groups?

...

> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9236,6 +9236,7 @@ struct cpuacct {
>  	struct cgroup_subsys_state css;
>  	/* cpuusage holds pointer to a u64-type object on every cpu */
>  	u64 *cpuusage;
> +	struct cpuacct *parent;
>  };
>  

Maybe the comment needs to be updated?

/* track cpu usage of a group of tasks */
struct cpuacct {
	...
};

->

/* track cpu usage of a group of tasks and its child groups */
