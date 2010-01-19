Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151Ab0ASG0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab0ASG0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 01:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986Ab0ASGZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 01:25:59 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:40436 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab0ASGZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 01:25:58 -0500
Date: Tue, 19 Jan 2010 07:25:55 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Du, Alek" <alek.du@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andreas Mohr <andi@lisas.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: RE: mcs7830 usb net: "scheduling while atomic" danger?
In-Reply-To: <ED3036A092A28F4C91B0B4360DD128EA35987814@shzsmsx502.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.1001190725050.17802@ask.diku.dk>
References: <20100118184942.GA10171@rhlx01.hs-esslingen.de>
 <Pine.LNX.4.64.1001182206190.30446@ask.diku.dk> <201001182223.49764.arnd@arndb.de>
 <ED3036A092A28F4C91B0B4360DD128EA35987814@shzsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So you will fix /var/linuxes/linux-next/drivers/usb/host/ehci-hub.c?

I think it is a bit out of my expertise...

julia


On Tue, 19 Jan 2010, Du, Alek wrote:

> I confirm that thing is bad, I need to prepare another patch to fix that.
> 
> Thanks,
> Alek
> >-----Original Message-----
> >From: Arnd Bergmann [mailto:arnd@arndb.de]
> >Sent: Tuesday, January 19, 2010 5:24 AM
> >To: Julia Lawall
> >Cc: Andreas Mohr; linux-kernel@vger.kernel.org; Greg KH; Du, Alek; Pan, Jacob
> >jun; Alan Stern
> >Subject: Re: mcs7830 usb net: "scheduling while atomic" danger?
> >
> >On Monday 18 January 2010, Julia Lawall wrote:
> >> On Mon, 18 Jan 2010, Andreas Mohr wrote:
> >> >
> >> > Forgive me, but doesn't that mutex_lock()/msleep() (ab)use mean
> >> > risking a "scheduling while atomic"?
> >> > (such as discussed in e.g.
> >> > http://search.luky.org/linux-kernel.2004/msg92817.html )
> >> >
> >> >
> >> > And, if that is the case, shouldn't all such cases simply be killed for
> >> > good via a capable semantic patch?
> >>
> >> The semantic match shown below finds 55 matches.  All but two involve
> >> mutex_lock.  Those are in the file
> >> /var/linuxes/linux-next/drivers/usb/host/ehci-hub.c
> >> in the functions ehci_bus_suspend and ehci_hub_control.
> >
> >That code looks indeed broken as was added las July as part of 331ac6b288d9
> >"USB: EHCI: Add Intel Moorestown EHCI controller HOSTPCx extensions and
> >support phy low power mode". The reason that this hasn't triggered is
> >probably the lack of Moorestown machines in the field.
> >
> >	Arnd
> 
