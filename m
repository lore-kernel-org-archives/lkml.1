Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYFKU4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYFKU4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbYFKUyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:54:46 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34301 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479AbYFKUyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:54:36 -0400
Date: Wed, 11 Jun 2008 22:54:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Message-ID: <20080611225416.169574a0@hyperion.delvare>
In-Reply-To: <200806111327.09298.david-b@pacbell.net>
References: <200806091541.43899.u.luckas@road.de>
	<485031D5.3020606@bluewatersys.com>
	<20080611141852.3ccd89ea@hyperion.delvare>
	<200806111327.09298.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 13:27:09 -0700, David Brownell wrote:
> On Wednesday 11 June 2008, Jean Delvare wrote:
> > On Thu, 12 Jun 2008 08:13:09 +1200, Ryan Mallon wrote:
> > >                               As David suggested, if i2c is needed early
> > > in enough cases, why not just move it early in the link order? My patch
> > > was just an alternative approach which mimics the current behaviour, but
> > > makes it possible to get any i2c driver early. Why not just mark all of
> > > the drivers/busses that get used on embedded devices as subsys_initcall,
> > > just in case somebody needs them early?
> > 
> > Because this is an abuse of subsys_initcall? I guess that was
> > acceptable when only a couple drivers were doing that, but making it
> > official sounds bad.
> 
> How would it be an abuse?  On those systems, I2C is a "system bus"
> and needs to be initialized early for the same reasons PCI gets set
> up very early on PC hardware.

But the pci subsystem doesn't make use of subsys_initcall(). Instead,
it is simply placed early in the link order.

That being said, I'm not sure if the comparison with the PCI subsystem
holds... I am under the impression that PCI bus handling doesn't
require dedicated drivers? At least I can't see any under drivers/pci.

> There's no rule saying that subsystem initialization may not include
> the essential drivers -- in this case, i2c_adapter drivers.  PCI hubs
> and bridges are certainly initialized very early, before module_init
> code runs...

Care to point me to actual code to backup this "certainly"?

> And in fact it seems a bit odd to think that initializing any bus
> subsystem shouldn't be allowed to include its bus adapters.  It's
> not as if the subsystem has completed initializiation until those
> adapters are usable!!

I think it makes a lot of sense to initialize the core of a subsystem
early, so that all devices and drivers can be registered. This doesn't
imply registering the hardware bus drivers too, even though in some
cases it is also needed. I doubt that whoever designed subsys_initcall
meant it to be used for all bus drivers, otherwise he/she would have
named it, say, busdrv_initcall.

But don't get me wrong: if subsys_initcall is the way to go, that's
alright with me, that's way less work than having to move drivers to
different directories and fixing the link order.

-- 
Jean Delvare
