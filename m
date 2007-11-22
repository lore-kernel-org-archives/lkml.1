Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbXKVGgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbXKVGgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 01:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXKVGgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 01:36:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:46874 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbXKVGgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 01:36:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=E/ASWggZzmmx5BXejy12lpSbmIqicP/MJzOGFVr4Dc5ImpSaHFpnatt2X2rXT78lVNSeKhxiriVXDsDx4awiOQRyQjM6M8wKb2ognLq6m4Y1RhOK8L2mm5LqCuLJnzILne7H4Ov+QCvEeOSIRyou5rYf2GAmsaDpV9H0iSfmi9s=
Message-ID: <4745234E.9050409@gmail.com>
Date: Thu, 22 Nov 2007 15:35:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v2)
References: <47438248.7030704@shaw.ca>
In-Reply-To: <47438248.7030704@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Robert.

Robert Hancock wrote:
> This fixes some problems with ATAPI devices on nForce4 controllers in ADMA
> mode on systems with memory located above 4GB. We need to delay setting the
> 64-bit DMA mask until the PRD table and padding buffer are allocated so that
> they don't get allocated above 4GB and break legacy mode (which is needed for
> ATAPI devices). Also, explicitly set a 32-bit DMA mask before allocating the
> legacy buffers since setting the DMA mask affects both ports and we need to
> ensure the second port's buffers are allocated properly (fixes a problem
> with the previous version of this patch).
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> 
> +	/* Ensure DMA mask is set to 32-bit before allocating legacy PRD and
> +	   pad buffers */
> +	pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +	pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
[--snip--]
> +	pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
> +	pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));

I'm probably being paranoid here but please add error checks.  Just
checking return value and returning error suffices.

Thanks.

-- 
tejun
