Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbXIIUsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbXIIUsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759161AbXIIUsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:48:00 -0400
Received: from ozlabs.org ([203.10.76.45]:35605 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935AbXIIUr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:47:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18148.12140.21118.252581@cargo.ozlabs.ibm.com>
Date: Mon, 10 Sep 2007 03:37:48 +1000
From: Paul Mackerras <paulus@samba.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: akpm@osdl.org, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [RFC][Intel-IOMMU] Fix for IOMMU early crash
In-Reply-To: <20070908200523.GA16204@askeshav-devel.jf.intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keshavamurthy, Anil S writes:

> Subject: [RFC][Intel-IOMMU] Fix for IOMMU early crash
> 
> Populating pci_bus->sysdata way early in the pci discovery phase
> sets NON-NULL value to pci_dev->sysdata which breaks the assumption
> in the Intel IOMMU driver and crashes the system.
> 
> 
> In the drivers/pci/probe.c, pci_dev->sysdata gets a copy of
> its pci_bus->sysdata which is not required as
> the same can be obtained from pci_dev->bus->sysdata. More over 
> the left hand assignment of pci_dev->sysdata is never being used,

Wrong.  You needed to grep a bit more widely...

> so their is no point is setting 
> pci_dev->sysdata = pci_bus->sysdata;
> 
> This patch removes sysdata from pci_dev struct and creates a new
> field called sys_data which is exclusively used 
> by IOMMU driver to keep its per device context pointer.

This will break powerpc, because we use the pci_dev->sysdata field to
point to a firmware device tree node.  Please figure out another way
to solve your problem.

Paul.
