Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab0BNXe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:34:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:34411 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab0BNXez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:34:55 -0500
Subject: Re: [PATCH -mm 3/7] pci: convert pci_set_dma_mask to call
 dma_set_mask
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       James Bottomley <James.Bottomley@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Russell King <linux@arm.linux.org.uk>
In-Reply-To: <1265967212-9126-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1265967212-9126-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 10:33:41 +1100
Message-ID: <1266190421.16346.71.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 18:33 +0900, FUJITA Tomonori wrote:
> This changes pci_set_dma_mask to call the generic DMA API,
> dma_set_mask.
> 
> pci_set_dma_mask (in drivers/pci/pci.c) does the same things that
> dma_set_mask does on all the architectures that use pci_set_dma_mask;
> calls dma_supprted and sets dev->dma_mask. So we safely change
> pci_set_dma_mask to simply call dma_set_mask.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: James Bottomley <James.Bottomley@suse.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> Cc: Russell King <linux@arm.linux.org.uk>
> ---
>  drivers/pci/pci.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 315fea4..5c881e9 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2121,15 +2121,13 @@ void pci_msi_off(struct pci_dev *dev)
>  int
>  pci_set_dma_mask(struct pci_dev *dev, u64 mask)
>  {
> -	if (!pci_dma_supported(dev, mask))
> -		return -EIO;
> -
> -	dev->dma_mask = mask;
> +	int ret = dma_set_mask(&dev->dev, mask);
> +	if (ret)
> +		return ret;
>  	dev_dbg(&dev->dev, "using %dbit DMA mask\n", fls64(mask));
> -
>  	return 0;
>  }
> -    
> +
>  int
>  pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
>  {


