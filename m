Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbXHLFFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbXHLFFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 01:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbXHLFFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 01:05:11 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:43123 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbXHLFFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 01:05:09 -0400
Date: Sun, 12 Aug 2007 14:04:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Michael Bourgeous <sts.nitrogen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Driver-level memory management
Message-ID: <20070812050409.GC13496@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Michael Bourgeous <sts.nitrogen@gmail.com>,
	linux-kernel@vger.kernel.org
References: <8e4fc8270708112014h5f4e9bf1ua9565eab60f915c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e4fc8270708112014h5f4e9bf1ua9565eab60f915c1@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2007 at 09:14:00PM -0600, Michael Bourgeous wrote:
> I'm working on a driver for older HDTV cards based on the TL880 chip.
> These cards typically have 16MB of their own memory, which is
> available to me over the PCI bus.  Various functions of the card
> require me to manage this memory, allocating and freeing chunks of it
> as necessary.  I can easily include my own allocation and management
> code, but I'm sure this is a problem that has been solved before.
> I've found two interesting sets of functions, the kmem_cache_* and
> mempool_* functions, but neither does quite what I'm looking for.  So,
> in a sentence, my question is this: Does the kernel provide memory
> pool functions that would allow me to call the appropriate equivalent
> of kmalloc/kfree, using the card's memory as the pool instead of
> actually allocating physical or virtual memory?
> 
Many platforms have similar requirements for DMA, both in terms of bounce
buffers and consistent allocations. If you're looking at this
specifically for DMA, then things like dma_declare_coherent_memory() and
the corresponding alloc/free routines that go along with it will do what
you need. If you require something more generalized, you can still
abstract what you need fairly trivially.

There are a few examples of bitmap based region management in the kernel
you can look at. arch/i386/kernel/pci-dma.c implements the aforementioned
DMA ops, and arch/sh/kernel/cpu/sh4/sq.c does something similar, albeit
with a larger address range (64MB). A simple bitmap approach from one or
the other should work fine for your 16MB case.
