Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbYBKQq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbYBKQq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758853AbYBKQqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:46:06 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:53797 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810AbYBKQqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:46:05 -0500
Message-ID: <47B07BC4.9010901@tiscali.nl>
Date: Mon, 11 Feb 2008 17:45:56 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: kyle@parisc-linux.org, grundler@parisc-linux.org,
       linux-parisc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH?][arch/parisc/kernel/pci-dma.c] pcxl_dma_ops.alloc_noncoherent
 = pa11_dma_alloc_consistent?
References: <47B07685.5000606@tiscali.nl> <20080211164215.GM5299@parisc-linux.org>
In-Reply-To: <20080211164215.GM5299@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Feb 11, 2008 at 05:23:33PM +0100, Roel Kluin wrote:
>> duplicate pa11_dma_alloc_consistent; more appropriate appears
>> pa11_dma_alloc_noncoherent here. 
>>
>> Not tested, please confirm that this fix is correct
> 
> I don't think it is.  The memories are fading, so I don't recall why it
> is we do it this way, but I'm pretty sure it's correct the way it is.
> 
Maybe this helps a bit: later I found that something similar occurs in 
drivers/parisc/{ccio-dma.c, sba_iommu.c}:

1010: .alloc_consistent =     ccio_alloc_consistent,
      .alloc_noncoherent =    ccio_alloc_consistent,

1036: .alloc_consistent =     sba_alloc_consistent,
      .alloc_noncoherent =    sba_alloc_consistent,

However in these files the functions {ccio_alloc, sba_alloc}_noncoherent
do not exist.
