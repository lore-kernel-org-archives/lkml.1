Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbYEDTST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbYEDTST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYEDTSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:18:07 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:51646 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbYEDTSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:18:06 -0400
Message-ID: <481E0C13.9010907@keyaccess.nl>
Date: Sun, 04 May 2008 21:18:43 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Joe Perches <joe@perches.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] PNP: fix printk format warnings
References: <20080430135608.8b6ee7e0.randy.dunlap@oracle.com> <1209589640.5041.67.camel@localhost>
In-Reply-To: <1209589640.5041.67.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-04-08 23:07, Joe Perches wrote:

> On Wed, 2008-04-30 at 13:56 -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> next-20080430/drivers/pnp/pnpbios/rsparser.c:594: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'
>> next-20080430/drivers/pnp/pnpbios/rsparser.c:605: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'
> 
> resource_size_t can be u64
> I think you need %llu/(unsigned long long)
> 
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

Bjorn? Could swear I previously saw patches that just did an (int) cast here...

Rene
