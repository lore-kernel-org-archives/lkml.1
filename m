Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab0BBMJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 07:09:01 -0500
Received: from www.tglx.de ([62.245.132.106]:42987 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab0BBMI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 07:08:57 -0500
Date: Tue, 2 Feb 2010 13:08:45 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [PATCH] isp1760: Flush the D-cache for the pipe-in transfer buffers
Message-ID: <20100202120845.GA7210@www.tglx.de>
References: <20100202111135.18636.62688.stgit@pc1117.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100202111135.18636.62688.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Catalin Marinas | 2010-02-02 11:11:35 [+0000]:

>When the HDC driver writes the data to the transfer buffers it pollutes
>the D-cache (unlike DMA drivers where the device writes the data). If
>the corresponding pages get mapped into user space, there are no
>additional cache flushing operations performed and this causes random
>user space faults on architectures with separate I and D caches
>(Harvard) or those with aliasing D-cache.

After looking through lib/scatterlist.c it uses 
#include <linux/highmem.h>

and 

flush_kernel_dcache_page().
Wouldn't this do the job here as well?

Sebastain
