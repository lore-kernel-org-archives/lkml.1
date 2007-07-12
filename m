Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbXGLGbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbXGLGbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758063AbXGLGbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:31:17 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:49267 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbXGLGbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:31:15 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH 3/4] Extend the DMA-engine API.
Date: Thu, 12 Jul 2007 14:31:05 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C6F3DFA@zch01exm26.fsl.freescale.net>
In-Reply-To: <e9c3a7c20707110956r5ea91fd1q1d0b33b9583fe91c@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4] Extend the DMA-engine API.
Thread-Index: AcfD3HLe/CQhfaBlRPayHo3ToOCzgQAcUjkQ
References: <11840607111926-git-send-email-wei.zhang@freescale.com> <e9c3a7c20707101141m17e313e2k99be5b7197edc910@mail.gmail.com> <46B96294322F7D458F9648B60E15112C6F3CED@zch01exm26.fsl.freescale.net> <e9c3a7c20707110956r5ea91fd1q1d0b33b9583fe91c@mail.gmail.com>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: <akpm@linux-foundation.org>, <paulus@samba.org>,
       <galak@kernel.crashing.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>, <shannon.nelson@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan,

Thanks! I get it.
It's so lucky we have the same target.
When your patch could be accepted?

Cheers,
Wei. 

> -----Original Message-----
> From: dan.j.williams@gmail.com 
> [mailto:dan.j.williams@gmail.com] On Behalf Of Dan Williams
> Sent: Thursday, July 12, 2007 12:57 AM
> To: Zhang Wei-r63237
> Cc: akpm@linux-foundation.org; paulus@samba.org; 
> galak@kernel.crashing.org; linuxppc-dev@ozlabs.org; 
> linux-kernel@vger.kernel.org; shannon.nelson@intel.com
> Subject: Re: [PATCH 3/4] Extend the DMA-engine API.
> 
> On 7/11/07, Zhang Wei-r63237 <Wei.Zhang@freescale.com> wrote:
> > Hi, Dan,
> >
> > Do you mention here: 
> http://marc.info/?l=linux-raid&m=118290909614463&w=2 ?
> > I see the async_tx is located at crypto/ of the above page, 
> but my patch is for DMA engine in drivers/dma and for DMA 
> engine driver.
> >
> > Thanks!
> > Wei.
> 
> Hi Wei,
> 
> I was referring to:
> http://marc.info/?l=linux-raid&m=118290909528910&w=2
> 
> async_tx is an api that exploits the raw capabilities of the new
> dmaengine interface.  For your case when the existing api calls do not
> provide the proper interface you can open code something like the
> following:
> 
> tx = dev->device_prep_dma_<operation>(chan, len, int_flag)
> tx->tx_set_src(dma_addr_t, tx, index /* for multi-source ops */)
> tx->tx_set_dest(dma_addr_t, tx, index)
> tx->tx_submit(tx)
> 
> The expectation is that the most common usages of dmaengines will use
> async_tx calls, or the 'dma_async_memcpy_foo_to_bar' helper routines.
> 
> --
> Dan
> 
