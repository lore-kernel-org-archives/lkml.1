Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYKJWHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYKJWHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYKJWHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:07:09 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:47642 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYKJWHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:07:06 -0500
Date: Mon, 10 Nov 2008 16:06:52 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: "Luck, Tony" <tony.luck@intel.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-ia64@vger.kernel.org,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [Q] Why does dma_alloc_coherent() of ia64 GFP_DMA?
In-Reply-To: <20081110121123.F82A.E1E9C6FF@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0811101600490.32282@quilx.com>
References: <20081110121123.F82A.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008, Yasunori Goto wrote:

> Even if a device allows over 4G access and the driver doesn't specify
> GFP_DMA, dma_alloc_coherent() returns under 4G area.

GFP_DMA can become 0 for configurations that have
!CONFIG_ZONE_DMA. Then all of memory is available.

The call is subarch specific. So f.e. Altix sn_dma_alloc_coherent does
not set __GFP_DMA.

If you have an IA64 arch that only support 32bit I/O then __GFP_DMA in
dma_alloc_coherent makes sense.





