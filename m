Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbXJDBmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbXJDBmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 21:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXJDBlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 21:41:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:35704 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbXJDBlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 21:41:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,226,1188802800"; 
   d="scan'208";a="334574489"
Date: Wed, 3 Oct 2007 18:36:07 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Greg KH <greg@kroah.com>, muli@il.ibm.com, paulus@samba.org,
       kristen.c.accardi@intel.com
Subject: Re: [patch take 2][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20071004013606.GA14755@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <18148.12140.21118.252581@cargo.ozlabs.ibm.com> <20070911174231.GC24627@askeshav-devel.jf.intel.com> <20070912192854.GA32610@askeshav-devel.jf.intel.com> <18150.61732.490669.269794@cargo.ozlabs.ibm.com> <20071003211327.GA14159@askeshav-devel.jf.intel.com> <1191460773.22572.139.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191460773.22572.139.camel@pasglop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 11:19:33AM +1000, Benjamin Herrenschmidt wrote:
> > Index: 2.6-mm/include/linux/pci.h
> > ===================================================================
> > --- 2.6-mm.orig/include/linux/pci.h	2007-10-03 13:48:20.000000000 -0700
> > +++ 2.6-mm/include/linux/pci.h	2007-10-03 13:49:08.000000000 -0700
> > @@ -195,6 +195,7 @@
> >  #ifdef CONFIG_PCI_MSI
> >  	struct list_head msi_list;
> >  #endif
> > +	void		*iommu_private;	/* hook for IOMMU specific extension */
> >  };
> 
> I'm not fan of this. That would imply that iommu stuff is specific to
> PCI or that sort of thing.
> 
> Why don't you use the new struct dev_archdata mechanism ? That's what I
> use on powerpc to provide optional iommu linkage to any device in the
> system.
Good one. I will certainly try out your idea and will update the list
tomorrow.

-Anil
