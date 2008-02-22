Return-Path: <linux-kernel-owner+w=401wt.eu-S933886AbYBVUEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbYBVUEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932295AbYBVT7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:59:47 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44833 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbYBVT7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:59:36 -0500
Date: Fri, 22 Feb 2008 21:58:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [2.6 patch] pci/pcie/aer/aerdrv_acpi.c: remove unneeded NULL check
Message-ID: <20080222195847.GK1409@cs181133002.pp.htv.fi>
References: <20080219192902.GD31955@cs181133002.pp.htv.fi> <20080220054758.GB31832@kroah.com> <20080220075628.GD31955@cs181133002.pp.htv.fi> <20080220160935.GA2658@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080220160935.GA2658@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 08:09:35AM -0800, Greg KH wrote:
> On Wed, Feb 20, 2008 at 09:56:28AM +0200, Adrian Bunk wrote:
> > On Tue, Feb 19, 2008 at 09:47:58PM -0800, Greg KH wrote:
> > > On Tue, Feb 19, 2008 at 09:29:02PM +0200, Adrian Bunk wrote:
> > > > The Coverity checker spotted the following inconsequent NULL checking 
> > > > introduced by commit 3c75e23784e6ed5f4841de43d0750fd9b37bafcb:
> > > > 
> > > > <--  snip  -->
> > > > 
> > > > ...
> > > > int aer_osc_setup(struct pcie_device *pciedev)
> > > > {
> > > > ...            vvvvvvvvv
> > > >         while (pdev->bus && pdev->bus->self)
> > > >                 pdev = pdev->bus->self;
> > > 
> > > That could probably change to just pdev->bus->self, as a bus should
> > > always be there for a pdev, so I don't see this as a problem.
> > 
> > I'm not claiming this specific case was a problem.
> 
> Well, Coverity did :)

It only said it's once checked and once not.

> > When a NULL check is only performed in some cases that's sometimes a bug 
> > that has to be fixed and in most cases a not required check that should 
> > be removed at some point in time.
> 
> I agree, patches are always welcome...

Patch below.

> thanks,
> 
> greg k-h

cu
Adrian


<--  snip  -->


There's no reason for checking pdev->bus for being NULL here (and we'd 
anyway Oops 3 lines below if it was).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
74832021c82be6e2ed6055f4f25dbf152df67cf5 diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 8c199ae..1e2a858 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -34,7 +34,7 @@ int aer_osc_setup(struct pcie_device *pciedev)
 	acpi_handle handle = 0;
 
 	/* Find root host bridge */
-	while (pdev->bus && pdev->bus->self)
+	while (pdev->bus->self)
 		pdev = pdev->bus->self;
 	handle = acpi_get_pci_rootbridge_handle(
 		pci_domain_nr(pdev->bus), pdev->bus->number);

