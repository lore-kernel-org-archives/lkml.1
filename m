Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbZAGBUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbZAGBUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 20:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbZAGBUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 20:20:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59490 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbZAGBUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 20:20:23 -0500
Message-ID: <4964031B.6050401@cn.fujitsu.com>
Date: Wed, 07 Jan 2009 09:19:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix double kfree
References: <496326BA.60605@cn.fujitsu.com> <496392B0.5080700@sgi.com>
In-Reply-To: <496392B0.5080700@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another thing I noticed but didn't deal with is:
> 
> static int init_rootdomain(struct root_domain *rd, bool bootmem)
> {
>         memset(rd, 0, sizeof(*rd));
> 
>         if (bootmem) {
>                 alloc_bootmem_cpumask_var(&def_root_domain.span);
>                 alloc_bootmem_cpumask_var(&def_root_domain.online);
>                 alloc_bootmem_cpumask_var(&def_root_domain.rto_mask);
>                 cpupri_init(&rd->cpupri, true);
>                 return 0;
>         }
>         if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
> 		...
> 
> Note that under the if (bootmem) case, it specifies the addresses
> directly instead of using (&rd->span) as the other alloc's do.
> 
> Not a big deal, just an inconsistency.
> 

I didn't notice this. :)

What makes it a bit worse is another inconsistency in if(bootmem), that rd
is used in cpupri_init() but def_root_domain is used in alloc()s.

