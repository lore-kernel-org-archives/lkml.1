Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbXLAABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbXLAABU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 19:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbXLAAAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 19:00:55 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:9542 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758563AbXLAAAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 19:00:54 -0500
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2007 19:00:54 EST
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] Declare PNP option parsing functions as __init
Date: Fri, 30 Nov 2007 16:52:41 -0700
User-Agent: KMail/1.9.6
Cc: trenn@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, "Li, Shaohua" <shaohua.li@intel.com>
References: <1196442277.23251.318.camel@queen.suse.de> <47509EB6.20300@keyaccess.nl>
In-Reply-To: <47509EB6.20300@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711301652.42110.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2007 04:37:26 pm Rene Herman wrote:
> On 30-11-07 18:04, Thomas Renninger wrote:
> > If I have not overseen something, it should be rather obvious that those
> > can all be declared __init...
> > ---------------
> > 
> > Declare PNP option parsing functions as __init
> > 
> > There are three kind of parse functions provided by PNP acpi/bios:
> >  - get current resources
> >  - set resources
> >  - get possible resources
> > The first two may be needed later at runtime.
> > The possible resource settings should never change dynamically.
> > And even if this would make any sense (I doubt it), the current implementation
> > only parses possible resource settings at early init time:
> >   -> declare all the option parsing __init
> > 
> > Signed-off-by: Thomas Renninger <trenn@suse.de>
> 
> Yes. Obviousness aside,
> 
> (0) pnpacpi_add_device                          is only caller of
> ...

I agree this is probably safe in the current implementation.

However, I think the current implementation is just broken because
we can't really handle hotplug of ACPI devices.  Specifically, I think
the first TBD in acpi_bus_check_device() should be fleshed out so it
does something like pnpacpi_add_device().

So my dissenting opinion is that this patch would just get reverted
soon anyway when somebody finishes implementing ACPI hotplug, and
therefore it's not worth doing.

Bjorn
