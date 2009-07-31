Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZGaSRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZGaSRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 14:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZGaSRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 14:17:43 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:55330 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZGaSRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 14:17:42 -0400
Date: Fri, 31 Jul 2009 14:14:57 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Randy Dunlap <rdunlap@xenotime.net>
cc: lkml <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
       gregkh@suse.de
Subject: Re: [PATCH] staging/android/lowmemorykiller: fix module param
 errors
In-Reply-To: <20090731111045.8dfd1ea5.rdunlap@xenotime.net>
Message-ID: <alpine.LFD.2.00.0907311412560.6962@localhost>
References: <20090731111045.8dfd1ea5.rdunlap@xenotime.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Move module_params to near the end of the source file so that
> their references are already known/defined.  Fixes build errors:
>
> drivers/staging/android/lowmemorykiller.c: In function '__check_cost':
> drivers/staging/android/lowmemorykiller.c:60: error: 'lowmem_shrinker' undeclared (first use in this function)
> drivers/staging/android/lowmemorykiller.c: At top level:
> drivers/staging/android/lowmemorykiller.c:60: error: 'lowmem_shrinker' undeclared here (not in a function)
> drivers/staging/android/lowmemorykiller.c:60: warning: type defaults to 'int' in declaration of 'type name'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/staging/android/lowmemorykiller.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> --- linux-next-20090731.orig/drivers/staging/android/lowmemorykiller.c
> +++ linux-next-20090731/drivers/staging/android/lowmemorykiller.c
> @@ -57,13 +57,6 @@ static int lowmem_minfree_size = 4;
>  			printk(x);			\
>  	} while (0)
>
> -module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);
> -module_param_array_named(adj, lowmem_adj, int, &lowmem_adj_size,
> -			 S_IRUGO | S_IWUSR);
> -module_param_array_named(minfree, lowmem_minfree, uint, &lowmem_minfree_size,
> -			 S_IRUGO | S_IWUSR);
> -module_param_named(debug_level, lowmem_debug_level, uint, S_IRUGO | S_IWUSR);
> -
>  static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
>  {
>  	struct task_struct *p;
> @@ -166,6 +159,13 @@ static void __exit lowmem_exit(void)
>  	unregister_shrinker(&lowmem_shrinker);
>  }
>
> +module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);
> +module_param_array_named(adj, lowmem_adj, int, &lowmem_adj_size,
> +			 S_IRUGO | S_IWUSR);
> +module_param_array_named(minfree, lowmem_minfree, uint, &lowmem_minfree_size,
> +			 S_IRUGO | S_IWUSR);
> +module_param_named(debug_level, lowmem_debug_level, uint, S_IRUGO | S_IWUSR);
> +
>  module_init(lowmem_init);
>  module_exit(lowmem_exit);

  isn't that a bit non-standard?  from what i've seen, the standard
seems to be to define something as a module parameter *immediately*
after its definition, not to collect them all at the bottom of the
source file separate from the definitions.  *is* there a standard for
that?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
"Kernel Newbie Corner" column @ linux.com:          http://cli.gs/WG6WYX
========================================================================
