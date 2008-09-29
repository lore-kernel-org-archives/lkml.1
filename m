Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbYI2J3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbYI2J3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYI2J3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:29:20 -0400
Received: from 8bytes.org ([88.198.83.132]:51430 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651AbYI2J3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:29:19 -0400
Date: Mon, 29 Sep 2008 11:29:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org,
       amit.shah@qumranet.com, mingo@redhat.com
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Message-ID: <20080929092917.GO27426@8bytes.org>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <1222107681-8185-10-git-send-email-joerg.roedel@amd.com> <20080928231211X.fujita.tomonori@lab.ntt.co.jp> <20080928184424.GA26563@8bytes.org> <20080929092549.GA6931@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929092549.GA6931@il.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 12:25:49PM +0300, Muli Ben-Yehuda wrote:
> On Sun, Sep 28, 2008 at 08:44:24PM +0200, Joerg Roedel wrote:
> 
> > Hmm, we should only call find_dma_ops_for_device() the first time a
> > dma api call is done (look into get_dma_ops). But I also thought
> > about how this lock can be avoided. In the real world it should not
> > be necessary because the dma_ops list is initialized before dma api
> > calls are done. But since there is now a register function which can
> > be called its safer this way. What do you think, are we still safe
> > enough without this lock?
> 
> We could be, if we add a check to the register function that verifies
> it isn't being called after DMAs have started. Something like:
> 
> in register:
> 
>   if (dma_started)
>     yell loudly
> 
> before PCI device initialization and after IOMMU initialization:
>   dma_started = true

Good idea. I will change this in my patchset, thanks.

Joerg

