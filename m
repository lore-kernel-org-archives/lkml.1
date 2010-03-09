Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0CIKR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:17:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43575 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab0CIKR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:17:26 -0500
Date: Tue, 9 Mar 2010 10:16:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: mkl0301@gmail.com, thomas@koeller.dyndns.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: DMA using data buffer vmapped in kernel space
Message-ID: <20100309101611.GC5691@n2100.arm.linux.org.uk>
References: <20100306193127.GA13262@n2100.arm.linux.org.uk> <10d816431003082345j5438d8cdi8ad72c4fa296b684@mail.gmail.com> <20100309091403.GB5691@n2100.arm.linux.org.uk> <20100309.012935.98310472.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309.012935.98310472.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 01:29:35AM -0800, David Miller wrote:
> From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Date: Tue, 9 Mar 2010 09:14:03 +0000
> 
> > What you could do is prepare a patch to allow the firmware support to
> > export a scatterlist via the struct firmware, and then use that with
> > dma_map_sg().  Let's hope that the SPI interfaces support scatterlists.
> 
> It's so common to want a scatterlist from a vmalloc/vmap area
> that a generic common helper is probably the best.
> 
> Just iterate over the vmalloc/vmap area using vmalloc_to_page()
> to fill in the SG entries.

It looks like the firmware interface may return a pointer to either the
kernel binary itself for built-in firmware, or to a set of pages which
have been vmap'd.  In the former case, vmalloc_to_page() will fail.
