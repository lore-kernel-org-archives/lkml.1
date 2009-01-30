Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbZA3X2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbZA3X2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZA3X1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:27:49 -0500
Received: from mail.gmx.net ([213.165.64.20]:48468 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753872AbZA3X1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:27:48 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+y+gpy+YayDhVvQ2BjASMcG9KVRKE3CcHDLrVdhX
	PAZg9Pe7IbnxMg
Date: Sat, 31 Jan 2009 00:27:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, maciej.sosnowski@intel.com,
       hskinnemoen@atmel.com, nicolas.ferre@atmel.com
Subject: Re: [PATCH 07/13] dmaengine: introduce dma_request_channel and 
 private channels
In-Reply-To: <e9c3a7c20901301513v74953d7aj8533d05cddfa510@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901310026200.4617@axis700.grange>
References: <20081114213453.32354.53002.stgit@dwillia2-linux.ch.intel.com> 
 <Pine.LNX.4.64.0812021642120.5663@axis700.grange> 
 <e9c3a7c20812020916ud0b426cvd0764f23a97973ad@mail.gmail.com> 
 <20090131.020300.82352947.anemo@mba.ocn.ne.jp>
 <e9c3a7c20901301513v74953d7aj8533d05cddfa510@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, Dan Williams wrote:

> On Fri, Jan 30, 2009 at 10:03 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > I'm writing a new dma driver.  My DMAC has multiple channels and only
> > one channel is capable for generic memcpy and other channels have
> > fixed role.
> >
> > Does new framework allow dma driver make only one channel public?
> 
> Yes, if the driver registers a dma_device for each channel.
> 
> > Or should I register two dma_device for DMA_MEMCPY and DMA_SLAVE?
> > Could you give me some advice?
> 
> Register multiple dma_devices, the public one with a DMA_MEMCPY, and
> the fixed role devices with DMA_PRIVATE, DMA_MEMCPY, and DMA_SLAVE
> capabilities.
> 
> DMA_PRIVATE ensures that a channel is never considered for public consumption.

Maybe just two dma-devices would suffice: one with the public memcpy 
channel, and one with the rest private slave channels?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
