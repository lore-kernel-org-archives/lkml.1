Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbZFPIMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbZFPIMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZFPIMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:12:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:57614 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbZFPIMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:12:18 -0400
Date: Tue, 16 Jun 2009 17:12:14 +0900
To: malcolm.blaney@maptek.com.au
Cc: linux-kernel@vger.kernel.org
Subject: Re: is_device_dma_capable
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <2e115de50906160024r7c3140d6sc8744e4362d36ef8@mail.gmail.com>
References: <2e115de50906160024r7c3140d6sc8744e4362d36ef8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090616171029H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 16 Jun 2009 17:12:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 16:54:24 +0930
Malcom Blaney <malcolm.blaney@maptek.com.au> wrote:

> I'm using the parport_pc driver with a dma buffer, which is provided
> by calling dma_alloc_coherent in arch/x86/include/asm/dma-mapping.h.
> 
> This is no longer working for me in 2.6.29.2, the previous version I
> was using is 2.6.25.10, which was fine with the same hardware.
> 
> The problem is that the call to is_device_dma_capable returns false,
> so dma_alloc_coherent returns NULL. Do I need to set the dma_mask in
> the driver for this to work correctly?

You use X86_32, right?

In 2.6.25, X86_32 and X86_64 had the own dma_alloc_coherent
implementations; X86_32 accepted a device having dma_mask that is not
initialized however X86_64 didn't, I think.

When we merged them, we chose to prohibit a device having dma_mask
that is not initialized. I'm not sure the DMA docs say this but IMO
it's good to require drivers to set up dma_mask (and
coherent_dma_mask) properly if the drivers want DMA.
