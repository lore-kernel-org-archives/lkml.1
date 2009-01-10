Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZAJAkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZAJAkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZAJAj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:39:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:54574 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbZAJAj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:39:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=UH0OXwkz7DI4QtxogspLsF3jQnTHiGHB3yIJGTOKr7eE/flNHmjqUXk83ZvebHcszZ
         qNyTGHntiy2+hbjtn0TZoEdnjf7TPVhgV5J/mMKmBlXrWwf+BDVYQPdjYyocEABMZpo0
         1rrheGP4atRLavSgdKyGL9ZwIuBXfe4nmpYXc=
Message-ID: <e9c3a7c20901091639r3cd9bb64radb319691a5beee2@mail.gmail.com>
Date: Fri, 9 Jan 2009 17:39:56 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] dmatest: flush and invalidate destination buffer before DMA
Cc: haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, ralf@linux-mips.org
In-Reply-To: <20090109.173057.25877173.nemoto@toshiba-tops.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090108.134336.127659765.nemoto@toshiba-tops.co.jp>
	 <20090108093603.691c1200@hskinnemoen-d830>
	 <e9c3a7c20901080920r1051775ey7dbb4fad37b2810@mail.gmail.com>
	 <20090109.173057.25877173.nemoto@toshiba-tops.co.jp>
X-Google-Sender-Auth: 989e64f392e3e7c4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2009 at 1:30 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> Do you mean something like this?

Yes, exactly.

>
>                dmatest_init_srcbuf(thread->srcbuf, src_off, len);
>                dmatest_init_dstbuf(thread->dstbuf, dst_off, len);
>
>                dma_src = dma_map_single(dev->dev, src + src_off, len,
>                         DMA_TO_DEVICE);
>                dma_dest = dma_map_single(dev->dev, dest_buf, test_buf_size,
>                        DMA_BIDIRECTIONAL);
>                tx = dev->device_prep_dma_memcpy(chan, dma_dest + dst_off,
>                                dma_src, len,
>                                DMA_CTRL_ACK | DMA_COMPL_SKIP_DEST_UNMAP);
>                if (!tx) {
>                        /* error */
>                }
>                tx->callback = NULL;
>                cookie = tx->tx_submit(tx);
>                ...
>                /* wait for completion */
>                ...
>                dma_unmap_single(dev->dev, dma_dest, test_buf_size,
>                        DMA_BIDIRECTIONAL);
>
> It will make dmatest more aggressive, for example, a option for
> testing DMA_PREP_INTERRUPT handling of a lowlevel driver can be added
> easily.
>

Yes, and it will also allow testing of corner cases like dependency
chains and other async_tx api driver-assumptions.

Thanks,
Dan
