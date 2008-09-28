Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYI1RLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYI1RLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 13:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYI1RLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 13:11:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:43603 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbYI1RLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 13:11:42 -0400
Date: Mon, 29 Sep 2008 02:11:38 +0900
To: leon.woestenberg@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: scatterlist.c or dma_map_sg() should coalesce?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <c384c5ea0809280847p6a7d2e9as1b2454142751a468@mail.gmail.com>
References: <c384c5ea0809280847p6a7d2e9as1b2454142751a468@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080929021041R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2008 17:47:59 +0200
"Leon Woestenberg" <leon.woestenberg@gmail.com> wrote:

> Hello,
> 
> in 2.6.27+, if I want to create a scatterlist of a large buffer in
> virtual memory in a device driver, can I expect the scatterlist and/or
> mapping API to provide me with a minimal list, each entry describing a
> maximum bus-contiguous piece of memory? (i.e. can I assume coalescing
> is done for me?).

No, it's not the job of dma_map_sg. Before dma_map_sg, physical
continuous page frames in a scatter list are supposed be coalesced.
For example, the block layer creates a scatter list in which physical
continuous page frames are coalesced for SCSI drivers.


> In 2.6.24, dma_map_sg() *may* coalesce, but doesn't do so for my
> platform, so for optimal DMA transfers the device driver needs to
> coalesce the list entries.

With some of IOMMUs, dma_map_sg might coalesce virtual and physical
continuous page frames. If 2.6.24 doesn't do for you, 2.6.27 doesn't
too.
