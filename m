Return-Path: <linux-kernel-owner+w=401wt.eu-S934013AbXCPBlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbXCPBlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 21:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934016AbXCPBlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 21:41:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44478
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S934013AbXCPBlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 21:41:09 -0400
Date: Thu, 15 Mar 2007 18:18:55 -0700 (PDT)
Message-Id: <20070315.181855.18293618.davem@davemloft.net>
To: hch@infradead.org
Cc: jbeulich@novell.com, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: PCI DAC DMA APIs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070315191834.GA12603@infradead.org>
References: <45F94C45.76E4.0078.0@novell.com>
	<20070315191834.GA12603@infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 15 Mar 2007 19:18:34 +0000

> On Thu, Mar 15, 2007 at 12:38:13PM +0000, Jan Beulich wrote:
> > While the kernel headers provide for this, there don't appear to be any
> > in-tree users (which seems contrary to general Linux policies). Would there
> > be objections to remove all of these?
> 
> They should go away.  Having them in for more than five years without
> any users is almost a guarantee for bitrot.

Yes, probably we should get rid of them.

The idea wasn't sparc optimizations, it was for things like those
Dolphin clustering cards that essentially want to get at all of
physical memory from the PCI card.

The IOMMU is a limited resource, so at the expense of lack of
prefetching and write caching we provide a way to do unlimited DMA
mapping with 64-bit DAC addresses.

None of these drivers ever got integrated, so it's a total loss.

Someone will complain when we pull it out, but fsck them, they
had years to do something about this. :)

