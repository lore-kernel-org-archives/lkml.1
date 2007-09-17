Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbXIQSO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbXIQSO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbXIQSOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:14:52 -0400
Received: from gw.goop.org ([64.81.55.164]:43651 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbXIQSOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:14:51 -0400
Message-ID: <46EEC418.6070005@goop.org>
Date: Mon, 17 Sep 2007 11:14:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: bbpetkov@yahoo.de
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] unify DMA_..BIT_MASK definitions
References: <20070917175139.GA4941@gollum.tnic>
In-Reply-To: <20070917175139.GA4941@gollum.tnic>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> This patches remove redundant DMA_..BIT_MASK definitions across two drivers.
> First off, consolidate dma bitmask definitions in the proper header file...
>
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
>
> --
> Index: 23-rc6/include/linux/dma-mapping.h
> ===================================================================
> --- 23-rc6/include/linux/dma-mapping.h.orig	2007-09-17 17:48:20.000000000 +0200
> +++ 23-rc6/include/linux/dma-mapping.h	2007-09-17 19:34:21.000000000 +0200
> @@ -17,6 +17,7 @@
>  #define DMA_48BIT_MASK	0x0000ffffffffffffULL
>  #define DMA_40BIT_MASK	0x000000ffffffffffULL
>  #define DMA_39BIT_MASK	0x0000007fffffffffULL
> +#define DMA_35BIT_MASK	0x00000007ffffffffULL
>  #define DMA_32BIT_MASK	0x00000000ffffffffULL
>  #define DMA_31BIT_MASK	0x000000007fffffffULL
>  #define DMA_30BIT_MASK	0x000000003fffffffULL
>   

Hm.  Wouldn't it be better to define something like

#define DMA_BIT_MASK(x)    ((1ull<<(x))-1)

and then define everything in terms of that (or just use it directly and
deprecate the DMA_XXBIT_MASK macros)?

    J
