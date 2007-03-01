Return-Path: <linux-kernel-owner+w=401wt.eu-S964896AbXCAKaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896AbXCAKaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 05:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964915AbXCAKaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 05:30:18 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4819 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964896AbXCAKaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 05:30:17 -0500
Date: Thu, 1 Mar 2007 10:30:04 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] Define FIXED_PORT flag for serial_core
Message-ID: <20070301103004.GA25033@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
References: <20070220031717.GI17818@localhost.localdomain> <20070220031951.56492DDD09@ozlabs.org> <20070228222630.GA11999@flint.arm.linux.org.uk> <20070228234424.GD3048@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228234424.GD3048@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 10:44:24AM +1100, David Gibson wrote:
> On Wed, Feb 28, 2007 at 10:26:30PM +0000, Russell King wrote:
> > On Tue, Feb 20, 2007 at 02:19:51PM +1100, David Gibson wrote:
> > > Therefore, this patch defines a UPF_FIXED_PORT flag for the uart_port
> > > structure.  If this flag is set when the serial port is configured,
> > > any attempts to alter the port's type, io address, irq or base clock
> > > with setserial are ignored.
> > 
> > I've been wondering about this, and it is questionable whether we
> > should allow any serial port which isn't owned by the legacy platform
> > device (the one called "serial8250", iow by the 8250 driver itself)
> > to have the base addresses and interrupts changed.
> > 
> > IOW, we apply this "fixed port" to any port registered by probe
> > modules external to the 8250 driver itself, such as PCI, PNP, etc.
> 
> Sounds reasonable to me.  But maybe in that case we should invert the
> sense of the flag.  UPF_MOVABLE_PORT or UPF_USER_CONFIGURABLE or
> something.

I was thinking about not even having a flag, but instead checking for
port->dev == &serial8250_isa_devs->dev.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
