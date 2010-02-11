Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0BKQqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 11:46:47 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:55109 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab0BKQqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:46:45 -0500
Date: Thu, 11 Feb 2010 08:44:30 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Scott Smedley <ss@aao.gov.au>
Subject: Re: linux-next: Tree for December 19 (staging/dt3155)
Message-Id: <20100211084430.5fd5afbb.randy.dunlap@oracle.com>
In-Reply-To: <20091219044747.GB14503@suse.de>
References: <20091219110457.d6c5de1f.sfr@canb.auug.org.au>
	<20091218191037.d6b4727b.randy.dunlap@oracle.com>
	<20091219044747.GB14503@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B74345A.0178:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 20:47:47 -0800 Greg KH wrote:

> On Fri, Dec 18, 2009 at 07:10:37PM -0800, Randy Dunlap wrote:
> > On Sat, 19 Dec 2009 11:04:57 +1100 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > I said:
> > > > News:  there will be no linux-next releases until at least Dec 24 and,
> > > > more likely, Dec 29.  Have a Merry Christmas and take a break.  :-)
> > > 
> > > Well, I decided I had time for one more so it will be based in -rc1).
> > > 
> > > This one has not had the build testing *between* merges, but has had all
> > > the normal build testing at the end.  Since the latter testing showed no
> > > problems, this just means that there may be more unbisectable points in
> > > the tree (but that is unlikely).
> > 
> > 
> > When CONFIG_DT3155=y (i.e., not a loadable module):
> 
> Ick, I'll change that to 'M' now, it shouldn't be built in just yet for
> the reasons you found.
> 
> I don't think the code has ever been built as 'y' as you just found out.

Greg,
Did you get around to making any of these changes?


> > (a)
> > drivers/staging/dt3155/dt3155_drv.c:967: error: implicit declaration of function 'pci_find_device'
> > drivers/staging/dt3155/dt3155_drv.c:1151: error: implicit declaration of function 'request_irq'
> > drivers/staging/dt3155/dt3155_drv.c:1152: error: 'IRQF_SHARED' undeclared (first use in this function)
> > drivers/staging/dt3155/dt3155_drv.c:1152: error: 'IRQF_DISABLED' undeclared (first use in this function)
> > drivers/staging/dt3155/dt3155_drv.c:1195: error: implicit declaration of function 'free_irq'
> > 
> > 
> > #ifdef MODULE
> > #include <linux/interrupt.h>
> > 
> > linux/interrupt.h is needed for DT3155=y, not just when DT3155=m.
> > 
> > Oh, and this config has:  # CONFIG_PCI_LEGACY is not set
> > which accounts for pci_find_device() being unknown.
> > If that is required (as it is currently, even though this function is
> > deprecated), it can be expressed in the driver's Kconfig file:
> > 	depends on PCI_LEGACY
> >
> 
> I'll fix this up to just not need this anymore, as it should be fixed.
> 
> > (b) when compiling goes further:
> > 
> > drivers/staging/dt3155/dt3155_drv.c:571: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
> > drivers/staging/dt3155/dt3155_drv.c:571: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
> > drivers/staging/dt3155/dt3155_drv.c:657: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
> > drivers/staging/dt3155/dt3155_drv.c:657: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
> > 
> > 
> > 
> > General:
> > 
> > #ifndef CONFIG_PCI
> > #error  "DT3155 :  Kernel PCI support not enabled (DT3155 drive requires PCI)"
> > #endif
> > 
> > That should be handled via Kconfig, not in a .c file.
> > Ah, it is done in Kconfig, so those lines above (in .c file) can be deleted.
> 
> Yes, lots of stuff in the .c file can be deleted :)


---
~Randy
