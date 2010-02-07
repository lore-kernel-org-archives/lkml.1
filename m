Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0BGLlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 06:41:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53896 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab0BGLlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:41:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Heinz Diehl <htd@fancy-poultry.org>
Subject: Re: [Bug #15196] kmem_cache_create: duplicate cache ccid2_h
Date: Sun, 7 Feb 2010 12:42:03 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Xiaotian Feng <xtfeng@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       nhorman@tuxdriver.com, davem@davemloft.net
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera> <20100201150605.GA6175@fancy-poultry.org> <20100207105448.GA6623@fancy-poultry.org>
In-Reply-To: <20100207105448.GA6623@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002071242.03698.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 February 2010, Heinz Diehl wrote:
> On 01.02.2010, Heinz Diehl wrote: 
> 
> [....]
> 
> Quoting myself here...
> 
> > The patch was completely malformed, don't know what happened on the way,
> > but I applied it by hand. Yes, it fixes the problem for me.
> 
> Xiaotiangs patch quoted in the thread listed here (coming via kernel.org's
> bugtracker)
> 
>  http://patchwork.kernel.org/patch/76023/
>  
> is missing some lines, and the patch attached at the end of the
> thread is incomplete and malformed, as reported earlier. I guess this is
> how it should have looked like (please correct me if I'm wrong):

Thanks, I updated the bug entry with a link to your patch below.

> --- /a/ccid.c	2010-02-06 23:17:12.000000000 +0100
> +++ /b/ccid.c	2010-02-07 09:50:40.000000000 +0100
> @@ -77,13 +77,13 @@
>  	return err;
>  }
>  
> -static struct kmem_cache *ccid_kmem_cache_create(int obj_size, char *slab_name_fmt, const char *fmt,...)
> +static struct kmem_cache *ccid_kmem_cache_create(int obj_size, char *slab_name_fmt, int length, const char *fmt,...)
>  {
>  	struct kmem_cache *slab;
>  	va_list args;
>  
>  	va_start(args, fmt);
> -	vsnprintf(slab_name_fmt, sizeof(slab_name_fmt), fmt, args);
> +	vsnprintf(slab_name_fmt, length, fmt, args);
>  	va_end(args);
>  
>  	slab = kmem_cache_create(slab_name_fmt, sizeof(struct ccid) + obj_size, 0,
> @@ -104,6 +104,7 @@
>  	ccid_ops->ccid_hc_rx_slab =
>  			ccid_kmem_cache_create(ccid_ops->ccid_hc_rx_obj_size,
>  					       ccid_ops->ccid_hc_rx_slab_name,
> +					       sizeof(ccid_ops->ccid_hc_rx_slab_name),
>  					       "ccid%u_hc_rx_sock",
>  					       ccid_ops->ccid_id);
>  	if (ccid_ops->ccid_hc_rx_slab == NULL)
> @@ -112,6 +113,7 @@
>  	ccid_ops->ccid_hc_tx_slab =
>  			ccid_kmem_cache_create(ccid_ops->ccid_hc_tx_obj_size,
>  					       ccid_ops->ccid_hc_tx_slab_name,
> +					       sizeof(ccid_ops->ccid_hc_tx_slab_name),
>  					       "ccid%u_hc_tx_sock",
>  					       ccid_ops->ccid_id);
>  	if (ccid_ops->ccid_hc_tx_slab == NULL)
> 

Rafael
