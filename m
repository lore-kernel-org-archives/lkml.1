Return-Path: <linux-kernel-owner+w=401wt.eu-S1764754AbXGPG46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764754AbXGPG46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 02:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbXGPG4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 02:56:51 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34251 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753035AbXGPG4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 02:56:50 -0400
Date: Mon, 16 Jul 2007 08:56:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
Message-ID: <20070716065610.GA3653@stusta.de>
References: <20070715234543.GN3565@stusta.de> <5FD5754DDBA0B1499B5A0B4BB54194850164B27C@fmsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB54194850164B27C@fmsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 10:03:02PM -0700, Li, Tong N wrote:
> 
> There are various metrics a scheduler may want to optimize for, such as
> throughput, response time, power consumption, fairness, and so on. Each
> of these may also be defined differently in different environments. Take
> fairness as an example. People have traditionally talked about it in
> terms of CPU time. Now it'd also make sense to talk about scheduling
> that enables fair usage of other types of resources, such as shared
> caches. Different metrics may require different scheduling policies.

Are these real-life problems people need solutions for today or just 
thoughts someone might want to try and write a paper about?

> Plus, many metrics may in fact conflict, e.g., a scheduling policy
> optimized for throughput may not be power efficient. As a result, Linux,
> and all general-purpose OSes, strive to achieve a balance, but it's
> conceivable that different hardware platforms and different application
> workloads may want to have different scheduling policies to meet their
> own needs.

The Linux scheduler already gives you some knobs allowing you to adjust 
the scheduling to your needs.

What is missing, and why wasn't it included in the current scheduler?

> Given that the scheduling policies can be diverse, the mechanisms to
> enforce them can also be different. The per-cpu runqueue model may be
> best for many scenarios, some scheduling policies (like many real-time
> ones) might want global knowledge about all tasks in the system and thus
> prefer a global task queue at the cost of being less scalable and
> cache-efficient. HPC systems may also want to gang-schedule. And, in
> terms of implementation, O(1) might be desirable for large-scale MP
> systems while O(log N) might be good enough for small systems. These are
> just examples that indicate the scheduler data structures, algorithms,
> and implementation can have a variety of possibilities in different
> usage models. A single scheduler that is easily extensible for
> incorporating different policies would be ideal, but IMO this is not yet
> the case and may not even be possible. Therefore, I think having a
> framework that enables multiple schedulers to co-exist would be
> invaluable and PlugSched seems to be one good step towards this.

Much is already possible, and e.g. when you talk about HPC you are in an 
area where the scope of the kernel is anyway often too small and the 
actual scheduling is done with a userspace batch scheduling program.

What are the real-life problems the current scheduler has, and why 
weren't they solved when it was designed and implemented?

People implementing a special purpose scheduler to fit their needs would
really not be an ideal solution - ideally, there should be one scheduler 
that handles all real-life problems.

And therefore the first step for people should be to try to get their 
problems solved with the one scheduler, and if required enhance it, 
instead of saying NIH and implement their own special purpose scheduler.

>   tong

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

