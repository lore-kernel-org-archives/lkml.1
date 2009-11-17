Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZKQR2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZKQR2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZKQR2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:28:39 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43221 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZKQR2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:28:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=k05JSrt2gsm93Jr0zgmuog63AoEtZ9s5gVCliQX2lce3b1CS5sGBOfiZC8CeGCm9h3
         Sfn7lBh2gpcJDDkH8t2lcYGjtCCrD8ukCbewprqpHaUE4LxuBDq7BCS1kWAojbF5A/Mv
         oJQzXAVlRZF7dWwfnZ0igQgB6YglZLk4ruNx4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 2/5] pata_sis: Implement MWDMA for the UDMA 133 capable chips
Date: Tue, 17 Nov 2009 18:27:29 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <20091117145111.15430.67106.stgit@localhost.localdomain>
In-Reply-To: <20091117145111.15430.67106.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911171827.29891.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009 15:51:17 Alan Cox wrote:
> Bartlomiej pointed out that while this got fixed in the old driver whoever
> did it didn't port it across.

Please add ',' before 'whoever' and change 'the old driver' to 'sis5513'
so it is at least passable as 'information manipulation' on what I really
said instead of just being a 'straight lie'..  Thanks!

> +/**
> + *	mwdma_clip_to_pio		-	clip MWDMA mode
> + *	@adev: device
> + *
> + *	As the SiS shared MWDMA and PIO timings we must program the equivalent
> + *	PIO timing for the MWDMA mode but we must not program one higher than
> + *	the permitted PIO timing of the device.
> + */
> +
> +static int mwdma_clip_to_pio(struct ata_device *adev)
> +{
> +	const int mwdma_to_pio[3] = {
> +		XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
> +	};
> +	return min(mwdma_to_pio[adev->dma_mode - XFER_MW_DMA_0],
> +				adev->pio_mode - XFER_PIO_0);
> +}

This wants to be in the generic libata code.

-- 
Bartlomiej Zolnierkiewicz
