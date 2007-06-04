Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbXFDWaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbXFDWaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXFDWaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:30:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:20883 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbXFDWaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:30:04 -0400
X-ExtLoopCount2: 2 from 172.25.110.8
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="93439055"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="235457426"
Message-Id: <20070604210242.079459000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jun 2007 14:02:42 -0700
From: anil.s.keshavamurthy@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com
Cc: asit.k.mallick@intel.com, suresh.b.siddha@intel.com
Cc: anil.s.keshavamurthy@intel.com, arjan@linux.intel.com
Cc: ashok.raj@intel.com, shaohua.li@intel.com, davem@davemloft.net
Subject: [Intel-IOMMU 00/10] Intel IOMMU support
X-OriginalArrivalTime: 04 Jun 2007 21:23:58.0057 (UTC) FILETIME=[A9901D90:01C7A6EE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	We are pleased to announce the revised version of
the Intel IOMMU driver. This driver incorporates several
feedback received from Anid Kleen, David Miller and 
several others.

Most notable changes from previous postings (apart from
general code cleanup) are

1) Replaced linear linked list with RB tree to manage IOVA's.

2) IOVA address is now being allocated from the cards MAX DMA address capability or 
DMA32bit limit which ever is lower. This allowed us to get rid of having to
preserve certain address range when multiple cards of different DMA address
capabilities share the same domain.

3)Implements generic pre-allocated pools a.k.a. resource pool to allocate
memory for IOVA's and for vt-d page tables. This resource pools grows
automagically in the background (work queued to keventd) based
on the demand.

4) Did some tuning in terms of locking for iova allocation and freeing.

5) Changed command line options for isa and gfx workaround to CONFIG options,
so that when we have all the components adhere to PCI-DMA api's we can
easily yank this workarounds.

With all the above changes, the performance greatly improved and
the results showed that performance with IOMMU was comparable to 
without IOMMU configured.


Once again, thanks for providing valuable feedback, please
apply this set of patches to MM if you have no further objections.


Cheers,
-Anil Keshavmaurthy
e-mail: anil.s.keshavamurthy@intel.com
Open Source Technology Center
Intel Corp.
-- 
