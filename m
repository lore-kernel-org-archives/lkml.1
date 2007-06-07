Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbXFGMwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbXFGMwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 08:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbXFGMwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 08:52:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53532 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbXFGMwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 08:52:36 -0400
Subject: Re: drivers/media/dvb/b2c2/flexcop-dma.c uses PCI DMA API
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706062106150.30244@anakin>
References: <Pine.LNX.4.64.0706062106150.30244@anakin>
Content-Type: text/plain; charset=utf-8
Date: Thu, 07 Jun 2007 09:50:56 -0300
Message-Id: <1181220656.4187.64.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Em Qua, 2007-06-06 às 21:11 +0200, Geert Uytterhoeven escreveu:
> 	Hi,
> 
> drivers/media/dvb/b2c2/flexcop-dma.c uses the PCI DMA API, but DVB_B2C2_FLEXCOP
> doesn't depend on PCI, causing the following problem on PCI-less systems:
> 
> | linux/drivers/media/dvb/b2c2/flexcop-dma.c:20: warning: implicit declaration of function 'pci_alloc_consistent'
> | linux/drivers/media/dvb/b2c2/flexcop-dma.c:20: warning: implicit declaration of function 'pci_alloc_consistent'
> 
> Apparently this is the flexcop DMA core, which is used by both
> DVB_B2C2_FLEXCOP_PCI and DVB_B2C2_FLEXCOP_USB.
> 
> DVB_B2C2_FLEXCOP_PCI depends on PCI.
> DVB_B2C2_FLEXCOP_USB depends on USB.

Thanks for pointing us about this issue. While the usage of the generic
dma is the better way, a simple fix can be applied by simply moving
flexcop-dma to b2c2-flexcop-pci (currently, only the last uses the DMA
stuff). I've committed such patch. It is available at:

http://linuxtv.org/hg/v4l-dvb/rev/c314ec17335a

 
Cheers,
Mauro

