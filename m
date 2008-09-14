Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYINXkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYINXkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 19:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYINXjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 19:39:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50827 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbYINXjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 19:39:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] e100: Use pci_pme_active to clear PME_Status and disable PME#
Date: Mon, 15 Sep 2008 01:44:35 +0200
User-Agent: KMail/1.9.9
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alessandro Guido <alessandro.guido@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200808051730.27599.alessandro.guido@gmail.com> <200808080018.05887.rjw@sisk.pl> <48CC1F7C.7050908@garzik.org>
In-Reply-To: <48CC1F7C.7050908@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809150144.36142.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 13 of September 2008, Jeff Garzik wrote:
> Rafael J. Wysocki wrote:
> > e100: Use pci_pme_active to clear PME_Status and disable PME#
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > ---
> >  drivers/net/e100.c |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > Index: linux-2.6/drivers/net/e100.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/net/e100.c
> > +++ linux-2.6/drivers/net/e100.c
> > @@ -2738,9 +2738,7 @@ static int __devinit e100_probe(struct p
> >  		nic->flags |= wol_magic;
> >  
> >  	/* ack any pending wake events, disable PME */
> > -	err = pci_enable_wake(pdev, 0, 0);
> > -	if (err)
> > -		DPRINTK(PROBE, ERR, "Error clearing wake event\n");
> > +	pci_pme_active(pdev, false);
> 
> Since I am rusty on my PCI...  why is this needed?

Because we just want to clear PME_Status and disable PME#, but
pci_enable_wake() involves an ACPI call and generally depends on the
dev->power.can_wakeup and dev->power.should_wakeup flags being set.

The patch I sent here http://marc.info/?l=linux-kernel&m=122096638020191&w=4
has a better changelog.

Thanks,
Rafael
