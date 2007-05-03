Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbXECSMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbXECSMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 14:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbXECSMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 14:12:08 -0400
Received: from xenotime.net ([66.160.160.81]:34154 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754404AbXECSMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 14:12:07 -0400
Date: Thu, 3 May 2007 11:16:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Robert P. J. Day" <rpjday@mindspring.com>, jgarzik <jgarzik@pobox.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: Remove apparently dead CONFIG_NO_ATA_LEGACY code.
Message-Id: <20070503111628.c009af15.rdunlap@xenotime.net>
In-Reply-To: <Pine.LNX.4.64.0705031350550.11235@localhost.localdomain>
References: <Pine.LNX.4.64.0705031350550.11235@localhost.localdomain>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007 13:53:06 -0400 (EDT) Robert P. J. Day wrote:

> 
> Remove the single snippet of code conditional on the non-existent
> CONFIG_NO_ATA_LEGACY Kconfig variable.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   i would have mailed a note about this to the ATA maintainer but it
> wasn't clear who that was.  this is the only dead CONFIG_ variable
> under drivers/ata so i figured i'd just submit the patch.

from that source file:

 *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
 *    		    Please ALWAYS copy linux-ide@vger.kernel.org
 *		    on emails.


> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index d211db6..5a4821a 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -985,16 +985,6 @@ int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
>  		mask = (1 << 2) | (1 << 0);
>  		if ((tmp8 & mask) != mask)
>  			legacy_mode = (1 << 3);
> -#if defined(CONFIG_NO_ATA_LEGACY)
> -		/* Some platforms with PCI limits cannot address compat
> -		   port space. In that case we punt if their firmware has
> -		   left a device in compatibility mode */
> -		if (legacy_mode) {
> -			printk(KERN_ERR "ata: Compatibility mode ATA is not supported on this platform, skipping.\n");
> -			rc = -EOPNOTSUPP;
> -			goto err_out;
> -		}
> -#endif
>  	}
> 
>  	/* alloc and init host */
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
