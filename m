Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbXDXUlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbXDXUlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbXDXUlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:41:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:19579 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbXDXUlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:41:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="236045977:sNHT18530988"
Date: Tue, 24 Apr 2007 13:39:20 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 7/8] Support for legacy ISA devices
Message-ID: <20070424203919.GC27911@linux-os.sc.intel.com>
References: <20070424060259.426374000@intel.com> <20070424061038.252959000@intel.com> <200704242131.10139.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704242131.10139.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 09:31:09PM +0200, Andi Kleen wrote:
> On Tuesday 24 April 2007 08:03:06 Ashok Raj wrote:
> > Floppy disk drivers dont work well with DMA remapping.
> 
> What is the problem? You can't allocate mappings <16MB?

No.. these drivers dont call DMA mapping api's.. thats the problem.

> 
> > Its possible to  
> > extend the current use for x86_64, but the gain is very little. If someone
> > feels compelled to clean this up, its up for grabs. Since these use 16M, we 
> > just provide a unity map for the ISA bridge device.
> > 
> 
> While it's probably not worth for the floppy there are other devices
> with similar weird addressing limitations. Some generic handling of it
> would be nice.
> 

In the intro we had outlined a way to handle this via a generic unity
map for all devices, we could do that, i.e

- implement a generic 1-1 map if the device is not calling dma api's and 
dynamically dissociate it if the device does start using dma apis.

For some of the addr reservation as well, we could use set_dma_mask() 
to ensure there is some dma space. Problem is some drivers may not use 
dma apis. Also it might be difficult to address device hotplugged that 
has a weird requirement.
