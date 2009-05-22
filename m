Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbZEVIDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbZEVIDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbZEVID2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:03:28 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:3977 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbZEVID0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:03:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ehv8lGiEXWLG3SYdycrlPOT7wCBgXcJIQC/wPBG79irlYRq/+/L9JqFFswHA2wwD8r
         KXhUOxiuduxlNpogNiy5gmAlRzAyurUx9S46tYVCUYCMPW5esNDPu3W3RaZlwS5PdDpk
         KYkGJYP6xZZy+r4aA7bvwhKATxWpQk1z8YRX0=
MIME-Version: 1.0
In-Reply-To: <4A133DEF.6080604@gmail.com>
References: <4A133DEF.6080604@gmail.com>
Date: Fri, 22 May 2009 16:03:26 +0800
X-Google-Sender-Auth: 234caad7db627d26
Message-ID: <2a27d3730905220103k12d7f9a6n269fcd079818b168@mail.gmail.com>
Subject: Re: [PATCH] freescale: beyond ARRAY_SIZE of fdev->chan
From: Li Yang <leoli@freescale.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linuxppc-dev@ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 7:17 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> Do not go beyond ARRAY_SIZE of fdev->chan
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Indeed, thanks.

But I would like the title and description of this patch be changed to
like this:

fsldma: fix check on potential fdev->chan[] overflow

Fix the check of potential array overflow when using corrupted channel
device tree nodes.

> ---
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index da8a8ed..391b1bd 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -830,7 +830,7 @@ static int __devinit fsl_dma_chan_probe(struct fsl_dma_device *fdev,
>                        new_fsl_chan->reg.end - new_fsl_chan->reg.start + 1);
>
>        new_fsl_chan->id = ((new_fsl_chan->reg.start - 0x100) & 0xfff) >> 7;
> -       if (new_fsl_chan->id > FSL_DMA_MAX_CHANS_PER_DEVICE) {
> +       if (new_fsl_chan->id >= FSL_DMA_MAX_CHANS_PER_DEVICE) {
>                dev_err(fdev->dev, "There is no %d channel!\n",
>                                new_fsl_chan->id);
>                err = -EINVAL;
