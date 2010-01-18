Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108Ab0ARVf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab0ARVf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041Ab0ARVf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:35:27 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:51756 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab0ARVf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:35:26 -0500
Date: Mon, 18 Jan 2010 22:35:23 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Alek Du <alek.du@intel.com>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: mcs7830 usb net: "scheduling while atomic" danger?
In-Reply-To: <201001182223.49764.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.1001182235050.30446@ask.diku.dk>
References: <20100118184942.GA10171@rhlx01.hs-esslingen.de>
 <Pine.LNX.4.64.1001182206190.30446@ask.diku.dk> <201001182223.49764.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010, Arnd Bergmann wrote:

> On Monday 18 January 2010, Julia Lawall wrote:
> > On Mon, 18 Jan 2010, Andreas Mohr wrote:
> > > 
> > > Forgive me, but doesn't that mutex_lock()/msleep() (ab)use mean
> > > risking a "scheduling while atomic"?
> > > (such as discussed in e.g.
> > > http://search.luky.org/linux-kernel.2004/msg92817.html )
> > > 
> > > 
> > > And, if that is the case, shouldn't all such cases simply be killed for
> > > good via a capable semantic patch?
> > 
> > The semantic match shown below finds 55 matches.  All but two involve 
> > mutex_lock.  Those are in the file 
> > /var/linuxes/linux-next/drivers/usb/host/ehci-hub.c
> > in the functions ehci_bus_suspend and ehci_hub_control.
> 
> That code looks indeed broken as was added las July as part of 331ac6b288d9
> "USB: EHCI: Add Intel Moorestown EHCI controller HOSTPCx extensions and
> support phy low power mode". The reason that this hasn't triggered is
> probably the lack of Moorestown machines in the field.

The fix is just msleep -> mdelay?

julia
