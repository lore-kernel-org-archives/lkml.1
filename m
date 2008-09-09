Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYIIKgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYIIKgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYIIKgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:36:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54977 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYIIKgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:36:11 -0400
Date: Tue, 9 Sep 2008 19:41:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, joerg.roedel@amd.com,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/5] fix exhaustion of ZONE_DMA with swiotlb (in x86
 tree)
Message-Id: <20080909194107.8bae460c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1220865014-1169-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220865014-1169-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  8 Sep 2008 18:10:09 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This patchset (against tip/master) fixes the problem that swiotlb
> exhausts ZONE_DMA:
> 
> http://lkml.org/lkml/2008/8/31/16
> 
> The root problem is that swiotlb_alloc_coherent always use ZONE_DMA,
> which is fine for IA64 but not for x86_64.
> 
> This patchset makes the callers set up the gfp flags so that
> swiotlb_alloc_coherent can stop playing with the gfp flags.
> 
> I think that it would be better to remove the allocation code in
> swiotlb_alloc_coherent theoretically (what swiotlb should do is taking
> care of the swiotlb memory. And swiotlb_alloc_coherent is not useful
> since we use it only when we can't allocate memory reachable by the
> device or we are in out of memory). But that code works for both x86
> and IA64 so it's not so bad, I guess.
> 
> #1 is for IA64, #2-4 for x86, and #5 is for swiotlb.
> 

Thanks, works well for me :)

Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

