Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbZGJBrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbZGJBrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZGJBrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:47:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:39853 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZGJBrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:47:46 -0400
Date: Fri, 10 Jul 2009 10:47:37 +0900
To: linuxppc-dev@lists.ozlabs.org
Cc: benh@kernel.crashing.org, galak@kernel.crashing.org,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: removing addr_needs_map in struct dma_mapping_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090710104706I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Jul 2009 10:47:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to convert POWERPC to use asm-generic/dma-mapping-common.h.

POWERPC needs addr_needs_map() in struct dma_mapping_ops for SWIOTLB
support but I want to avoid add addr_needs_map() in struct
dma_map_ops. IIRC, you guys think it as a temporary solution and
talked about defining something like struct dma_data. Then we could

struct dev_archdata {
       ...

       struct dma_data *ddata;
};

or

struct dev_archdata {
       ...

       struct dma_data ddata;
};


struct dma_data needs dma_direct_offset, iommu_table, dma_base, and
dma_window_size, anything else?


Is it acceptable?
