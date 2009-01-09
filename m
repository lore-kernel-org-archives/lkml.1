Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbZAIWiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbZAIWiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZAIWht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:37:49 -0500
Received: from 8bytes.org ([88.198.83.132]:57677 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZAIWhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:37:48 -0500
Date: Fri, 9 Jan 2009 23:37:47 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Michael Chan <mchan@broadcom.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/16] DMA-API debugging facility v2
Message-ID: <20090109223747.GE9466@8bytes.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231536264.10384.11.camel@HP1> <20090109223327.GD9466@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109223327.GD9466@8bytes.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 11:33:27PM +0100, Joerg Roedel wrote:
> > This was triggered during pci_unmap_page() -> dma_unmap_single() where
> > check_unmap() did not find the entry.
> > 
> > The original mapping was done in bnx2 using pci_map_page().  I did not
> > see how the debug entry was added to the hash during the call to
> > pci_map_page() -> dma_map_page().  Did I miss something?
> 
> dma_map_page() results in dma_map_single() -> debug_map_single() call on
> x86. This way the entry would be added. Maybe the error from a double
> free?

Ah, it only calls ops->map_single. Thanks for pointing that out. I will
add a call to debug_map_single to dma_map_page too. So the error above
may be a false positive.

Joerg
