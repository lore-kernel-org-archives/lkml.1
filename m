Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYKFVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYKFVQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYKFVQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:16:03 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:34832 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYKFVQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:16:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lieM34aJ8ytaf7i/89mBhA40Vyd8DWLoCv0foRhy1y/qbcU5btwtYMDYaujJM079o8
         3nCe3LN6/C9UTBXXdbuecLS7VMDSnAtiSaU7nEz7U0yU3B7Ei435q+LPF7jCkMG8iAV/
         r6Ypl0alF24ZcO+JOeedtwwdawHUCgwUHqU9I=
Message-ID: <8bd0f97a0811061316u6b9a330dy279cb7dca679ab73@mail.gmail.com>
Date: Thu, 6 Nov 2008 16:16:00 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] ssb: Fix DMA-API compilation for non-PCI systems
Cc: "John Linville" <linville@tuxdriver.com>,
       "Mike Frysinger" <vapier@gentoo.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200811062149.21841.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811062149.21841.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 15:49, Michael Buesch wrote:
> --- wireless-testing.orig/include/linux/ssb/ssb.h       2008-08-01 17:26:05.000000000 +0200
> +++ wireless-testing/include/linux/ssb/ssb.h    2008-11-06 21:45:37.000000000 +0100
> @@ -427,12 +427,16 @@ static inline int ssb_dma_mapping_error(
>  {
>        switch (dev->bus->bustype) {
>        case SSB_BUSTYPE_PCI:
> +#ifdef CONFIG_SSB_PCIHOST
>                return pci_dma_mapping_error(dev->bus->host_pci, addr);
> +#endif
> +               break;
>        case SSB_BUSTYPE_SSB:
>                return dma_mapping_error(dev->dev, addr);
>        default:
> -               __ssb_dma_not_implemented(dev);
> +               break;
>        }

all these functions now read:
default: break;
seems kind of pointless ... why not just drop that case completely

otherwise looks good, thanks
-mike
