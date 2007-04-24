Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbXDXUoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbXDXUoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXDXUoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:44:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:10151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbXDXUoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:44:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="78534032:sNHT20621682"
Date: Tue, 24 Apr 2007 13:42:08 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 4/8] Supporting Zero Length Reads in Intel IOMMU.
Message-ID: <20070424204208.GD27911@linux-os.sc.intel.com>
References: <20070424060259.426374000@intel.com> <20070424061037.821838000@intel.com> <200704242128.12057.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704242128.12057.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 09:28:11PM +0200, Andi Kleen wrote:
> On Tuesday 24 April 2007 08:03:03 Ashok Raj wrote:
> > PCI specs permit zero length reads (ZLR) even if the mapping for that region 
> > is write only. Support for this feature is indicated by the presence of a bit 
> > in the DMAR capability. If a particular DMAR does not support this capability
> > we map write-only regions as read-write.
> > 
> > This option can also provides a workaround for some drivers that request
> > a write-only mapping when they really should request a read-write.
> > (We ran into one such case in eepro100.c in handling rx_ring_dma)
> 
> Better just fix the drivers instead of adding such hacks

Some of the early DMAR's dont handle zero-length-reads as required. hardware
that supports it correctly will advertise via its capabilities.

We could remove the cmdline option since it should not be really required.
