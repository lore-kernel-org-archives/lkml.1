Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbZFVPl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbZFVPl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbZFVPlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:41:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49006 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758042AbZFVPls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:41:48 -0400
Message-ID: <4A3FA653.7060008@garzik.org>
Date: Mon, 22 Jun 2009 11:42:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] parport_pc: set properly the dma_mask for parport_pc
 device
References: <20090622154702.17809.58975.stgit@t61.ukuu.org.uk> <20090622155349.17809.246.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622155349.17809.246.stgit@t61.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> parport_pc_probe_port() creates the own 'parport_pc' device if the
> device argument is NULL. Then parport_pc_probe_port() doesn't
> initialize the dma_mask and coherent_dma_mask of the device and calls
> dma_alloc_coherent with it. dma_alloc_coherent fails because
> dma_alloc_coherent() doesn't accept the uninitialized dma_mask:
> 
> http://lkml.org/lkml/2009/6/16/150
> 
> Long ago, X86_32 and X86_64 had the own dma_alloc_coherent
> implementations; X86_32 accepted a device having dma_mask that is not
> initialized however X86_64 didn't. When we merged them, we chose to
> prohibit a device having dma_mask that is not initialized. I think
> that it's good to require drivers to set up dma_mask (and
> coherent_dma_mask) properly if the drivers want DMA.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Reported-by: Malcom Blaney <malcolm.blaney@maptek.com.au>
> Tested-by: Malcom Blaney <malcolm.blaney@maptek.com.au>
> Cc: stable@kernel.org
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/parport/parport_pc.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

Acked-by: Jeff Garzik <jgarzik@redhat.com>


