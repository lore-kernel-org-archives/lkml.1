Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbZIAN2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbZIAN2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZIAN2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:28:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39324 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbZIAN2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:28:45 -0400
Date: Tue, 1 Sep 2009 14:28:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steven Walter <stevenrwalter@gmail.com>
Cc: David Xiao <dxiao@broadcom.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Ben Dooks <ben-linux@fluff.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Robin Holt <holt@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       v4l2_linux <linux-media@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
	get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <20090901132824.GN19719@n2100.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <20090806114619.GW2080@trinity.fluff.org> <200908061506.23874.laurent.pinchart@ideasonboard.com> <1249584374.29182.20.camel@david-laptop> <20090806222543.GG31579@n2100.arm.linux.org.uk> <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 08:53:29AM -0400, Steven Walter wrote:
> On Thu, Aug 6, 2009 at 6:25 PM, Russell King - ARM
> Linux<linux@arm.linux.org.uk> wrote:
> [...]
> > As far as userspace DMA coherency, the only way you could do it with
> > current kernel APIs is by using get_user_pages(), creating a scatterlist
> > from those, and then passing it to dma_map_sg().  While the device has
> > ownership of the SG, userspace must _not_ touch the buffer until after
> > DMA has completed.
> [...]
> 
> Would that work on a processor with VIVT caches?  It seems not.  In
> particular, dma_map_page uses page_address to get a virtual address to
> pass to map_single().  map_single() in turn uses this address to
> perform cache maintenance.  Since page_address() returns the kernel
> virtual address, I don't see how any cache-lines for the userspace
> virtual address would get invalidated (for the DMA_FROM_DEVICE case).

You are correct.

> If that's true, then what is the correct way to allow DMA to/from a
> userspace buffer with a VIVT cache?  If not true, what am I missing?

I don't think you read what I said (but I've also forgotten what I did
say).

To put it simply, the kernel does not support DMA direct from userspace
pages.  Solutions which have been proposed in the past only work with a
sub-set of conditions (such as the one above only works with VIPT
caches.)
