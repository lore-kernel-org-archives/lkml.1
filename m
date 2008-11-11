Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYKKFyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYKKFyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 00:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYKKFyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 00:54:03 -0500
Received: from sh.osrg.net ([192.16.179.4]:39611 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbYKKFyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 00:54:01 -0500
Date: Tue, 11 Nov 2008 14:53:46 +0900
To: cl@linux-foundation.org
Cc: y-goto@jp.fujitsu.com, tony.luck@intel.com, fujita.tomonori@lab.ntt.co.jp,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com
Subject: Re: [Q] Why does dma_alloc_coherent() of ia64 GFP_DMA?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.64.0811101600490.32282@quilx.com>
References: <20081110121123.F82A.E1E9C6FF@jp.fujitsu.com>
	<Pine.LNX.4.64.0811101600490.32282@quilx.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081111145418P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 16:06:52 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Mon, 10 Nov 2008, Yasunori Goto wrote:
> 
> > Even if a device allows over 4G access and the driver doesn't specify
> > GFP_DMA, dma_alloc_coherent() returns under 4G area.
> 
> GFP_DMA can become 0 for configurations that have
> !CONFIG_ZONE_DMA. Then all of memory is available.
> 
> The call is subarch specific. So f.e. Altix sn_dma_alloc_coherent does
> not set __GFP_DMA.

Is it because it does some kinda address translation
(provider->dma_map_consistent) later? The zone flag is meaningless if
you do sorta address translation (e.g. hardware IOMMU like VT-d).
