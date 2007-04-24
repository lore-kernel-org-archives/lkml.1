Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbXDXUe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbXDXUe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbXDXUe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:34:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:1802 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbXDXUez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:34:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="233282910:sNHT18210808"
Date: Tue, 24 Apr 2007 13:33:04 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when devices cannot address entire range.
Message-ID: <20070424203304.GB27911@linux-os.sc.intel.com>
References: <20070424060259.426374000@intel.com> <20070424061038.389587000@intel.com> <200704242133.16219.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704242133.16219.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 09:33:15PM +0200, Andi Kleen wrote:
> On Tuesday 24 April 2007 08:03:07 Ashok Raj wrote:
> > Some devices may not support entire 64bit DMA. In a situation where such 
> > devices are co-located in a shared domain, we need to ensure there is some 
> > address space reserved for such devices without the low addresses getting
> > depleted by other devices capable of handling high dma addresses.
> 
> Sorry, but you need to find some way to make this usually work without special
> options. Otherwise users will be unhappy.
> 
> An possible way would be to allocate space upside down from the limit of the
> device. Then the lower areas should be usually free.
> 
With PCIE there is some benefit to keep dma addr low for performance reasons, 
since it will use 	32bit Transaction level packets instead of 64bit.

This reservation is only required if we have some legacy device under a p2p 
where its required to share its addr space with other devices. We could 
implement a default when one is not specified to keep things simple.
