Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYKUQhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYKUQhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYKUQhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:37:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36120 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbYKUQhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:37:34 -0500
Date: Fri, 21 Nov 2008 17:37:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/10] DMA-API debugging facility
Message-ID: <20081121163717.GA733@elte.hu>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi,
> 
> this patchset introduces code to debug drivers usage of the DMA-API. 
> Tests with hardware IOMMUs have shown several bugs in drivers 
> regarding the usage of that API. Problems were found especially in 
> network card drivers.
> 
> These bugs often don't show up or have any negative impact if there 
> is no hardware IOMMU in use in the system. But with an hardware 
> IOMMU these bugs turn the hardware unusable or, in the worst case, 
> cause data corruption on devices which are managed by other (good) 
> drivers.
> 
> With the code these patches introduce driver developers can find 
> several bugs of misusing the DMA-API in their drivers. But be aware, 
> it can not find all possible bugs. If it finds a problem it prints 
> out messages like
> 
> tg3 0000:08:04.0: PCI-DMA: device driver tries to free DMA memory it 
> has not allocated [device address=0x000000042f0f3ae7] [size=48 
> bytes]
>
> Pid: 6285, comm: bash Not tainted 2.6.28-rc5-00176-g6ae6379-dirty #6
> Call Trace:
>  <IRQ>  [<ffffffff80221276>] check_unmap+0x52/0x1ce
>  [<ffffffff80221af0>] debug_unmap_single+0x61/0xa4
>  [<ffffffff8053d396>] skb_dma_unmap+0xf2/0x10c
>  [<ffffffff8040a986>] tg3_poll+0xe8/0x822
>  [<ffffffff803abe2f>] mix_pool_bytes_extract+0x5c/0x155
>  [<ffffffff80540e42>] net_rx_action+0x9d/0x170

very nice! I like this approach - and have a few comments on some 
details - will post them as a reply to the patchs.

	Ingo
