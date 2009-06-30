Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbZF3XL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbZF3XL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbZF3XLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:11:04 -0400
Received: from kroah.org ([198.145.64.141]:56480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593AbZF3XLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:11:03 -0400
Date: Tue, 30 Jun 2009 16:03:14 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Witold Szczeponik <Witold.Szczeponik@gmx.net>, stable@kernel.org,
       rjw@sisk.pl, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       abelay@mit.edu, bjorn.helgaas@hp.com
Subject: Re: [stable] [PATCH] PNPACPI: Enable PNPACPI _PSx Support, v3
Message-ID: <20090630230314.GD2634@kroah.com>
References: <49D101DA.50201@gmx.net> <200904021510.37517.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904021510.37517.trenn@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 03:10:36PM +0200, Thomas Renninger wrote:
> Hi,
> 
> I remember a bug (serial device not working)
> related to serial and docking on Lenovo.
> I wonder whether this could be related to this fix.
> 
> This one also looks worth adding to stable kernel, at least
> after 2.6.30 does not show regressions for a while.
> 
> On Monday 30 March 2009 19:31:06 Witold Szczeponik wrote:
> > Subject: Enable PNPACPI _PSx Support, v3
> > 
> > 
> > (This is an update to the patch presented earlier in
> > http://lkml.org/lkml/2008/12/8/284, with new error handling.)
> > 
> > This patch sets the power of PnP ACPI devices to D0 when they
> > are activated and to D3 when they are disabled.  The latter is
> > in correspondence with the ACPI 3.0 specification, whereas the
> > former is added in order to be able to power up a device after
> > it has been previously disabled (or when booting up a system).
> > (As a consequence, the patch makes the PnP ACPI code more ACPI
> > compliant.)
> > 
> > Section 6.2.2 of the ACPI Specification (at least versions 1.0b
> > and 3.0a) states: "Prior to running this control method [_DIS],
> > the OS[PM] will have already put the device in the D3 state."
> > Unfortunately, there is no clear statement as to when to put
> > a device in the D0 state. :-( Therefore, the patch executes the
> > method calls as _PS3/_DIS and _SRS/_PS0. What is clear: "If the
> > device is disabled, _SRS enables the device at the specified
> > resources." (From the ACPI 3.0a Specification.)
> > 
> > The patch fixes a problem with some IBM ThinkPads (at least the
> > 600E and the 600X) where the serial ports have a dedicated
> > power source that needs to be brought up before the serial port
> > can be used.  Without this patch, the serial port is enabled
> > but has no power. (In the past, the tpctl utility had to be
> > utilized to turn on the power, but support for this feature
> > stopped with version 5.9 as it did not support the more recent
> > kernel versions.)
> > 
> > The error handlers that handle any errors that can occur during
> > the power up/power down phases return the error codes to the
> > caller directly.  Comments welcome! :-)
> > 
> > No regressions were observed on hardware that does not require
> > this patch.
> > 
> > The patch is applied against 2.6.27.x.
> > 
> > 
> > Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
> CC: stable@kernel.org
> ...

What specific git commit id in Linus's tree is this?

thanks,

greg k-h
