Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbYKKUep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbYKKUep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYKKUeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:34:37 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:51010 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYKKUeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:34:37 -0500
Date: Tue, 11 Nov 2008 14:34:21 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: "Luck, Tony" <tony.luck@intel.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-ia64@vger.kernel.org,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [Q] Why does dma_alloc_coherent() of ia64 GFP_DMA?
In-Reply-To: <20081111141430.D5C7.E1E9C6FF@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0811111433030.26610@quilx.com>
References: <20081110121123.F82A.E1E9C6FF@jp.fujitsu.com>
 <Pine.LNX.4.64.0811101600490.32282@quilx.com> <20081111141430.D5C7.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Yasunori Goto wrote:

> But our box supports both of 32bit I/O and 64bit I/O without IOMMU.
> Is it abnormal platform? New interface is necessary for our box like Altix?

No its like x86 with the GFP_DMA zone for < 16M addresses. The special
memory creates an imbalance that sometimes leads to weird VM behavior. I'd
make sure to set GFP_DMA only for devices that actually require < 4GB
memory and only use it if no IOMMU like stuff is available. Its best to
not use GFP_DMA.


