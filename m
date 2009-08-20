Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbZHTT2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbZHTT2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbZHTT2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:28:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36352
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755253AbZHTT2i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:28:38 -0400
Date: Thu, 20 Aug 2009 12:28:50 -0700 (PDT)
Message-Id: <20090820.122850.37712606.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: walt@holmansrus.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Strange network timeouts w/ 2.6.30.5
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3skfmk39q.fsf@intrepid.localdomain>
References: <985009134.71250769263099.JavaMail.root@mail.holmansrus.com>
	<m3skfmk39q.fsf@intrepid.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 20 Aug 2009 15:45:21 +0200

> Something like maybe:
> 
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>
> 
> diff --git a/drivers/net/e100.c b/drivers/net/e100.c
> index 014dfb6..b610088 100644
> --- a/drivers/net/e100.c
> +++ b/drivers/net/e100.c
> @@ -1762,9 +1762,12 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
>  
>  			if (ioread8(&nic->csr->scb.status) & rus_no_res)
>  				nic->ru_running = RU_SUSPENDED;
> +#ifndef CONFIG_X86
> +		/* FIXME interferes with swiotlb. */
>  		pci_dma_sync_single_for_device(nic->pdev, rx->dma_addr,
>  					       sizeof(struct rfd),
>  					       PCI_DMA_BIDIRECTIONAL);
> +#endif
>  		return -ENODATA;
>  	}
>  

I'm not willing to apply something like this.

swiotlb emulates what hardware does, so if it can go wrong with
swiotlb it can go wrong with hardware to.

Figure out what the exact bug is.
