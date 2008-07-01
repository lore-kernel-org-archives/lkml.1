Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbYGADih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbYGADih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 23:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYGADi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 23:38:29 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:35374 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYGADi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 23:38:29 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] DMA Engine: fix error path(s) in fsl-dma driver
Date: Tue, 1 Jul 2008 11:38:23 +0800
Message-ID: <989B956029373F45A0B8AF029708189002563E31@zch01exm26.fsl.freescale.net>
In-Reply-To: <20080630181856.GA6980@www.tglx.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] DMA Engine: fix error path(s) in fsl-dma driver
Thread-Index: Acja3cpUenrngwuqQM+5ygndahRq2AAS5V9A
References: <20080630181856.GA6980@www.tglx.de>
From: "Li Yang" <LeoLi@freescale.com>
To: "Sebastian Siewior" <bigeasy@linutronix.de>
Cc: "Zhang Wei" <zw@zh-kernel.org>, <linuxppc-embedded@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sebastian Siewior [mailto:bigeasy@linutronix.de] 
> Sent: Tuesday, July 01, 2008 2:19 AM
> To: Li Yang
> Cc: Zhang Wei; linuxppc-embedded@ozlabs.org; 
> linux-kernel@vger.kernel.org
> Subject: [PATCH] DMA Engine: fix error path(s) in fsl-dma driver
> 
> of_fsl_dma_probe:
>  - kfree(NULL) doesn't hurt but dereferencing the pointer in 
> iounmap does
>  - also, the irq can be freed
> 
> of_fsl_dma_chan_probe:
> - iounmap(NULL) resolved in vunmap() what which in turn is 
> able to handle NULL
>   pointer but dereferencing still doesn't work
> - don't clean up not yet allocated ressources, like list_del 
> before list_add
> 
> fsl_dma_self_test:
> - call fsl_dma_free_chan_resources() if the first dma trans 
> didn't complete

Thanks Sebastian,

But similar patch has already been waiting in sub-system maintainer's tree which can be found at 

http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=commit;h=29ec9bdef73d68134e7070ee91ccda0718d46150

- Leo
