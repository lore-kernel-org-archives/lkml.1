Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYHLQjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYHLQjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 12:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbYHLQjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 12:39:11 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4840 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYHLQjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 12:39:10 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5358"; a="5470063"
Message-ID: <48A1BCAB.2090502@qualcomm.com>
Date: Tue, 12 Aug 2008 09:39:07 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Rakib Mullick <rakib.mullick@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (take 4)
References: <1218490433-10576-1-git-send-email-maxk@qualcomm.com>	<48A0B16B.2080801@qualcomm.com>	<b9df5fa10808112021v7bb48c9ejefab284bea82c837@mail.gmail.com>	<48A1032F.4040606@qualcomm.com>	<b9df5fa10808120501i57dbd71k71b54cca0bfb2ff2@mail.gmail.com>	<b9df5fa10808120648x5bd541cdpd020cee836e89f20@mail.gmail.com> <20080812112750.4257544e.pj@sgi.com>
In-Reply-To: <20080812112750.4257544e.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Jackson wrote:
> Rakib wrote:
>> Ok, this is the second place. But, what about the first place ( I
>> mean in line 614).
> 
> You present me with a clear choice.
> 
>     I could find your past patch, applying it to whatever it applied to,
>     and look to see what was at line 614.
> 
>     Or I could ask you to restate your point, with enough code
>     displayed so that I could understand your point just by reading
>     your email.
> 
> I choose the second choice.  Thank-you.

I think Rakib is talking about this code

>         /* Special case for the 99% of systems with one, full, sched domain */
>         if (is_sched_load_balance(&top_cpuset)) {
>                 doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
>                 if (!doms)
>                         goto done;
> 
>                 dattr = kmalloc(sizeof(struct sched_domain_attr), GFP_KERNEL);
>                 if (dattr) {
>                         *dattr = SD_ATTR_INIT;
>                         update_domain_attr_tree(dattr, &top_cpuset);
>                 }
>                 *doms = top_cpuset.cpus_allowed;
> 
>                 ndoms = 1;
>                 goto done;
>         }

Which I think is perfectly fine and clear.

There are only two matches for
	/attr.*=.*alloc
We covered both of them.

Max



