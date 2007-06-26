Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbXFZTav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbXFZTav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759205AbXFZTaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:30:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:23987 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758849AbXFZTaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:30:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,464,1175497200"; 
   d="scan'208";a="100373302"
Date: Tue, 26 Jun 2007 12:25:35 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 10/10] Iommu floppy workaround
Message-ID: <20070626192535.GF3374@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070619213809.110034000@askeshav-devel.jf.intel.com> <20070625234222.a1e09a16.akpm@linux-foundation.org> <200706261237.55649.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706261237.55649.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 12:37:55PM +0200, Andi Kleen wrote:
> 
> > > Index: linux-2.6.22-rc4-mm2/arch/x86_64/Kconfig
> > > ===================================================================
> > > --- linux-2.6.22-rc4-mm2.orig/arch/x86_64/Kconfig	2007-06-18 15:45:08.000000000 -0700
> > > +++ linux-2.6.22-rc4-mm2/arch/x86_64/Kconfig	2007-06-18 15:45:09.000000000 -0700
> > > @@ -752,6 +752,16 @@
> > >  	 all the OS visible memory. Hence the driver can continue
> > >  	 to use physical addresses for DMA.
> > >  
> > > +config DMAR_FLPY_WA
> > 
> > FLOPPY is spelled "FLOPPY"!
> 
> Also this shouldn't be a user visible config.  The floppy driver should just
> do this transparently when loaded and undo when unloaded.

Yup, I agree. 

Here goes the patch to make it user invisible config option.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 arch/x86_64/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm2/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.22-rc4-mm2.orig/arch/x86_64/Kconfig	2007-06-26 12:04:42.000000000 -0700
+++ linux-2.6.22-rc4-mm2/arch/x86_64/Kconfig	2007-06-26 12:06:01.000000000 -0700
@@ -753,7 +753,7 @@
 	 to use physical addresses for DMA.
 
 config DMAR_FLOPPY_WA
-	bool "Support for Floppy disk workaround"
+	bool
 	depends on DMAR
 	default y
 	help

