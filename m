Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbXIJUcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbXIJUcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbXIJUbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:31:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:29778 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756342AbXIJUbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 16:31:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,233,1186383600"; 
   d="scan'208";a="301365592"
Date: Tue, 11 Sep 2007 13:43:59 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Paul Mackerras <paulus@samba.org>, akpm@osdl.org,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [RFC][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20070911204359.GA29380@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <18148.12140.21118.252581@cargo.ozlabs.ibm.com> <20070911174231.GC24627@askeshav-devel.jf.intel.com> <20070910202543.GS4374@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910202543.GS4374@rhun.haifa.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 11:25:43PM +0300, Muli Ben-Yehuda wrote:
> On Tue, Sep 11, 2007 at 10:42:31AM -0700, Keshavamurthy, Anil S wrote:
> 
> > Yes, I agree that pci_dev->sysdata can;t be removed. Even we (IOMMU)
> > were dependent on this field but somehow this field is being
> > overwritten to point to pci_bus's->sysdata and hence IOMMU was
> > failing. Earlier it was overwritten to NULL and hence we were not
> > failing but now it is overwritten to non-NULL and hence we fail.
> 
> Do you know which commit caused that change?
> 
> > My therory is that we don;t need to copy pci_bus's->sysdata to 
> > pci_dev's->sysdata. Below patch solves my problem.
> > Any objection to below patch?
> 
> I will give it a spin to verify it works for me, but in general I am
> wary of making such changes unless we can verify (read: audit) that
> they have no adverse side effects *on all architectures*.
Thanks Muli for your help here. I tested on x86_64 and saw no
issues. Looking at the code, pci_dev's->sysdata becomes useless 
if the intent here is to keep a copy of it's bus's->sysdata as
the same can be obtained from pci_dev->bus->sysdata.

Thanks,
Anil
