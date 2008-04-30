Return-Path: <linux-kernel-owner+w=401wt.eu-S1765136AbYD3V2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765136AbYD3V2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbYD3V2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:28:25 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28299 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbYD3V2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:28:25 -0400
Message-ID: <4818E3D3.7000907@oracle.com>
Date: Wed, 30 Apr 2008 14:25:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] PNP: fix printk format warnings
References: <20080430135608.8b6ee7e0.randy.dunlap@oracle.com> <1209589640.5041.67.camel@localhost>
In-Reply-To: <1209589640.5041.67.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2008-04-30 at 13:56 -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> next-20080430/drivers/pnp/pnpbios/rsparser.c:594: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'
>> next-20080430/drivers/pnp/pnpbios/rsparser.c:605: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'
> 
> resource_size_t can be u64

I know.

> I think you need %llu/(unsigned long long)

So the interrupt number or DMA channel may be astronomically huge?  OK.
Whatever.

> --- next-20080430.orig/drivers/pnp/pnpbios/rsparser.c
> +++ next-20080430/drivers/pnp/pnpbios/rsparser.c
> @@ -591,7 +591,7 @@ static void pnpbios_encode_irq(struct pn
>  	p[1] = map & 0xff;
>  	p[2] = (map >> 8) & 0xff;
>  
> -	dev_dbg(&dev->dev, "  encode irq %d\n", res->start);
> +	dev_dbg(&dev->dev, "  encode irq %llu\n", (unsigned long long)res->start);
>  }
>  
>  static void pnpbios_encode_dma(struct pnp_dev *dev, unsigned char *p,
> @@ -602,7 +602,7 @@ static void pnpbios_encode_dma(struct pn
>  	map = 1 << res->start;
>  	p[1] = map & 0xff;
>  
> -	dev_dbg(&dev->dev, "  encode dma %d\n", res->start);
> +	dev_dbg(&dev->dev, "  encode dma %llu\n", (unsigned long long)res->start);
>  }
>  
>  static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,
> 
> 


-- 
~Randy
