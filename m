Return-Path: <linux-kernel-owner+w=401wt.eu-S1764113AbYBTE6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764113AbYBTE6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 23:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763698AbYBTE6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 23:58:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:11811 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763651AbYBTE6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 23:58:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,379,1199692800"; 
   d="scan'208";a="381213029"
Subject: Re: [bootup crash, -git] Re: patch
	pci-pcie-aspm-support.patchadded to gregkh-2.6 tree
From: Shaohua Li <shaohua.li@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       matthew@wil.cx, "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080220041400.GA18771@suse.de>
References: <1201141317.26118.2.camel@sli10-desk.sh.intel.com>
	 <12013009171835@kroah.org> <20080202105506.GA25160@elte.hu>
	 <20080202185145.GA13005@kroah.com>
	 <1203399945.12681.8.camel@sli10-desk.sh.intel.com>
	 <20080219234529.GA12967@kroah.com>
	 <1203471367.21958.3.camel@sli10-desk.sh.intel.com>
	 <20080220041400.GA18771@suse.de>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 12:48:21 +0800
Message-Id: <1203482901.23071.5.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-19 at 20:14 -0800, Greg KH wrote:
> On Wed, Feb 20, 2008 at 09:36:07AM +0800, Shaohua Li wrote:
> > --- linux.orig/include/linux/pci-acpi.h	2008-02-19 11:03:51.000000000 +0800
> > +++ linux/include/linux/pci-acpi.h	2008-02-20 09:19:15.000000000 +0800
> > @@ -47,6 +47,7 @@
> >  				OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL)
> >  
> >  #ifdef CONFIG_ACPI
> > +#include <acpi/acpi_bus.h>
> >  extern acpi_status pci_osc_control_set(acpi_handle handle, u32 flags);
> >  extern acpi_status __pci_osc_support_set(u32 flags, const char *hid);
> >  static inline acpi_status pci_osc_support_set(u32 flags)
> > @@ -59,13 +60,11 @@ static inline acpi_status pcie_osc_suppo
> >  }
> >  #else
> >  #if !defined(AE_ERROR)
> > -typedef u32 		acpi_status;
> > -#define AE_ERROR      	(acpi_status) (0x0001)
> > -#endif    
> > -static inline acpi_status pci_osc_control_set(acpi_handle handle, u32 flags)
> > -{return AE_ERROR;}
> > -static inline acpi_status pci_osc_support_set(u32 flags) {return AE_ERROR;} 
> > -static inline acpi_status pcie_osc_support_set(u32 flags) {return AE_ERROR;}
> > +#define AE_ERROR      	(0x0001)
> > +#endif
> > +#define pci_osc_control_set(handle, flags) (AE_ERROR)
> > +#define pci_osc_support_set(flags) (AE_ERROR)
> > +#define pcie_osc_support_set(flags) (AE_ERROR)
> 
> No, please use inline functions, don't change these functions that
> should be just fine.  Why are you needing to change them?
some types aren't defined in non-ACPI, like acpi_handle, acpi_status.

Thanks,
Shaohua

