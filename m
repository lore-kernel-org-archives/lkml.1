Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZFKGJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZFKGJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 02:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZFKGJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 02:09:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63267 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZFKGJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 02:09:10 -0400
Message-ID: <4A309FDD.4030804@cn.fujitsu.com>
Date: Thu, 11 Jun 2009 14:10:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       yinghai@kernel.org
Subject: Re: [PATCH 2/2] sched: use slab in cpupri_init()
References: <Pine.LNX.4.64.0906110846330.2617@melkki.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0906110846330.2617@melkki.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -163,9 +167,7 @@ int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)

so the __init_refok tag can be removed, no?

>  
>  		spin_lock_init(&vec->lock);
>  		vec->count = 0;
> -		if (bootmem)
> -			alloc_bootmem_cpumask_var(&vec->mask);
> -		else if (!zalloc_cpumask_var(&vec->mask, GFP_KERNEL))
> +		if (!zalloc_cpumask_var(&vec->mask, gfp))
>  			goto cleanup;
>  	}
>  
