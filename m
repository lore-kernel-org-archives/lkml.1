Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXJDBUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXJDBUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 21:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXJDBTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 21:19:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:43515 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbXJDBTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 21:19:54 -0400
Subject: Re: [patch take 2][Intel-IOMMU] Fix for IOMMU early crash
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Greg KH <greg@kroah.com>, muli@il.ibm.com, paulus@samba.org,
       kristen.c.accardi@intel.com
In-Reply-To: <20071003211327.GA14159@askeshav-devel.jf.intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com>
	 <18148.12140.21118.252581@cargo.ozlabs.ibm.com>
	 <20070911174231.GC24627@askeshav-devel.jf.intel.com>
	 <20070912192854.GA32610@askeshav-devel.jf.intel.com>
	 <18150.61732.490669.269794@cargo.ozlabs.ibm.com>
	 <20071003211327.GA14159@askeshav-devel.jf.intel.com>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 11:19:33 +1000
Message-Id: <1191460773.22572.139.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: 2.6-mm/include/linux/pci.h
> ===================================================================
> --- 2.6-mm.orig/include/linux/pci.h	2007-10-03 13:48:20.000000000 -0700
> +++ 2.6-mm/include/linux/pci.h	2007-10-03 13:49:08.000000000 -0700
> @@ -195,6 +195,7 @@
>  #ifdef CONFIG_PCI_MSI
>  	struct list_head msi_list;
>  #endif
> +	void		*iommu_private;	/* hook for IOMMU specific extension */
>  };

I'm not fan of this. That would imply that iommu stuff is specific to
PCI or that sort of thing.

Why don't you use the new struct dev_archdata mechanism ? That's what I
use on powerpc to provide optional iommu linkage to any device in the
system.

Ben.


