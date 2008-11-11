Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbYKKFjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbYKKFjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 00:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYKKFjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 00:39:25 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36629 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYKKFjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 00:39:23 -0500
Date: Tue, 11 Nov 2008 14:39:18 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Q] Why does dma_alloc_coherent() of ia64 GFP_DMA?
Cc: "Luck, Tony" <tony.luck@intel.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-ia64@vger.kernel.org,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
In-Reply-To: <Pine.LNX.4.64.0811101600490.32282@quilx.com>
References: <20081110121123.F82A.E1E9C6FF@jp.fujitsu.com> <Pine.LNX.4.64.0811101600490.32282@quilx.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20081111141430.D5C7.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

I heard that Altix has IOMMU and __GFP_DMA is not necessary.

> If you have an IA64 arch that only support 32bit I/O then __GFP_DMA in
> dma_alloc_coherent makes sense.

Agree. 
But our box supports both of 32bit I/O and 64bit I/O without IOMMU.
Is it abnormal platform? New interface is necessary for our box like Altix?


Bye.

-- 
Yasunori Goto 


