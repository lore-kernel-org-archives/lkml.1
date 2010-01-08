Return-Path: <linux-kernel-owner+w=401wt.eu-S1751715Ab0AHIwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab0AHIwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465Ab0AHIw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:52:29 -0500
Received: from sh.osrg.net ([192.16.179.4]:49218 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab0AHIw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:52:29 -0500
Date: Fri, 8 Jan 2010 17:52:20 +0900
To: adharmap@codeaurora.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: RFC non barrier versions of dma_map functions 
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B4279A1.4090706@codeaurora.org>
References: <4B4279A1.4090706@codeaurora.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100108175201Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 08 Jan 2010 17:52:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jan 2010 15:28:33 -0800
Abhijeet Dharmapurikar <adharmap@codeaurora.org> wrote:

>    This is a request for extending the DMA api for efficient handling of 
> multiple buffers or scatter gather mapping/unmapping operations.
> 
>    I am based on an ARMv7 device and we have a situation where we need 
> to dma map multiple cached buffers for a single dma transaction.
> 
>    The current DMA api suggests the use of dma_map_single/ 
> dma_unmap_single for cache consistency. On ARMv7 it performs the 
> necessary cache-operations and calls data sync barrier instruction 
> (DSB). In our case we would be executing multiple DSB instructions
> before starting the dma operation - we need memory to be consistent
> only after we map the last buffer.

dma_map_sg? dma_map_sg requires the buffers to be consistent only
after it maps the last buffer, I think (I guess that you mean
'consistent' buffer is 'DMA ready' wrt cache).
