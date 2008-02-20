Return-Path: <linux-kernel-owner+w=401wt.eu-S933723AbYBTQc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723AbYBTQc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932428AbYBTQOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:14:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49840 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbYBTQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:14:11 -0500
Date: Wed, 20 Feb 2008 08:09:35 -0800
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci/pcie/aer/aerdrv_acpi.c: inconsequent NULL checking
Message-ID: <20080220160935.GA2658@kroah.com>
References: <20080219192902.GD31955@cs181133002.pp.htv.fi> <20080220054758.GB31832@kroah.com> <20080220075628.GD31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220075628.GD31955@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 09:56:28AM +0200, Adrian Bunk wrote:
> On Tue, Feb 19, 2008 at 09:47:58PM -0800, Greg KH wrote:
> > On Tue, Feb 19, 2008 at 09:29:02PM +0200, Adrian Bunk wrote:
> > > The Coverity checker spotted the following inconsequent NULL checking 
> > > introduced by commit 3c75e23784e6ed5f4841de43d0750fd9b37bafcb:
> > > 
> > > <--  snip  -->
> > > 
> > > ...
> > > int aer_osc_setup(struct pcie_device *pciedev)
> > > {
> > > ...            vvvvvvvvv
> > >         while (pdev->bus && pdev->bus->self)
> > >                 pdev = pdev->bus->self;
> > 
> > That could probably change to just pdev->bus->self, as a bus should
> > always be there for a pdev, so I don't see this as a problem.
> 
> I'm not claiming this specific case was a problem.

Well, Coverity did :)

> When a NULL check is only performed in some cases that's sometimes a bug 
> that has to be fixed and in most cases a not required check that should 
> be removed at some point in time.

I agree, patches are always welcome...

thanks,

greg k-h
