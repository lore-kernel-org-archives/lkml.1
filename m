Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbXDXUS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbXDXUS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbXDXUS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:18:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:18346 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbXDXUS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:18:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="233274171:sNHT25128523"
Date: Tue, 24 Apr 2007 13:17:03 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 1/8] ACPI support for Intel Virtualization Technology for Directed I/O
Message-ID: <20070424201703.GA27911@linux-os.sc.intel.com>
References: <20070424060259.426374000@intel.com> <20070424061037.361212000@intel.com> <200704242050.49253.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704242050.49253.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 08:50:48PM +0200, Andi Kleen wrote:
> 
> > +
> > +LIST_HEAD(dmar_drhd_units);
> > +LIST_HEAD(dmar_rmrr_units);
> 
> Comment describing what lock protects those lists?
> In fact there seems to be no locking. What about hotplug?
> 

There is no support to handle an IOMMU hotplug at this time. IOMMU hotplug
requires additional support via ACPI that needs to be extended to handle this.

These definitions are scanned at boot time from BIOS tables. They are
pretty much static data that we process during boot. Hence no locking is 
required. We pretty much tread this as read only, and the information never 
gets changed after initial parsing.
