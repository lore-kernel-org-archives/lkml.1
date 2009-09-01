Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbZIAQy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbZIAQy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZIAQyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:54:25 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:17530 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbZIAQyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:54:24 -0400
X-Trace: 255563197/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.32.72/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.32.72
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAIfunEpPRSBI/2dsb2JhbACBU9s5hBsFgVc
X-IronPort-AV: E=Sophos;i="4.44,313,1249254000"; 
   d="scan'208";a="255563197"
Date: Tue, 1 Sep 2009 17:53:48 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Steven Walter <stevenrwalter@gmail.com>,
       David Xiao <dxiao@broadcom.com>, Ben Dooks <ben-linux@fluff.org>,
       Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
 get_user_pages() enough to prevent pages from being swapped out ?")
In-Reply-To: <20090901141812.GT19719@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0909011747080.5078@sister.anvils>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>
 <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com>
 <20090901132824.GN19719@n2100.arm.linux.org.uk>
 <200909011543.48439.laurent.pinchart@ideasonboard.com>
 <20090901141812.GT19719@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009, Russell King - ARM Linux wrote:
> On Tue, Sep 01, 2009 at 03:43:48PM +0200, Laurent Pinchart wrote:
> > I might be missing something obvious, but I fail to see how VIVT caches
> > could work at all with multiple mappings. If a kernel-allocated buffer
> > is DMA'ed to, we certainly want to invalidate all cache lines that store
> > buffer data. As the cache doesn't care about physical addresses we thus
> > need to invalidate all virtual mappings for the buffer. If the buffer is
> > mmap'ed in userspace I don't see how that would be done.
> 
> You need to ask MM gurus about that.  I don't touch the Linux MM very
> often so tend to keep forgetting how it works.  However, it does work
> for shared mappings of files on CPUs with VIVT caches.

I believe arch/arm/mm/flush.c __flush_dcache_aliases() is what does it.

Hugh
