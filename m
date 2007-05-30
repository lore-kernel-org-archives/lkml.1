Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXE3Ra2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXE3Ra2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXE3RaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:30:21 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:31377 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751733AbXE3RaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:30:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=enbsduArJC9kqAiIpLxRKEWjhth7swU94F83oBsbJp9e8KX5/65JJBvno8aKXveRCITryQB0caA8FizpEBPD6L/k8PFuG+AMSlgix2ME4n1z2qx+7eJM18ZwJfxU/kP0w3y5mZ1wppFAA+P+oDgiMfaC6wEF6KFeVm8tTxigBHg=  ;
X-YMail-OSG: UZ3A3wQVM1mnqMolJ5_xVLF3MZFfem1CzKKbtHAuSnzoujmrbUpF2ZdrG6CWx_SbERYqL30cjw--
From: David Brownell <david-b@pacbell.net>
To: "=?iso-8859-1?q?H=E5vard?= Skinnemoen" <hskinnemoen@gmail.com>
Subject: Re: [PATCH] atmel_spi: Pass correct DMA address to controller
Date: Wed, 30 May 2007 10:27:17 -0700
User-Agent: KMail/1.9.6
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>, wux@landicorp.com,
       linux-kernel@vger.kernel.org
References: <11793107892086-git-send-email-hskinnemoen@atmel.com> <200705161254.59308.david-b@pacbell.net> <1defaf580705161414i67e753d7x883a78da347f7d55@mail.gmail.com>
In-Reply-To: <1defaf580705161414i67e753d7x883a78da347f7d55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200705301027.17678.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think I'll sign off on this as-is.


On Wednesday 16 May 2007, Håvard Skinnemoen wrote:
> On 5/16/07, David Brownell <david-b@pacbell.net> wrote:

> > It's legit to set up cpu-virtual (for PIO) and dma addresses
> > for each buffer, since the upper layer driver has no way to
> > know if the underlying controller driver is DMA-capable, or
> > for that matter PIO-capable.
> 
> Yes, but are there any drivers that will provide a valid dma address
> and a NULL cpu-virtual pointer?

Potentially.  One scenario would be a block driver, which needs to
work with scatterlists.  dma_map_sg() is allowed to coalesce the
scatterlist entries, as with an IOMMU.  If it does that, there can
no longer be a one-to-one linkage between addreses provided to that
driver, and the dma addresess.  (Likewise, addresses in HIGHMEM are
not normally going to have kernel virtual addresses.)  So providing
both types of address is no longer practical with scatterlists.


> 		That would indeed break my 
> assumptions, but it would also break any PIO-only drivers, wouldn't
> it?

Which is exactly why the current "mmc_spi" code doesn't use the
dma_map_sg() interface.  Instead, it goes in more byte-size chunks,
taking care to provide both dma and pio addresses.  It's a PITA,
but at least it's coded now.

- Dave



> Haavard
> 


