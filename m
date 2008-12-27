Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYL0Qp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYL0Qp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 11:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYL0QpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 11:45:17 -0500
Received: from sh.osrg.net ([192.16.179.4]:50284 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbYL0QpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 11:45:16 -0500
Date: Sun, 28 Dec 2008 01:44:41 +0900
To: mingo@elte.hu
Cc: jeremy@goop.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081227104823.GI14639@elte.hu>
References: <patchbomb.1229970362@abulafia.goop.org>
	<20081227104823.GI14639@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081228014432L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Dec 2008 11:48:23 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> Also, this patch will interact with ia64 materially:
> 
>   Subject: [PATCH 9 of 9] ia64/x86/swiotlb: use enum dma_data_direciton in dma_ops
> 
> So we'll need a bit more confidence in the testing status of this queue, 
> and we probably want to wait until Tony merged the pending .29 ia64 
> changes, and also get an Ack from Tony for these bits:
> 
>  arch/ia64/dig/dig_vtd_iommu.c       |    9 +++--
>  arch/ia64/hp/common/hwsw_iommu.c    |   22 ++++++++------
>  arch/ia64/hp/common/sba_iommu.c     |   12 ++++---
>  arch/ia64/include/asm/dma-mapping.h |   29 +++++++++---------
>  arch/ia64/include/asm/swiotlb.h     |   26 ++++++++++------
>  arch/ia64/kernel/machvec.c          |    6 ++-
>  arch/ia64/sn/kernel/io_common.c     |    3 +-
>  arch/ia64/sn/pci/pci_dma.c          |   21 ++++++++-----
>  arch/ia64/sn/pci/pcibr/pcibr_dma.c  |    3 +-
>  arch/ia64/sn/pci/tioca_provider.c   |    3 +-
> 
> (Tony Cc:-ed)

BTW, the above patch breaks IA64 build.

It's fixable but I think that it would be better to just drop this
huge patch and add some cast in powerpc code. the types of SWIOTBL
function arguments don't need to mach to DAM_API.txt though it might
be nice if so. There are other type mismatches. If we really want to
do this cleanups, we should fix up all the mismatches.
