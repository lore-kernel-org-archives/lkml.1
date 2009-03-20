Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbZCTIrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbZCTIrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbZCTIqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:46:50 -0400
Received: from 8bytes.org ([88.198.83.132]:43743 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198AbZCTIqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:46:49 -0400
Date: Fri, 20 Mar 2009 09:46:46 +0100
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/18] dma-debug: add checking for map/unmap_page/single
Message-ID: <20090320084645.GA19567@8bytes.org>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com> <1236346229-6618-10-git-send-email-joerg.roedel@amd.com> <20090319103716G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319103716G.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 10:39:30AM +0900, FUJITA Tomonori wrote:
> On Fri, 6 Mar 2009 14:30:20 +0100
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> > +	if (map_single) {
> > +		entry->type = dma_debug_single;
> > +		check_for_stack(dev, page_address(page) + offset);
> 
> Why you don't call check_for_stack() for dma_map_page()?
> 
> page_address(page) could be invalid with dma_map_page() so the check
> can be pointless. However, you call check_for_stack() with dma_map_sg,
> which the check can be pointless too with; I think that you call
> check_for_stack() in an inconsistent way.

I wasn't aware that sg mappings support highmem too. I did the check
only for map_single because I havn't found a way to check if the address
is mapped. Its not so important because the pointer is never
dereferenced but only compared. Looking again at it I think a check for
PageHighMem() should be sufficient to check if the page is mapped. I
will update the code. Thanks for pointing this out.

Joerg
