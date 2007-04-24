Return-Path: <linux-kernel-owner+w=401wt.eu-S1423089AbXDXVBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423089AbXDXVBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423113AbXDXVBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:01:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:25719 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423089AbXDXVBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:01:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="233296742:sNHT2350697685"
Date: Tue, 24 Apr 2007 13:59:45 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 3/8] Generic hardware support for Intel IOMMU.
Message-ID: <20070424205944.GE27911@linux-os.sc.intel.com>
References: <20070424060259.426374000@intel.com> <20070424061037.653635000@intel.com> <200704242127.09221.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704242127.09221.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 09:27:08PM +0200, Andi Kleen wrote:
> On Tuesday 24 April 2007 08:03:02 Ashok Raj wrote:
> >
> > +#ifdef CONFIG_DMAR
> > +#ifdef CONFIG_SMP
> > +static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
> 
> 
> Why does it need an own interrupt type?

Problem is its MSI type interrupt, but we cannot use pci_dev since its not
a PCI device, hence requires its own way of setup etc.

> 
> > +
> > +config IOVA_GUARD_PAGE
> > +	bool "Enables gaurd page when allocating IO Virtual Address for IOMMU"
> > +	depends on DMAR
> > +
> > +config IOVA_NEXT_CONTIG
> > +	bool "Keeps IOVA allocations consequent between allocations"
> > +	depends on DMAR && EXPERIMENTAL
> 
> Needs reference to Intel and better description
> 
> The file should have a high level description what it is good for etc.
> 
> Need high level overview over what locks protects what and if there
> is a locking order.
> 
> It doesn't seem to enable sg merging? Since you have enough space 
> that should work.

Most of the IOVA stuff is really generic, and could be used outside
of the Intel code with probably some rework. Since today only DMAR 
requires it we have depends on DMAR, but we could make it more generic
and let the IOMMU driver just turn it on as required.

> 
> > +static char *fault_reason_strings[] =
> > +{
> > +	"Software",
> > +	"Present bit in root entry is clear",
> > +	"Present bit in context entry is clear",
> > +	"Invalid context entry",
> > +	"Access beyond MGAW",
> > +	"PTE Write access is not set",
> > +	"PTE Read access is not set",
> > +	"Next page table ptr is invalid",
> > +	"Root table address invalid",
> > +	"Context table ptr is invalid",
> > +	"non-zero reserved fields in RTP",
> > +	"non-zero reserved fields in CTP",
> > +	"non-zero reserved fields in PTE",
> > +	"Unknown"
> > +};
> > +
> > +#define MAX_FAULT_REASON_IDX 	(12)
> 
> 
> You got 14 of them. better use ARRAY_SIZE

Its the last index(zero based) of the useful entry returned by the fault record.

Only used to find out if index from fault record is out of bounds.

We will work on the remaining comments and repost.
