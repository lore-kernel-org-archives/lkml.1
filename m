Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZLXCLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZLXCLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 21:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZLXCLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 21:11:15 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:54081 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZLXCLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 21:11:15 -0500
Date: Thu, 24 Dec 2009 13:11:13 +1100
From: Simon Horman <horms@verge.net.au>
To: Greg KH <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] [patch] DT3155: Use pci_get_device
Message-ID: <20091224021110.GA2814@verge.net.au>
References: <20091223085448.619253793@vergenet.net>
 <20091223085551.921624544@vergenet.net>
 <20091223161932.GB26520@suse.de>
 <20091223220228.GE2719@verge.net.au>
 <20091223233728.GA19703@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223233728.GA19703@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 03:37:29PM -0800, Greg KH wrote:
> On Thu, Dec 24, 2009 at 09:02:29AM +1100, Simon Horman wrote:
> > On Wed, Dec 23, 2009 at 08:19:32AM -0800, Greg KH wrote:
> > > On Wed, Dec 23, 2009 at 07:54:49PM +1100, Simon Horman wrote:
> > > > The use of pci_find_device() is deprecated.
> > > > 
> > > > Signed-off-by: Simon Horman <horms@verge.net.au>
> > > > 
> > > > --- 
> > > > 
> > > > Compile tested only.
> > > > 
> > > > Alternatively, if pci_find_device() really needs to be used
> > > > then this code needs to depend on PCI_LEGACY.
> > > > 
> > > > Index: gregkh-2.6/drivers/staging/dt3155/dt3155_drv.c
> > > > ===================================================================
> > > > --- gregkh-2.6.orig/drivers/staging/dt3155/dt3155_drv.c	2009-12-23 18:41:46.000000000 +1100
> > > > +++ gregkh-2.6/drivers/staging/dt3155/dt3155_drv.c	2009-12-23 18:42:29.000000000 +1100
> > > > @@ -963,7 +963,7 @@ static int find_PCI (void)
> > > >    unsigned long base;
> > > >    unsigned char irq;
> > > >  
> > > > -  while ((pci_dev = pci_find_device
> > > > +  while ((pci_dev = pci_get_device
> > > 
> > > You can't just replace these two functions, they operate differently
> > > with regard to the reference counting logic.  Otherwise it wouldn't make
> > > sense to have 2 different functions :)
> > > 
> > > So I can't apply this.
> > 
> > Sorry about that.
> 
> No problem, care to fix it up properly?

Sure, I'll see what I can do.

