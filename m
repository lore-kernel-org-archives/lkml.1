Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbXDISn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbXDISn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbXDISn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:43:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbXDISn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:43:28 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [QUICKLIST 3/4] Quicklist support for x86_64
Date: Mon, 9 Apr 2007 20:43:14 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com> <20070409182520.8559.33529.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070409182520.8559.33529.sendpatchset@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704092043.14335.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007 20:25:20 Christoph Lameter wrote:

>  #endif /* _X86_64_PGALLOC_H */
> Index: linux-2.6.21-rc5-mm4/arch/x86_64/kernel/process.c
> ===================================================================
> --- linux-2.6.21-rc5-mm4.orig/arch/x86_64/kernel/process.c	2007-04-07 18:07:47.000000000 -0700
> +++ linux-2.6.21-rc5-mm4/arch/x86_64/kernel/process.c	2007-04-07 18:09:30.000000000 -0700
> @@ -207,6 +207,7 @@
>  			if (__get_cpu_var(cpu_idle_state))
>  				__get_cpu_var(cpu_idle_state) = 0;
>  
> +			check_pgt_cache();

Wouldn't it be better to do that on memory pressure only (register
it as a shrinker)?

>  		rmb();
>  			idle = pm_idle;
>  			if (!idle)
> Index: linux-2.6.21-rc5-mm4/arch/x86_64/kernel/smp.c
> ===================================================================
> --- linux-2.6.21-rc5-mm4.orig/arch/x86_64/kernel/smp.c	2007-04-07 18:07:47.000000000 -0700
> +++ linux-2.6.21-rc5-mm4/arch/x86_64/kernel/smp.c	2007-04-07 18:09:30.000000000 -0700
> @@ -241,7 +241,7 @@
>  	}
>  	if (!cpus_empty(cpu_mask))
>  		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
> -
> +	check_pgt_cache();

Why is that here?

>  	preempt_enable();
>  }


-Andi
