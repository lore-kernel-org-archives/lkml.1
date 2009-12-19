Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZLSErt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZLSErt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 23:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZLSErs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 23:47:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446AbZLSErr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 23:47:47 -0500
Date: Fri, 18 Dec 2009 20:47:47 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Scott Smedley <ss@aao.gov.au>
Subject: Re: linux-next: Tree for December 19 (staging/dt3155)
Message-ID: <20091219044747.GB14503@suse.de>
References: <20091219110457.d6c5de1f.sfr@canb.auug.org.au> <20091218191037.d6b4727b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218191037.d6b4727b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 07:10:37PM -0800, Randy Dunlap wrote:
> On Sat, 19 Dec 2009 11:04:57 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > I said:
> > > News:  there will be no linux-next releases until at least Dec 24 and,
> > > more likely, Dec 29.  Have a Merry Christmas and take a break.  :-)
> > 
> > Well, I decided I had time for one more so it will be based in -rc1).
> > 
> > This one has not had the build testing *between* merges, but has had all
> > the normal build testing at the end.  Since the latter testing showed no
> > problems, this just means that there may be more unbisectable points in
> > the tree (but that is unlikely).
> 
> 
> When CONFIG_DT3155=y (i.e., not a loadable module):

Ick, I'll change that to 'M' now, it shouldn't be built in just yet for
the reasons you found.

I don't think the code has ever been built as 'y' as you just found out.

> 
> (a)
> drivers/staging/dt3155/dt3155_drv.c:967: error: implicit declaration of function 'pci_find_device'
> drivers/staging/dt3155/dt3155_drv.c:1151: error: implicit declaration of function 'request_irq'
> drivers/staging/dt3155/dt3155_drv.c:1152: error: 'IRQF_SHARED' undeclared (first use in this function)
> drivers/staging/dt3155/dt3155_drv.c:1152: error: 'IRQF_DISABLED' undeclared (first use in this function)
> drivers/staging/dt3155/dt3155_drv.c:1195: error: implicit declaration of function 'free_irq'
> 
> 
> #ifdef MODULE
> #include <linux/interrupt.h>
> 
> linux/interrupt.h is needed for DT3155=y, not just when DT3155=m.
> 
> Oh, and this config has:  # CONFIG_PCI_LEGACY is not set
> which accounts for pci_find_device() being unknown.
> If that is required (as it is currently, even though this function is
> deprecated), it can be expressed in the driver's Kconfig file:
> 	depends on PCI_LEGACY
>

I'll fix this up to just not need this anymore, as it should be fixed.

> (b) when compiling goes further:
> 
> drivers/staging/dt3155/dt3155_drv.c:571: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
> drivers/staging/dt3155/dt3155_drv.c:571: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
> drivers/staging/dt3155/dt3155_drv.c:657: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
> drivers/staging/dt3155/dt3155_drv.c:657: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
> 
> 
> 
> General:
> 
> #ifndef CONFIG_PCI
> #error  "DT3155 :  Kernel PCI support not enabled (DT3155 drive requires PCI)"
> #endif
> 
> That should be handled via Kconfig, not in a .c file.
> Ah, it is done in Kconfig, so those lines above (in .c file) can be deleted.

Yes, lots of stuff in the .c file can be deleted :)

thanks,

greg k-h
