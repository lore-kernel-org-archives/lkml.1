Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYITDwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYITDwC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 23:52:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbYITDvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 23:51:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55596 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbYITDvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 23:51:52 -0400
Date: Sat, 20 Sep 2008 12:55:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org,
       penberg@cs.helsinki.fi
Subject: Re: [patch 1/4] Make the per cpu reserve configurable
Message-Id: <20080920125546.d6d7b42e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080919145928.322062135@quilx.com>
References: <20080919145859.062069850@quilx.com>
	<20080919145928.322062135@quilx.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 07:59:00 -0700
Christoph Lameter <cl@linux-foundation.org> wrote:
> +unsigned int percpu_reserve = PERCPU_MODULE_RESERVE;
> +

Is this PERCPU_MODULE_RESERVE default size is fixex to 8192 bytes
both on 32bit-arch and 64bit-arch ?
How about enlarging this to twice on 64bit arch now ?

sorry for noise.

Thanks,
-Kame



> +static int __init init_percpu_reserve(char *str)
> +{
> +	get_option(&str, &percpu_reserve);
> +	return 0;
> +}
> +
> +early_param("percpu=", init_percpu_reserve);
> +
>  /*
>   * Unknown boot options get handed to init, unless they look like
>   * failed parameters
> @@ -397,6 +407,9 @@ static void __init setup_per_cpu_areas(v
>  
>  	/* Copy section for each CPU (we discard the original) */
>  	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
> +	printk(KERN_INFO "percpu area: %d bytes total, %d available.\n",
> +			size, size - (__per_cpu_end - __per_cpu_start));
> +
>  	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
>  
>  	for_each_possible_cpu(i) {
> Index: linux-2.6/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/kernel-parameters.txt	2008-09-16 18:14:59.000000000 -0700
> +++ linux-2.6/Documentation/kernel-parameters.txt	2008-09-16 18:20:08.000000000 -0700
> @@ -1643,6 +1643,13 @@ and is between 256 and 4096 characters. 
>  			Format: { 0 | 1 }
>  			See arch/parisc/kernel/pdc_chassis.c
>  
> +	percpu=		Configure the number of percpu bytes that can be
> +			dynamically allocated. This is used for per cpu
> +			variables of modules and other dynamic per cpu data
> +			structures. Creation of per cpu structures after boot
> +			may fail if this is set too low.
> +			Default is 8000 bytes.
> +
>  	pf.		[PARIDE]
>  			See Documentation/paride.txt.
>  
> 
> -- 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

