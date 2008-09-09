Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbYIIQuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbYIIQuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYIIQt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:49:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:58380 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbYIIQt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:49:59 -0400
Date: Wed, 10 Sep 2008 01:49:37 +0900
To: tony.luck@intel.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com,
       linux-kernel@vger.kernel.org, joerg.roedel@amd.com
Subject: RE: [PATCH 1/4] add is_buffer_dma_capable helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA30A14789F@orsmsx505.amr.corp.intel.com>
References: <1220976409-8417-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1220976409-8417-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<57C9024A16AD2D4C97DC78E552063EA30A14789F@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080910015004L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 09:17:05 -0700
"Luck, Tony" <tony.luck@intel.com> wrote:

> +static inline int is_buffer_dma_capable(u64 mask, dma_addr_t addr, size_t size)
> +{
> +       return addr + size <= mask;
> +}
> 
> Do we care about wrap-around (e.g. addr=0xffffffffffffffff size=2)?

We could do something like:

      return addr < mask && addr + size <= mask;


But such wrap-around can happen only with a buggy IOMMU
implementation. A driver will does DMA from 0xffffffffffffffff to
0x1. Even if this function does the right thing in such case, we will
be dead?
