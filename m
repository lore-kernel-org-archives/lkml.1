Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYAPBOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYAPBOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYAPBOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:14:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:51517 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbYAPBOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:14:07 -0500
X-ExtLoop1: 1
Subject: Re: [PATCH]PCIE ASPM support - takes 2
From: Shaohua Li <shaohua.li@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>, Greg KH <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080115122200.GW18741@parisc-linux.org>
References: <1200367276.20538.1.camel@sli10-desk.sh.intel.com>
	 <20080115041943.GS18741@parisc-linux.org>
	 <1200373622.20869.2.camel@sli10-desk.sh.intel.com>
	 <20080115122200.GW18741@parisc-linux.org>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 09:14:51 +0800
Message-Id: <1200446091.26438.3.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-15 at 05:22 -0700, Matthew Wilcox wrote:
> On Tue, Jan 15, 2008 at 01:07:02PM +0800, Shaohua Li wrote:
> > > > +
> > > > +/* Called after ACPI is enabled */
> > > > +static int __init acpi_pcie_support_init(void)
> > > > +{
> > > > +	pcie_aspm_init();
> > > > +	return 0;
> > > > +}
> > > > +fs_initcall(acpi_pcie_support_init);
> > > 
> > > Is there any reason to put this in here instead of just making
> > > pcie_aspm_init an initcall?
> > yes, this will evaluate some ACPI methods, so must be called after ACPI
> > is initialized, which is a sub_system call
> 
> I wasn't saying that you should change it from being an fs_initcall.  I
> was saying that you might want to consider deleting this function and
> adding
> 
> fs_initcall(pcie_aspm_init);
> 
> in the file that defines pcie_aspm_init.
I thought we'd better put all ACPI support bits support in one routine
call, like OSC_EXT_PCI_CONFIG_SUPPORT, we didn't do it so far, so I
added a new routine. But I might be over thinking.

Thanks,
Shaohua

