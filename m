Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbXF2T2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbXF2T2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 15:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbXF2T2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 15:28:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:36151 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbXF2T2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 15:28:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,476,1175497200"; 
   d="scan'208";a="260503213"
Date: Fri, 29 Jun 2007 12:23:53 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Robert Hancock <hancockr@shaw.ca>, Zan Lynx <zlynx@acm.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: 2.6.22-rc6-mm1 Intel DMAR crash on AMD x86_64
Message-ID: <20070629192353.GA12413@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <46845943.7050005@shaw.ca> <FC1D1B23302A22499C60C967336B2AE0016F7529@pdsmsx411.ccr.corp.intel.com> <20070629152858.GA27995@linux-os.sc.intel.com> <20070629162343.GD27698@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629162343.GD27698@rhun.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 12:23:43PM -0400, Muli Ben-Yehuda wrote:
> On Fri, Jun 29, 2007 at 08:28:58AM -0700, Keshavamurthy, Anil S wrote:
> 
> > +++ linux-2.6.22-rc4-mm2/drivers/pci/dmar.c	2007-06-29 07:46:25.000000000 -0700
> > @@ -260,6 +260,8 @@
> >  	int ret = 0;
> >  
> >  	dmar = (struct acpi_table_dmar *)dmar_tbl;
> > +	if (!dmar)
> > +		return -ENODEV;
> >  
> >  	if (!dmar->width) {
> >  		printk (KERN_WARNING PREFIX "Zero: Invalid DMAR haw\n");
> > @@ -301,7 +303,7 @@
> >  
> >  	parse_dmar_table();
> >  	if (list_empty(&dmar_drhd_units)) {
> > -		printk(KERN_ERR PREFIX "No DMAR devices found\n");
> > +		printk(KERN_INFO PREFIX "No DMAR devices found\n");
> >  		return -ENODEV;
> >  	}
> >  	return 0;
> 
> The convention is to print a KERN_DEBUG message if hardware is not
> found when probing it, otherwise the boot messages become cluttered
> with lots of "$FOO not found".

Since this is IOMMU is built into the kernel and it is
good idea to report that the device is not present. The 
above is printed only once and is consistent with other
IOMMU implementation. Atleast it is useful when people 
report bugs we can makeout whether IOMMU is being detected
or not.

Here is what I see on my box.
[..]
"PCI-GART: No AMD northbridge found."
[..]
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[..]

As you can see I don;t have either GART or Calgary on my box.

-Thanks,
Anil
