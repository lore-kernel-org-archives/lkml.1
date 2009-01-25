Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZAYNv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZAYNv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 08:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZAYNvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 08:51:17 -0500
Received: from 8bytes.org ([88.198.83.132]:59839 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbZAYNvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 08:51:16 -0500
Date: Sun, 25 Jan 2009 14:51:15 +0100
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: arnd@arndb.de, joerg.roedel@amd.com, oliver@neukum.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, ceggers@gmx.de, davem@davemloft.net
Subject: Re: [PATCH 09/16] dma-debug: add checking for map/unmap_page/single
Message-ID: <20090125135115.GA29009@8bytes.org>
References: <1232376423-11067-10-git-send-email-joerg.roedel@amd.com> <200901210117.33153.arnd@arndb.de> <20090123102827.GO9466@8bytes.org> <20090125221731C.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090125221731C.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2009 at 10:17:19PM +0900, FUJITA Tomonori wrote:
> On Fri, 23 Jan 2009 11:28:27 +0100
> Joerg Roedel <joro@8bytes.org> wrote:
> 
> > On Wed, Jan 21, 2009 at 01:17:32AM +0100, Arnd Bergmann wrote:
> > > On Monday 19 January 2009, Joerg Roedel wrote:
> > > > Impact: add debug callbacks for dma_{un}map_[page|single]
> > > 
> > > In the discussion about "[PATCH] usb/mcs7830: Don't use buffers from
> > > stack for USB transfers", I have raised the question of whether we can
> > > add a check for the DMA address being on the stack, I guess this would
> > > be the right place for it.
> > > 
> > > Maybe you can add another check like:
> > > 
> > > WARN_ON(is_kernel_stack(page_to_virt(page)));
> > 
> > Good idea. This would be the right place for such a check.
> > 
> > > Unfortunately, I can't think of a way to define a generic is_kernel_stack
> > > function. On most architectures (all that put thread_info at the top of the
> > > stack), something like this should work:
> > > 
> > > #ifndef is_kernel_stack
> > > static inline int is_kernel_stack(void *p)
> > > {
> > > 	return (unsigned long)p & ~(THREAD_SIZE - 1) == current_thread_info();
> > > }
> > > #endif
> > 
> > Hmm, this function is indeed required on all architectures. If you send
> > a patchset which adds it I will add the check for stack addresses to
> > this debugging code :)
> 
> object_is_on_stack()

Oh cool. This function exists already. Thanks for the hint :)

Joerg
