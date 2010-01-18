Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140Ab0ARVio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0ARVio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097Ab0ARVin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:38:43 -0500
Received: from www.tglx.de ([62.245.132.106]:57510 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab0ARVim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:38:42 -0500
Date: Mon, 18 Jan 2010 22:38:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Julia Lawall <julia@diku.dk>
cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: mcs7830 usb net: "scheduling while atomic" danger?
In-Reply-To: <Pine.LNX.4.64.1001182229360.30446@ask.diku.dk>
Message-ID: <alpine.LFD.2.00.1001182238010.2906@localhost.localdomain>
References: <20100118184942.GA10171@rhlx01.hs-esslingen.de> <Pine.LNX.4.64.1001182206190.30446@ask.diku.dk> <alpine.LFD.2.00.1001182219580.2906@localhost.localdomain> <Pine.LNX.4.64.1001182229360.30446@ask.diku.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010, Julia Lawall wrote:
> On Mon, 18 Jan 2010, Thomas Gleixner wrote:
> 
> > Julia,
> > 
> > On Mon, 18 Jan 2010, Julia Lawall wrote:
> > > On Mon, 18 Jan 2010, Andreas Mohr wrote:
> > >
> > > The semantic match shown below finds 55 matches.  All but two involve 
> > > mutex_lock.  Those are in the file 
> > 
> > As I said before the mutex_lock()/msleep() ones are fine. 
> 
> OK, I sem to have missed that message.
> 
> > > /var/linuxes/linux-next/drivers/usb/host/ehci-hub.c
> > > in the functions ehci_bus_suspend and ehci_hub_control.
> > 
> > The msleep in ehci_hub_control() which happens with ehci->lock held
> > and irqs disabled is definitely buggy.
> > 
> > I can't see anything wrong wth the msleep in ehci_bus_suspend() as it
> > is _before_ the spin_lock_irq(&ehci->lock) region.
> 
> There is another one later in the function:
> 
> msleep(5);/* 5ms for HCD enter low pwr mode */
> 
> In my linux-next, it is on line 181.

Ooops, missed that one. Right, that's buggy as well.

Thanks,

	tglx
