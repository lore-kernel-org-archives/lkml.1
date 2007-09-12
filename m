Return-Path: <linux-kernel-owner+w=401wt.eu-S1760119AbXIKVno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119AbXIKVno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXIKVnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:43:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:3346 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbXIKVnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:43:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,240,1186383600"; 
   d="scan'208";a="292897211"
Date: Wed, 12 Sep 2007 14:55:23 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Paul Mackerras <paulus@samba.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, akpm@osdl.org,
       Greg KH <greg@kroah.com>, muli@il.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [patch][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20070912215523.GA510@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <18148.12140.21118.252581@cargo.ozlabs.ibm.com> <20070911174231.GC24627@askeshav-devel.jf.intel.com> <20070912192854.GA32610@askeshav-devel.jf.intel.com> <18150.61732.490669.269794@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18150.61732.490669.269794@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 05:48:52AM +1000, Paul Mackerras wrote:
> Keshavamurthy, Anil S writes:
> 
> > Subject: Fix IOMMU early crash
> > 
> > This patch avoids copying pci_bus's->sysdata to
> > pci_dev's->sysdata as one can easily obtain
> > the same through pci_dev->bus->sysdata.
> 
> At the moment this will cause ppc64 to crash, since we rely on
> pci_dev->sysdata pointing to some node in the firmware device tree,
> either the device's node or the node for a parent bus.
> 
> We could change the ppc64 code to use pci_dev->bus->sysdata in the
> case when pci_dev->sysdata is NULL, which would fix the problem.  I
> think that change should be incorporated as part of this patch so that
> we don't break git bisection.

Why do you want to check if pci_dev->sysdata is NULL then use
pci_dev->bus->sysdata else pci_dev->sysdata? If you change this
to always use pci_dev->bus->sysdata, then you don;t have to depend
on my patch and your patch can get in independent of mine.

> 
> In other words I don't want to see this patch applied as it stands.
Is it possible to post your patch anytime soon? Or feel free to combine
mine with yours and post it with your signed-off-by.

Thanks,
Anil
