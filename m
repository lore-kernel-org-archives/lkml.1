Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYAGVsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYAGVsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYAGVsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:48:46 -0500
Received: from lixom.net ([66.141.50.11]:53172 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbYAGVsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:48:46 -0500
Date: Mon, 7 Jan 2008 15:57:56 -0600
From: Olof Johansson <olof@lixom.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][POWERPC] Workaround for iommu page alignment
Message-ID: <20080107215755.GA31230@lixom.net>
References: <1199742359.6734.14.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199742359.6734.14.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 08:45:59AM +1100, Benjamin Herrenschmidt wrote:
> Our iommu page size is currently always 4K. That means with our current
> code, drivers may do a dma_map_sg() of a 64K page and obtain a dma_addr_t
> that is only 4K aligned.
> 
> This works fine in most cases except some infiniband HW it seems, where
> they tell the HW about the page size and it ignores the low bits of the
> DMA address.
> 
> This works around it by making our IOMMU code enforce a PAGE_SIZE alignment
> for mappings of objects that are page aligned in the first place and whose
> size is larger or equal to a page.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
