Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748Ab0A2JFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0A2JFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278Ab0A2JFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:05:31 -0500
Received: from 8bytes.org ([88.198.83.132]:52655 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab0A2JF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:05:28 -0500
Date: Fri, 29 Jan 2010 10:05:26 +0100
From: Joerg Roedel <joro@8bytes.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] VT-d: Change {un}map_range functions to
	implement {un}map interface
Message-ID: <20100129090526.GT17809@8bytes.org>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com> <1264678682-30655-5-git-send-email-joerg.roedel@amd.com> <1264712382.9059.1109.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264712382.9059.1109.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 09:59:42AM +1300, David Woodhouse wrote:
> On Thu, 2010-01-28 at 12:37 +0100, Joerg Roedel wrote:
> > This patch changes the iommu-api functions for mapping and
> > unmapping page ranges to use the new page-size based
> > interface. This allows to remove the range based functions
> > later. 
> 
> > +       size     = 0x1000UL << gfp_order;
> 
> Um, that's not a page-size based interface. Page size isn't always 4KiB;
> this code runs on IA64 too.
> 
> We have enough fun with CPU vs. DMA page size on IA64 already :)

Ah right. So this should be

	size     = PAGE_SIZE << gfp_order;

Right? The interface is meant to map the same amount of memory which
alloc_pages(gfp_order) would return. Same for the return value of the
unmap function.

	Joerg

