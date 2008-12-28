Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYL1Mfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYL1Mfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 07:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYL1Mf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 07:35:28 -0500
Received: from sh.osrg.net ([192.16.179.4]:39986 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYL1Mf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 07:35:28 -0500
Date: Sun, 28 Dec 2008 21:34:54 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org, ian.campbell@citrix.com, beckyb@kernel.crashing.org,
       joerg.roedel@amd.com
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081228115621.GA11954@elte.hu>
References: <20081228103419.GA7128@elte.hu>
	<20081228195952F.fujita.tomonori@lab.ntt.co.jp>
	<20081228115621.GA11954@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081228213414O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2008 12:56:21 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > You brought up a different topic, DMA bouncing implementations 
> > unification. DMA bouncing implementations unification is a very nice 
> > cleanup. But it's not related with Becky's patch to break IA64 build at 
> > all.
> 
> All i'm saying is that obviously neither Jeremy's nor Becky's patches were 
> created in a vacuum, and had it not been for the need and desire to extend 
> swiotlb we'd not have seen Becky's 9/9 cleanup patch either.

As I wrote, Becky's 9/9 cleanup path is not about swiotlb highmem
extention. We had known about the need to clean up the dma mapping
operation ugliness. But we has ignored it and added workarounds again
and again. We haven't seen something like his 9/9 because we added
workarounds in architecture-specific code.

Anyway, his 9/9 patch is wrong if we want to fix the root cause. If we
don't fix the root cause, the lots of changes of his 9/9 patch don't
make sense. Probably, it would better to add some workarounds in
architecture-specific code (POWERPC in this case) as we have done in
the past.

Ok, I'll try to fix the root cause. We need lots of changes to IA64
especially. Hopefully, I can get Tony's ACK on these changes.
