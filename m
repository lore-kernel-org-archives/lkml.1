Return-Path: <linux-kernel-owner+w=401wt.eu-S1759886AbXFTTQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbXFTTQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXFTTQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:16:35 -0400
Received: from mga06.intel.com ([134.134.136.21]:53127 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753316AbXFTTQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:16:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,444,1175497200"; 
   d="scan'208";a="256880941"
Message-ID: <46797CB1.8070008@linux.intel.com>
Date: Wed, 20 Jun 2007 12:14:57 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures in	dma	map
 api calls
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>	 <20070619213808.798646000@askeshav-devel.jf.intel.com>	 <1182326799.21117.19.camel@twins> <46792586.20706@linux.intel.com>	 <20070620173038.GA25516@linux-os.sc.intel.com> <1182362703.21117.79.camel@twins>
In-Reply-To: <1182362703.21117.79.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> So a reclaim context (kswapd and direct reclaim) set PF_MEMALLOC to
> ensure they themselves will not block on a memory allocation. And it is
> understood that these code paths have a bounded memory footprint.


that's a too simplistic view though; what happens is that kswapd will 
queue the IO, but the irq context will then take the IO from the queue 
and do the DMA mapping... which needs the memory.....
