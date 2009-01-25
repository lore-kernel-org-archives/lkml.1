Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZAYNSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZAYNSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 08:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbZAYNS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 08:18:29 -0500
Received: from sh.osrg.net ([192.16.179.4]:41548 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbZAYNS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 08:18:28 -0500
Date: Sun, 25 Jan 2009 22:17:19 +0900
To: joro@8bytes.org
Cc: arnd@arndb.de, joerg.roedel@amd.com, oliver@neukum.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, ceggers@gmx.de, davem@davemloft.net
Subject: Re: [PATCH 09/16] dma-debug: add checking for map/unmap_page/single
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090123102827.GO9466@8bytes.org>
References: <1232376423-11067-10-git-send-email-joerg.roedel@amd.com>
	<200901210117.33153.arnd@arndb.de>
	<20090123102827.GO9466@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090125221731C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009 11:28:27 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> On Wed, Jan 21, 2009 at 01:17:32AM +0100, Arnd Bergmann wrote:
> > On Monday 19 January 2009, Joerg Roedel wrote:
> > > Impact: add debug callbacks for dma_{un}map_[page|single]
> > 
> > In the discussion about "[PATCH] usb/mcs7830: Don't use buffers from
> > stack for USB transfers", I have raised the question of whether we can
> > add a check for the DMA address being on the stack, I guess this would
> > be the right place for it.
> > 
> > Maybe you can add another check like:
> > 
> > WARN_ON(is_kernel_stack(page_to_virt(page)));
> 
> Good idea. This would be the right place for such a check.
> 
> > Unfortunately, I can't think of a way to define a generic is_kernel_stack
> > function. On most architectures (all that put thread_info at the top of the
> > stack), something like this should work:
> > 
> > #ifndef is_kernel_stack
> > static inline int is_kernel_stack(void *p)
> > {
> > 	return (unsigned long)p & ~(THREAD_SIZE - 1) == current_thread_info();
> > }
> > #endif
> 
> Hmm, this function is indeed required on all architectures. If you send
> a patchset which adds it I will add the check for stack addresses to
> this debugging code :)

object_is_on_stack()
