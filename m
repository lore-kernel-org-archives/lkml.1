Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbZKQR6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbZKQR6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZKQR6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:58:13 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40257 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbZKQR6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:58:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=gf7Fgg47ZiQ/CtEhHbGS/22ykhAL4EWuRNHfklyQLVb2A1/EuErVzYrUMhgDvElwDh
         4YIU+NdO6Ik85L3ulOhDjZ0EGAnskDFI1ULl5fAjxZMbWyv4Wi+ZRQNdQQK2JQj0BUo5
         /lo43aJ7BL9AmwMMuReYuX6QRwrhafYwQqUS8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/5] pata_sis: Implement MWDMA for the UDMA 133 capable chips
Date: Tue, 17 Nov 2009 18:57:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911171827.29891.bzolnier@gmail.com> <20091117173823.217b95a7@lxorguk.ukuu.org.uk>
In-Reply-To: <20091117173823.217b95a7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911171857.01805.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009 18:38:23 Alan Cox wrote:
> > > +static int mwdma_clip_to_pio(struct ata_device *adev)
> > > +{
> > > +	const int mwdma_to_pio[3] = {
> > > +		XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
> > > +	};
> > > +	return min(mwdma_to_pio[adev->dma_mode - XFER_MW_DMA_0],
> > > +				adev->pio_mode - XFER_PIO_0);
> > > +}
> > 
> > This wants to be in the generic libata code.
> 
> I'm not convinced because for the majority of drivers the libata timing
> interface handles it. SiS needs it just because it does things by
> precomputed tables. It's a one off interface.

Controllers based on *Intel* PIIX are in the disagreement with the above
paragraph and having generic helper to do conversion (without a clipping)
would bring us a little step closer to killing a needless code duplication
currently present in their ->set_piomode and ->set_dmamode methods.

[ In case somebody wonders: no, 'old' drivers don't have such duplication
  and 'whoever did it didn't port it across' cause said 'whoever'-s were not
  into the development of the square wheels.... ]

-- 
Bartlomiej Zolnierkiewicz
