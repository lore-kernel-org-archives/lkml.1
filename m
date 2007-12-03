Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbXLCPx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbXLCPx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbXLCPxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:53:20 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:31255 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbXLCPxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:53:19 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: trenn@suse.de
Subject: Re: [PATCH] Declare PNP option parsing functions as __init
Date: Mon, 3 Dec 2007 08:52:36 -0700
User-Agent: KMail/1.9.6
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, "Li, Shaohua" <shaohua.li@intel.com>
References: <1196442277.23251.318.camel@queen.suse.de> <200711301652.42110.bjorn.helgaas@hp.com> <1196682781.23251.349.camel@queen.suse.de>
In-Reply-To: <1196682781.23251.349.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712030852.36945.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 December 2007 04:53:01 am Thomas Renninger wrote:
> On Fri, 2007-11-30 at 16:52 -0700, Bjorn Helgaas wrote:
> > On Friday 30 November 2007 04:37:26 pm Rene Herman wrote:
> > > On 30-11-07 18:04, Thomas Renninger wrote:
> > > > If I have not overseen something, it should be rather obvious that those
> > > > can all be declared __init...
> > > > ---------------
> > > > 
> > > > Declare PNP option parsing functions as __init
> > > > 
> > > > There are three kind of parse functions provided by PNP acpi/bios:
> > > >  - get current resources
> > > >  - set resources
> > > >  - get possible resources
> > > > The first two may be needed later at runtime.
> > > > The possible resource settings should never change dynamically.
> > > > And even if this would make any sense (I doubt it), the current implementation
> > > > only parses possible resource settings at early init time:
> > > >   -> declare all the option parsing __init
> > > > 
> > > > Signed-off-by: Thomas Renninger <trenn@suse.de>
> > > 
> > > Yes. Obviousness aside,
> > > 
> > > (0) pnpacpi_add_device                          is only caller of
> > > ...
> > 
> > I agree this is probably safe in the current implementation.
> > 
> > However, I think the current implementation is just broken because
> > we can't really handle hotplug of ACPI devices.  Specifically, I think
> > the first TBD in acpi_bus_check_device() should be fleshed out so it
> > does something like pnpacpi_add_device().
> > 
> > So my dissenting opinion is that this patch would just get reverted
> > soon anyway when somebody finishes implementing ACPI hotplug, and
> > therefore it's not worth doing.
> 
> Ok, this all applies to the ACPI parts, but for pnpbios it probably
> makes sense to only evaluate possible resources only once at boot time?

There are PNPBIOS functions that are related to hotplug (for docking
stations and the like), but it doesn't look like we ever use them.
There's not much use in implementing PNPBIOS hotplug now, so I think
you're right that we could make PNPBIOS a boot-time only thing.

Bjorn
