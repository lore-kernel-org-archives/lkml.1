Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbXIIPbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbXIIPbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 11:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757531AbXIIPbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 11:31:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:44548 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525AbXIIPbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 11:31:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,227,1186383600"; 
   d="scan'208";a="299604082"
Date: Mon, 10 Sep 2007 08:43:59 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, akpm@osdl.org,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [RFC][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20070910154358.GA24627@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <20070909111619.GF31099@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909111619.GF31099@rhun.haifa.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 02:16:19PM +0300, Muli Ben-Yehuda wrote:
> On Sat, Sep 08, 2007 at 01:05:24PM -0700, Keshavamurthy, Anil S wrote:
> 
> > Subject: [RFC][Intel-IOMMU] Fix for IOMMU early crash
> 
> This patch feels like a huge hack. See below.
You seem to be jumping to conclusion without going
in detail. The pci_dev struct contains pointer to sysdata,
which in turn points to the copy of its parent's bus sysdata.
So technically speaking we can eliminate sysdata pointer from
pci_dev struct which is what one portion of this patch does.

> 
> > This patch removes sysdata from pci_dev struct and creates a new
> > field called sys_data which is exclusively used by IOMMU driver to
> > keep its per device context pointer.
> 
> Hmpf, why is this needed? with the pci_sysdata work that recently went
> into mainline we have a void *iommu member in pci_sysdata which should
> be all that's needed. Please elaborate if it's not enough for your
> needs.
I looked at your patch and it was not suitable because I need to store
iommu private pointer in pci_dev and not in the pci_bus. So I have added
a new member sys_data in the pci_dev struct. I can change the name from 
sys_dev to iomu_priv to clear the confusion. Do let me know.


-Anil






> 
> Thanks,
> Muli
