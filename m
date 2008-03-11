Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYCKRyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYCKRyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYCKRyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:54:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311AbYCKRyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:54:35 -0400
Date: Tue, 11 Mar 2008 10:53:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: dan.j.williams@intel.com, shannon.nelson@intel.com,
       linux-kernel@vger.kernel.org, pasemi-linux@ozlabs.org,
       linuxppc-dev@ozlabs.org, hskinnemoen@atmel.com
Subject: Re: [PATCH] pasemi_dma: Driver for PA Semi PWRficient on-chip DMA
 engine
Message-Id: <20080311105355.64a9c380.akpm@linux-foundation.org>
In-Reply-To: <20080311142545.GA18843@lixom.net>
References: <20080306233900.GA3969@lixom.net>
	<20080311000619.ba39311f.akpm@linux-foundation.org>
	<20080311142545.GA18843@lixom.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 09:25:45 -0500
Olof Johansson <olof@lixom.net> wrote:

> On Tue, Mar 11, 2008 at 12:06:19AM -0700, Andrew Morton wrote:
> > On Thu, 6 Mar 2008 17:39:00 -0600 Olof Johansson <olof@lixom.net> wrote:
> > 
> > > pasemi_dma: Driver for PA Semi PWRficient on-chip DMA engine
> > >     
> > > First cut at a dma copy offload driver for PA Semi PWRficient. It uses the
> > > platform-specific functions to allocate channels, etc.
> > 
> > Applied this on Paul's latest and powerpc allmodconfig goes boom.
> 
> It's dependent on my latest pull request of pasemi.git for-2.6.26 that
> Paul hasn't pulled/pushed yet.

Maybe we should get that tree into -mm and/or linux-next.

People do test -mm on powerpc.

> > drivers/dma/pasemi_dma.c: In function `pasemi_dma_alloc_chan_resources':
> > drivers/dma/pasemi_dma.c:152: error: `PAS_DMA_TXCHAN_CFG_TY_COPY' undeclared (first use in this function)
> > drivers/dma/pasemi_dma.c:152: error: (Each undeclared identifier is reported only once
> > drivers/dma/pasemi_dma.c:152: error: for each function it appears in.)
> > drivers/dma/pasemi_dma.c:154: error: `PAS_DMA_TXCHAN_CFG_LPDQ' undeclared (first use in this function)
> > drivers/dma/pasemi_dma.c:155: error: `PAS_DMA_TXCHAN_CFG_LPSQ' undeclared (first use in this function)
> > drivers/dma/pasemi_dma.c: In function `pasemi_dma_probe':
> > drivers/dma/pasemi_dma.c:394: error: structure has no member named `device_dependency_added'
> 
> .. and that one is caused by recent changes in async_tx.git. I was
> waiting on other review comments from the DMA maintainers before
> resubmitting; timer has expired though and I'll do it anyway today.

What is async_tx.git?

> > Also this driver from git-md-accel is pretty sick:
> > 
> > 
> > drivers/dma/fsldma.c:439: warning: comparison of distinct pointer types lacks a cast
> > drivers/dma/fsldma.c: In function `fsl_chan_xfer_ld_queue':
> > drivers/dma/fsldma.c:584: warning: long long unsigned int format, dma_addr_t arg (arg 4)
> > drivers/dma/fsldma.c: In function `fsl_dma_chan_do_interrupt':
> > drivers/dma/fsldma.c:661: warning: unsigned int format, different type arg (arg 5)
> > drivers/dma/fsldma.c:677: warning: long long unsigned int format, dma_addr_t arg (arg 4)
> > drivers/dma/fsldma.c:677: warning: long long unsigned int format, dma_addr_t arg (arg 5)
> > drivers/dma/fsldma.c:694: warning: unsigned int format, different type arg (arg 4)
> > drivers/dma/fsldma.c: In function `fsl_dma_self_test':
> > drivers/dma/fsldma.c:833: warning: int format, different type arg (arg 5)
> > drivers/dma/fsldma.c: In function `of_fsl_dma_probe':
> > drivers/dma/fsldma.c:1003: warning: unsigned int format, different type arg (arg 5)
> > drivers/dma/fsldma.c: At top level:
> > drivers/dma/fsldma.c:723: warning: 'fsl_dma_callback_test' defined but not used
> 
> Yeah, Zhang Wei posted a patch for that on lkml yesterday.

OK.
