Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbXJCK6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbXJCK6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbXJCK5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:57:54 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:51836 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbXJCK5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:57:53 -0400
Date: Wed, 3 Oct 2007 11:57:51 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: veerasena reddy <veerasena_b@yahoo.co.in>
Cc: linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux cache routines for Write-back cache policy on  MIPS24KE
Message-ID: <20071003105751.GD29244@linux-mips.org>
References: <20071001105954.GB23647@linux-mips.org> <535696.48077.qm@web8403.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535696.48077.qm@web8403.mail.in.yahoo.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 01:10:59PM +0100, veerasena reddy wrote:

> Is there any problem if we use the below API's in
> linxu-2.6.18 
>   - dma_cache_wback_inv()
>   - dma_cache_wback()
>   - dma_cache_inv()
> 
> functionality wise, especially in r4k.c i dont see any
> difference between the implementation of these APIs.
> 
> Can we apply the 2.6.24 patch to kill these APIs on
> 2.6.18 kernel? In this case what APIs i can use for
> writeback, invalidation or both?
> 
> I couldn't find any info. related to the above API in
> DMA-API.txt. Could you please give some pointers on
> the usage/working of these APIs.

dma_cache_* were never documented.  They respresent the earliest attempt
at coming up with an API that enables portable drivers and it has a few
shortcomings and like so many early things it was never formally documented,
so don't expect any well defined semantics.  The functions never got
formally retired probably because it somehow managed to stay under the
radar.

Any drivers should use the APIs documented in Documentation/DMA-API.txt
only.  The almost equivalent operation for dma_cache_* would be
dma_sync_single and dma_sync_sg.

Don't even dream about using dma_cache_* for anything but DMA coherency.
They're all internal low level APIs which know nothing about Linux's
virtual memory system.

Anyway, it would be much easier to help you if we knew what you are trying
to achieve with these functions.

  Ralf
