Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbXK0I70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbXK0I70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 03:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXK0I7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 03:59:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:21161 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbXK0I7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 03:59:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,218,1194249600"; 
   d="scan'208";a="404140926"
Subject: Re: 2.6.24: Serial disabled in BIOS but serial modules still
	loaded (probably PnP related)
From: Shaohua Li <shaohua.li@intel.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <200711252301.34503.arvidjaar@mail.ru>
References: <fa.P01QcmUf2f3DN4etI8KJYFdaLnE@ifi.uio.no>
	 <4749C15C.6020805@shaw.ca>  <200711252301.34503.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 16:59:06 +0800
Message-Id: <1196153946.5385.4.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-26 at 04:01 +0800, Andrey Borzenkov wrote:
> On Sunday 25 November 2007, Robert Hancock wrote:
> > Andrey Borzenkov wrote:
> > > I have no COM port on notebook (without port replicator which I do not have)
> > > so COM is disabled in BIOS. No ttyS* is detected during boot (and no device
> > > created) but I just noticed that serial modules are still loaded. Well, this
> > > partially defeats the purpose of disabling COM port - the intention was to
> > > free resources by *not* loading unneeded modules ...
> > > 
> > > This may have something to do with (ACPI) PnP which apparently believes COM is alive.
> > > Notebook is Toshiba Portege 4000.
> > 
> > Probably a BIOS bug. It still lists the port in PnP data even though the 
> > hardware is disabled, so the kernel still tries to load the serial 
> > driver for it, which finds there's no port there.
> > 
> 
> Here is what we get from _STA:
> 
> [ 1689.988245] HID=PNP0501 flags=0d
> 
> If I read specs correctly, if bit 1 is cleared it means, device is not able
> to access its hardware resources, so it makes no sense to even try to
> load driver for it.
> 
> And of course it makes PnP output completely bogus:
> 
> 00:09 PNP0501 16550A-compatible serial port
>     state = active
>     allocated resources:
>         io 0x3f8-0x3ff
>         irq 5
>  
> So two questions:
> 
> 1. why device got enabled when ACPI explicitly stated it cannot be?
> 2. can we get information about _STA result in user space so we do not try
> to autoload driver for device that can't work?
0xd means present, disabled. A disabled PNP device can be enabled, ACPI
doesn't say it can't be. When the driver is loaded, it will enabled the
device. If BIOS wants to disable the device, it should make the device
non-present.

Thanks,
Shaohua
