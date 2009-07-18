Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbZGRQBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbZGRQBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 12:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZGRQBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 12:01:32 -0400
Received: from mail-vw0-f177.google.com ([209.85.212.177]:61948 "EHLO
	mail-vw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZGRQBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 12:01:31 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jul 2009 12:01:11 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Sz1KGSBQwFzBEhdve+2Fs2Xg+RVv69fFFB418zdhXW2EY3XkHqbVuAEUpoASVec2Cb
         FwAhaB+Uxk5eABZ2OdzftqY/4s2MwNPeMWLNhk0SjF/hHRlb3EMbs63sBJTiM9bat0Sg
         36f86FzbnLHhX9DvEnGhhknYzUL58oIF5glDQ=
MIME-Version: 1.0
In-Reply-To: <1246641873-21686-1-git-send-email-nicolas.ferre@atmel.com>
References: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
	 <1246641873-21686-1-git-send-email-nicolas.ferre@atmel.com>
Date: Sat, 18 Jul 2009 09:01:31 -0700
X-Google-Sender-Auth: 10f2170435bd4729
Message-ID: <e9c3a7c20907180901u3670a8edy2bc5c1b5cf911ab4@mail.gmail.com>
Subject: Re: [PATCH 1/2 v3] dmaengine: at_hdmac: new driver for the Atmel AHB 
	DMA Controller
From: Dan Williams <dan.j.williams@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: maciej.sosnowski@intel.com, avictor.za@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 10:24 AM, Nicolas Ferre<nicolas.ferre@atmel.com> wrote:
> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is availlable on
> at91sam9rl chip. It will be used on other products in the future.
>
> This first release covers only the memory-to-memory tranfer type. This is the
> only tranfer type supported by this chip.  On other products, it will be used
> also for peripheral DMA transfer (slave API support to come).
>
> I used dmatest client without problem in different configurations to test it.
>
> Full documentation for this controller can be found in the SAM9RL datasheet:
> http://www.atmel.com/dyn/products/product_card.asp?part_id=4243
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> v2 is here:
> http://lkml.org/lkml/2009/6/26/104
>
> v2 -> v3:
>  - initial number of descriptors to allocate for each channel raised to 64 and
>   is now a parameter
>  - ack-bit in descriptor flag comment synchronized with TXx9 dma driver
>  - atc_desc_get() when short on descriptors in pool: create one at a time
>  - allocation flag changed to GFP_ATOMIC in atc_desc_get()
>  - call to proper funtion while unmapping: use of new
>   DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE flags
>  - call dma_run_dependencies() at the end of atc_chain_complete()
>

Looks good, but now I belatedly wonder if that GFP_ATOMIC should be
GFP_NOWAIT instead?  Do we really want to consume from the system
emergency pools for these allocations (a similar fix is need for
ioatdma and fsldma)?

Thanks,
Dan
