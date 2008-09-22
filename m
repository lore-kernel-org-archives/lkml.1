Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbYIVUah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbYIVUah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYIVUa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:30:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58024 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYIVUa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:30:29 -0400
Date: Mon, 22 Sep 2008 22:35:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, mingo@elte.hu, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about virtual mappings
Message-ID: <20080922203518.GZ25711@one.firstfloor.org>
References: <20080918182029.GO25711@one.firstfloor.org> <20080919071534C.fujita.tomonori@lab.ntt.co.jp> <20080919004431.GS25711@one.firstfloor.org> <20080923041203Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923041203Q.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 04:12:33AM +0900, FUJITA Tomonori wrote:
> Sure, pci-nommu's map_sg/map_single doesn't handle it. But we handle
> this issue somewhere else (like b44 keeps own DMA buffer)?

Yes, b44 handles it on its own. It has to for 32bit which always
has a nop map_sg/single. Also some other subsystems like the block layer
do it implicitely.

> 1. not all map_sg/map_single (e.g. pci-nommu) can't handle it.

and especially i386

> 2. we already have workarounds for it somewhere else so
> map_sg/map_single don't need to handle it.
> 3. I changed GART map_sg/map_signle to handle it. I thought if it
> can handle it, for example, b44 doesn't go the workaround path. It
> would be a good thing.
> 4. But GART cannot remap to addresses < 4GB reliably, so my above
> argument doesn't always work.
> 5. Then my patch doesn't break anything but it's almost meaningless.

Correct.

-Andi
-- 
ak@linux.intel.com
