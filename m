Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZHJQ1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZHJQ1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbZHJQ1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:27:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:63837 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbZHJQ1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:27:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,354,1246863600"; 
   d="scan'208";a="715464060"
Date: Mon, 10 Aug 2009 09:27:31 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] pci: print out pref if mmio is prefetchable
Message-ID: <20090810092731.7a44c24e@jbarnes-g45>
In-Reply-To: <4A7C07AE.4040200@kernel.org>
References: <4A7C07AE.4040200@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Aug 2009 03:53:34 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> already print it out for pci bridge, also print it out for pci device
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/probe.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/pci/probe.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/probe.c
> +++ linux-2.6/drivers/pci/probe.c
> @@ -235,7 +235,10 @@ int __pci_read_base(struct pci_dev *dev,
>  			res->start = l64;
>  			res->end = l64 + sz64;
>  			dev_printk(KERN_DEBUG, &dev->dev,
> -				"reg %x 64bit mmio: %pR\n", pos,
> res);
> +				"reg %x %s: %pR\n", pos,
> +				 (res->flags & IORESOURCE_PREFETCH) ?
> +					"64bit mmio pref" : "64bit
> mmio",
> +				 res);
>  		}
>  
>  		res->flags |= IORESOURCE_MEM_64;
> @@ -249,7 +252,9 @@ int __pci_read_base(struct pci_dev *dev,
>  		res->end = l + sz;
>  
>  		dev_printk(KERN_DEBUG, &dev->dev, "reg %x %s:
> %pR\n", pos,
> -			(res->flags & IORESOURCE_IO) ? "io port" :
> "32bit mmio",
> +			(res->flags & IORESOURCE_IO) ? "io port" :
> +			 ((res->flags & IORESOURCE_PREFETCH) ?
> +				 "32bit mmio pref" : "32bit mmio"),
>  			res);
>  	}
>  
> 

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
