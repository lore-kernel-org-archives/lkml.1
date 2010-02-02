Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0BBP2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:28:50 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55001 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756149Ab0BBP2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:28:48 -0500
Subject: Re: [PATCH] isp1760: Flush the D-cache for the pipe-in transfer
	buffers
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
In-Reply-To: <20100202120845.GA7210@www.tglx.de>
References: <20100202120845.GA7210@www.tglx.de>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 02 Feb 2010 15:28:39 +0000
Message-Id: <1265124519.12634.80.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 15:28:40.0627 (UTC) FILETIME=[65BAF030:01CAA41C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 12:08 +0000, Sebastian Andrzej Siewior wrote:
> * Catalin Marinas | 2010-02-02 11:11:35 [+0000]:
> 
> >When the HDC driver writes the data to the transfer buffers it pollutes
> >the D-cache (unlike DMA drivers where the device writes the data). If
> >the corresponding pages get mapped into user space, there are no
> >additional cache flushing operations performed and this causes random
> >user space faults on architectures with separate I and D caches
> >(Harvard) or those with aliasing D-cache.
> 
> After looking through lib/scatterlist.c it uses
> #include <linux/highmem.h>
> 
> and
> 
> flush_kernel_dcache_page().
> Wouldn't this do the job here as well?

The documentation implies that this is to be used only with pages
obtained with kmap(), which doesn't seem to be the case here. On some
ARM processors it isn't even implemented (kunmap does the necessary
flushing).

-- 
Catalin

