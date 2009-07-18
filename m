Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZGRSZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZGRSZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 14:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZGRSZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 14:25:12 -0400
Received: from mail-vw0-f173.google.com ([209.85.212.173]:58390 "EHLO
	mail-vw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbZGRSZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 14:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=il2byALBq2/zpyCaxnpdKD8rsm1fDUDRCp0V2zDSZ+ncd7LPRkK3q0q2z48L0RK4g7
         LbAFooIs0A8L+4xOwtydRUjAcqXCBsV8TF26bT9iNDdYmlpsdj1AZBaazXTxkQmNe00a
         5pbcwQdBQbAW/LFoPO4QquYi1LiadvnoPpPzE=
MIME-Version: 1.0
In-Reply-To: <35e3b0c00907170333p79c5387bk72f9df453bc0ec83@mail.gmail.com>
References: <35e3b0c00907170333p79c5387bk72f9df453bc0ec83@mail.gmail.com>
Date: Sat, 18 Jul 2009 11:25:10 -0700
X-Google-Sender-Auth: 3f4bc7fa59292f34
Message-ID: <e9c3a7c20907181125j2df722fdh2fd4f50ad7d74d48@mail.gmail.com>
Subject: Re: Intended usage of the dmaengine
From: Dan Williams <dan.j.williams@intel.com>
To: Per Forlin <per.lkml@gmail.com>
Cc: haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 3:33 AM, Per Forlin<per.lkml@gmail.com> wrote:
> Hi,
>
> I work with Linux in embedded systems and I got more interested in
> dmaengine after Haavard Skinnemoen added the DMA SLAVE support. DMA
> SLAVE opens up the dmaengine for embedded users and I wonder if there
> is more room for support towards the embedded world. I've made a test
> implementation of the dmaengine for our DMAC. Some parts that weren't
> supported by the dmaengine had to be exported by the driver code. A
> similar example of this is cyclic DMA jobs in dw_dmac.h.
> Is this the preferable way to handle it? Or could this functionality
> be added to the dmaengine instead?
>
> Additional support that I would like to have in the "struct dma_engine" is
> * stopping the dma channel transfer
> * continue a stopped transfer
> * PER2PER transfers (dma transfer between two peripherals)
> * dma transfers from phy mem to per, and per to phy mem
> * function to return the transfer count of an active dma transfer
> (useful when the dma channel has been stopped deliberately)
>
> I am willing to propose and contribute updates to the dmaengine
> regarding this matter. With this email I would like to check with you
> whether these types of new support are welcome in the dmaengine.

I had a similar conversation with Ira Snyder recently as his DMA_SLAVE
implementation required architecture specific extensions.  The problem
is that once you step outside pure memory-to-memory offload the
implementation rapidly gets architecture specific and quirky very
quickly.  I am not convinced that it is worth the effort to shoehorn
functionality that is by definition architecture specific into a
generic api.  Outside of providing a channel allocation scheme and a
capability for maintaining some private context for a "slave-dma"
channel I do not see a consistent role for dmaengine to play in these
embedded usage models.  You can see that the ARM/pxa developers have
arrived at a similar conclusion and are not leveraging dmaengine for
their channel management.

So I would say keep those bits you mentioned above architecture
specific for now, if we start to see generic cross-architecture
duplication then we can think about up-leveling the implementation of
those pieces.

Regards,
Dan
