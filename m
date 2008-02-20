Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYBTH5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYBTH5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 02:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYBTH5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:57:08 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55588 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbYBTH5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:57:07 -0500
Date: Wed, 20 Feb 2008 09:56:28 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci/pcie/aer/aerdrv_acpi.c: inconsequent NULL checking
Message-ID: <20080220075628.GD31955@cs181133002.pp.htv.fi>
References: <20080219192902.GD31955@cs181133002.pp.htv.fi> <20080220054758.GB31832@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080220054758.GB31832@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 09:47:58PM -0800, Greg KH wrote:
> On Tue, Feb 19, 2008 at 09:29:02PM +0200, Adrian Bunk wrote:
> > The Coverity checker spotted the following inconsequent NULL checking 
> > introduced by commit 3c75e23784e6ed5f4841de43d0750fd9b37bafcb:
> > 
> > <--  snip  -->
> > 
> > ...
> > int aer_osc_setup(struct pcie_device *pciedev)
> > {
> > ...            vvvvvvvvv
> >         while (pdev->bus && pdev->bus->self)
> >                 pdev = pdev->bus->self;
> 
> That could probably change to just pdev->bus->self, as a bus should
> always be there for a pdev, so I don't see this as a problem.

I'm not claiming this specific case was a problem.

When a NULL check is only performed in some cases that's sometimes a bug 
that has to be fixed and in most cases a not required check that should 
be removed at some point in time.

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

