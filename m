Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYFKJOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYFKJOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 05:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYFKJOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 05:14:40 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:47928 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYFKJOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 05:14:39 -0400
Date: Wed, 11 Jun 2008 11:14:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Brownell <david-b@pacbell.net>, Ryan Mallon <ryan@bluewatersys.com>,
       Uli Luckas <u.luckas@road.de>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Message-ID: <20080611111415.2a677a10@hyperion.delvare>
In-Reply-To: <20080611090016.GA5338@flint.arm.linux.org.uk>
References: <200806091541.43899.u.luckas@road.de>
	<484DA046.4010804@bluewatersys.com>
	<20080610085708.12c2d2a2@hyperion.delvare>
	<200806101355.07792.david-b@pacbell.net>
	<20080611101130.1a667abe@hyperion.delvare>
	<20080611090016.GA5338@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Wed, 11 Jun 2008 10:00:16 +0100, Russell King - ARM Linux wrote:
> On Wed, Jun 11, 2008 at 10:11:30AM +0200, Jean Delvare wrote:
> > Hi David,
> > 
> > On Tue, 10 Jun 2008 13:55:07 -0700, David Brownell wrote:
> > > > Why don't you simply initialize the drivers in question with
> > > > subsys_initcall()? That's what i2c-pnx, i2c-omap, i2c-davinci and
> > > > tps65010 are doing at the moment.
> > > 
> > > If they happen to sit outside the I2C tree and *before* it in
> > > link order, things will misbehave.
> > 
> > Well, i2c system bus drivers shouldn't sit outside of the I2C tree, so
> > that's not a problem. If you start accepting that drivers live at
> > random places in the source tree, then there's simply no way to get
> > things right.
> 
> That's simply not a realistic view.  As I've already pointed out,
> framebuffer devices have I2C busses for reading the DDC information
> from monitors.  These I2C bus drivers live in drivers/video.
> 
> Video grabbers have I2C busses for controlling, eg, tuners and video
> decoders.  These live in drivers/media.
> 
> If I follow your argument, would you like cyber2000fb.c to be moved
> entirely from drivers/video into drivers/i2c/busses because it contains
> an i2c bus driver?  Clearly not.

Please read what I wrote again. I said: I2C SYSTEM BUS drivers should
live under drivers/i2c. DDC channels on graphics adapters and I2C buses
on multimedia adapters definitely do not qualify as system buses (and
don't need to be initialized early, either.)

Thanks,
-- 
Jean Delvare
