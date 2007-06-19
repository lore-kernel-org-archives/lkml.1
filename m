Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbXFSX3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbXFSX3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756379AbXFSX3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:29:17 -0400
Received: from mga07.intel.com ([143.182.124.22]:37428 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753054AbXFSX3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:29:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,440,1175497200"; 
   d="scan'208";a="241031577"
Message-ID: <46786668.6050507@linux.intel.com>
Date: Tue, 19 Jun 2007 16:27:36 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures in dma map
 api calls
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070619213808.798646000@askeshav-devel.jf.intel.com> <Pine.LNX.4.64.0706191624110.15951@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706191624110.15951@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 19 Jun 2007, Keshavamurthy, Anil S wrote:
> 
> 
>> So far in our test scenario, we were unable to create
>> any memory allocation failure inside dma map api calls.
> 
> All these functions should have gfp_t flags passed to them.

why?

> Otherwise you are locked into the use of GFP_ATOMIC.

all callers pretty much are either in irq context or with spinlocks 
held. Good luck..... it's also called primarily from the PCI DMA API 
which doesn't take a gfp_t argument in the first place...

so I'm not seeing the point.
