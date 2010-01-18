Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710Ab0ARVYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab0ARVYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896Ab0ARVYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:24:22 -0500
Received: from www.tglx.de ([62.245.132.106]:57341 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab0ARVYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:24:22 -0500
Date: Mon, 18 Jan 2010 22:24:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Julia Lawall <julia@diku.dk>
cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: mcs7830 usb net: "scheduling while atomic" danger?
In-Reply-To: <Pine.LNX.4.64.1001182206190.30446@ask.diku.dk>
Message-ID: <alpine.LFD.2.00.1001182219580.2906@localhost.localdomain>
References: <20100118184942.GA10171@rhlx01.hs-esslingen.de> <Pine.LNX.4.64.1001182206190.30446@ask.diku.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia,

On Mon, 18 Jan 2010, Julia Lawall wrote:
> On Mon, 18 Jan 2010, Andreas Mohr wrote:
>
> The semantic match shown below finds 55 matches.  All but two involve 
> mutex_lock.  Those are in the file 

As I said before the mutex_lock()/msleep() ones are fine. 

> /var/linuxes/linux-next/drivers/usb/host/ehci-hub.c
> in the functions ehci_bus_suspend and ehci_hub_control.

The msleep in ehci_hub_control() which happens with ehci->lock held
and irqs disabled is definitely buggy.

I can't see anything wrong wth the msleep in ehci_bus_suspend() as it
is _before_ the spin_lock_irq(&ehci->lock) region.

Thanks,

	tglx
