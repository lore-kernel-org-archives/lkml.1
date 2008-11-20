Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYKTVBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYKTVBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbYKTVB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:01:28 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:42263 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbYKTVB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WI3xPuCxsHLPkxx+bFDSBlZN2XDhtsn6Hlow+zT03BBuU8i4D2MvSatzB9C0D/akbK
         ZkvFuSPm+VPv9dAz9EAdCvenHe5pIouTv2NI76sDzw1ppAB9Ye12NGNCMJqF1szqD4lV
         TqotkNCDBFGGAIIc4H9Ou/qvo5yZqkBr5+zr4=
Message-ID: <8bd0f97a0811201258j14dfcf46vce1655632bb12e2@mail.gmail.com>
Date: Thu, 20 Nov 2008 15:58:13 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 01/16] Blackfin SPI Driver: ensure cache coherency before doing DMA
Cc: "Bryan Wu" <cooloney@kernel.org>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Vitja Makarov" <vitja.makarov@gmail.com>
In-Reply-To: <200811201224.15493.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
	 <1226994760-4301-2-git-send-email-cooloney@kernel.org>
	 <200811201224.15493.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 15:24, David Brownell wrote:
> On Monday 17 November 2008, Bryan Wu wrote:
>>                         /* set transfer mode, and enable SPI */
>>                         dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
>>
>> +                       /* invalidate caches, if needed */
>> +                       if (bfin_addr_dcachable((unsigned long) drv_data->rx))
>> +                               invalidate_dcache_range((unsigned long) drv_data->rx,
>> +                                                       (unsigned long) (drv_data->rx +
>> +                                                       drv_data->len));
>
> Could you explain why you're not using dma_map_*() calls
> or the rx_dma (and tx_dma) addresses the caller may pass?

i'm not familiar with said API.  i worked with what was there already.

> As a rule, you should use the standard kernel interfaces
> for such stuff instead of platform-specific calls like
> those two.  There are a LOT more developers who can find
> and fix bugs that way.

could you elaborate on the common calls that would replace these ?

> Also, this patch affects the "not full duplex" branch of
> this routine.  DMA here seems unusually convoluted ... but
> if you didn't invalidate the cache (RX path) before
> flushing it (TX path) and instead did it the other way
> aroound, would you actually *need* separate branches?

it's convoluted because the hardware sucks.  it cant do full duplex
with DMA.  full duplex only works in the non-DMA case.
-mike
