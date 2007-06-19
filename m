Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbXFSWSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbXFSWSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbXFSWSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:18:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:50152 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbXFSWSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:18:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,439,1175497200"; 
   d="scan'208";a="258836645"
Message-Id: <20070619213701.219910000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Jun 2007 14:37:01 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: ak@suse.de, gregkh@suse.de, muli@il.ibm.com
Cc: suresh.b.siddha@intel.com, arjan@linux.intel.com
Cc: ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: [Intel IOMMU 00/10] Intel IOMMU support, take #2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	This patch supports the upcomming Intel IOMMU hardware
a.k.a. Intel(R) Virtualization Technology for Directed I/O 
Architecture and the hardware spec for the same can be found here
http://www.intel.com/technology/virtualization/index.htm

	This version of the patches incorporates several 
feedback obtained from previous postings.

Some of the major changes are
1) Removed resource pool (a.k.a. pre-allocate pool) patch
2) For memory allocation in the DMA map api calls we
   now use kmem_cache_alloc() and get_zeroedpage() functions
   to allocate memory for internal data structures and for 
   page table setup memory.
3) The allocation of memory in the DMA map api calls is 
   very critical and to avoid failures during memory allocation
   in the DMA map api calls we evaluated several technique
   a) mempool - We found that mempool is pretty much useless
      if we try to allocate memory with GFP_ATOMIC which is
     our case. Also we found that it is difficult to judge
     how much to reserver during the creation of mempool.
   b) PF_MEMALLOC - When a task flags (current->flags) are
     set with PF_MEMALLOC then watermark checks are avoided
     during the memory allocation.
  We choose to use the latter (option b) and make this as
  a separate patch which can be debated further. Please
  see patch 6/10.

Other minor changes are mostly coding style fixes and 
making sure that checkpatch.pl passes the patches.

Please include this set of patches for next MM release.

Thanks and regards,
-Anil S Keshavamurthy
E-mail: anil.s.keshavamurthy@intel.com

-- 
