Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbXJXP4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbXJXP4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbXJXP4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:56:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:10261 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbXJXPz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Lc58rNyIvbrO6OgHpUFLnNK0huMfLNIbC0c8CjzEmgatVmdhlYJMpSaXeaZW9Pq1Pxnmi6NGlJ6C5IO5zVoPfyNJ9+EMuAyLRkKjT4dlmj9aeHMwg6yYzT2lLeXISAD7LId6t/h94bZOehtpzoniOZOJfW12CKqxNDvV72faEVY=
Message-ID: <e9c3a7c20710240855j7bf1f0a6qa1d11af3a12910e5@mail.gmail.com>
Date: Wed, 24 Oct 2007 08:55:58 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH] DMA: Correct invalid assumptions in the Kconfig text
Cc: "Shannon Nelson" <shannon.nelson@intel.com>, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <1193218705-16685-1-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193218705-16685-1-git-send-email-hskinnemoen@atmel.com>
X-Google-Sender-Auth: 34c18c6d9756419a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haavard,

On 10/24/07, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> This patch corrects what I hope are invalid assumptions about the DMA
> engine layer: Not only Intel(R) hardware can do DMA, and DMA can be
> used for other things than memcpy and RAID offloading.
>
> At the same time, make the DMA Engine menu visible again on AVR32. I'm
> currently working on a driver for a DMA controller that can do
> mem-to-mem transfers (which is supported by the framework) as well as
> device-to-mem and mem-to-device transfers (not currently supported.)
>
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
> Don't get me wrong; I think Intel deserves lots of respect for
> creating this framework. But this is also why I got a bit disappointed
> when I discovered that it seems to be less generic than I initially
> hoped.
>

Patches welcome :-)

> DMA controllers, which may support plain memcpy acceleration in
> addition to more traditional "slave DMA", are very common in SoC
> devices, and I think Linux needs a common framework for it. The
> existing DMA Engine framework seems to come pretty close already, but
> I think it needs more input from the embedded crowd before it can be
> completely usable on a large number of embedded systems.
>

Part of the problem of supporting slave/device DMA along side generic
memcpy/xor/memset acceleration is that it adds a number of caveats and
restrictions to the interface.  One idea is to create another client
layer, similar to async_tx, that can handle the architecture specific
address, bus, and device pairing restrictions.  In other words make
device-dma a superset of the generic offload capabilities and move it
to its own channel management layer.

> I'm not going to suggest any changes to the actual framework for
> 2.6.24, but I think the _intention_ of the framework needs to be
> clarified.
>

Should this patch wait until the framework has been extended?

Otherwise, Acked-by: Dan Williams <dan.j.williams@intel.com>

> Haavard
>

Regards,
Dan
