Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbXDMTTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbXDMTTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932263AbXDMTTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:19:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:58703 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932318AbXDMTTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:19:07 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/v2kszpwHv6lmIfeDQTz5rS0jMwvNfmwHGx8ABWy
	x1o7cBKldGEZh5
Date: Fri, 13 Apr 2007 21:19:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: James Bottomley <James.Bottomley@SteelEye.com>, Greg KH <greg@kroah.com>,
       Eric Miao <eric.y.miao@gmail.com>
Subject: dma_declare_coherent_memory() for accessing platform-wide memory
Message-ID: <Pine.LNX.4.60.0704132018100.5919@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On a PXA270 based system I modified the framebuffer driver to use SRAM on 
the SoC to reduce bus load caused by DMA transfers. For this I just 
assigned the entire SRAM to the fb driver. It works.

Then Eric Miao (CCed) rightfully noticed, that other devices might also 
benefit from using SRAM. So, I started thinking about creating a special 
(platform) device owning that SRAM block and making all its potential 
users its children. The device-local memory API even has provisional 
support for this with the DMA_MEMORY_INCLUDES_CHILDREN flag.

But there are problems with this approach too. For example, some PXA 
machines already occupy framebuffer's parent. I think, they are fixing 
power up/down sequence problems in this way, but I am not sure that's a 
good idea from the point of view of the bus locality.

Otherwise, maybe the best way would be assigning that SRAM block to the 
struct device platform_bus directly? But that way all platform devices 
would get their DMA buffers from that (rather small) block on the "first 
come first served" basis.

What would be the best way to solve this?

Thanks
Guennadi
---
Guennadi Liakhovetski
