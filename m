Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbZIPJJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbZIPJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758151AbZIPJJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:09:55 -0400
Received: from fifo99.com ([67.223.236.141]:51956 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbZIPJJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:09:54 -0400
Subject: Re: [Patch net-next]atl1e:fix 2.6.31-git4 -- ATL1E 0000:03:00.0:
 DMA-API: device driver frees DMA
From: Daniel Walker <dwalker@fifo99.com>
To: jie.yang@atheros.com
Cc: davem@davemloft.net, miles.lane@gmail.com, chris.snook@gmail.com,
       jcliburn@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <12530821133392-git-send-email-jie.yang@atheros.com>
References: <12530821133392-git-send-email-jie.yang@atheros.com>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 02:10:51 -0700
Message-Id: <1253092251.11643.569.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 14:21 +0800, jie.yang@atheros.com wrote:
> -           pci_unmap_page(pdev, tx_buffer->dma,
> +           if (tx_buffer->flags & ATL1E_TX_PCIMAP_SINGLE)
> +               pci_unmap_single(pdev, tx_buffer->dma,
> +                   tx_buffer->length, PCI_DMA_TODEVICE);
> +           else if (tx_buffer->flags & ATL1E_TX_PCIMAP_PAGE)
> +               pci_unmap_page(pdev, tx_buffer->dma,

Could you run this through checkpatch, and fix any errors if find? It
looks like you uses spaces for tabs in the code above, maybe in the
other block too..

Daniel

