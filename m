Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYBKQzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYBKQzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758898AbYBKQzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:55:13 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43949 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbYBKQzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:55:11 -0500
Subject: Re: [PATCH?][arch/parisc/kernel/pci-dma.c]
	pcxl_dma_ops.alloc_noncoherent = pa11_dma_alloc_consistent?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Roel Kluin <12o3l@tiscali.nl>, kyle@parisc-linux.org,
       grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080211164215.GM5299@parisc-linux.org>
References: <47B07685.5000606@tiscali.nl>
	 <20080211164215.GM5299@parisc-linux.org>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 10:55:04 -0600
Message-Id: <1202748904.3122.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 09:42 -0700, Matthew Wilcox wrote:
> On Mon, Feb 11, 2008 at 05:23:33PM +0100, Roel Kluin wrote:
> > duplicate pa11_dma_alloc_consistent; more appropriate appears
> > pa11_dma_alloc_noncoherent here. 
> > 
> > Not tested, please confirm that this fix is correct
> 
> I don't think it is.  The memories are fading, so I don't recall why it
> is we do it this way, but I'm pretty sure it's correct the way it is.

dma_alloc_noncoherent is a fallback for boxes with coherency problems
which cannot allocate coherent memory.  The API asks for coherent memory
but the driver promises to behave correctly even if an incoherent area
is returned.  dma_alloc_coherent() requires only coherent memory.  The
pcx boxes (PA7200 and below) can't do the uncached trick for coherent
memory, so the API is designed for them.  The PCXL can, so we allocate
coherent memory even for dma_alloc_noncoherent() in that case (and nop
out the coherency handlers the driver uses).

James


