Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXLBNfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXLBNfQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 08:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXLBNfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 08:35:03 -0500
Received: from ns2.suse.de ([195.135.220.15]:44393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbXLBNfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 08:35:01 -0500
Subject: Re: [PATCH] Declare PNP option parsing functions as __init
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, "Li, Shaohua" <shaohua.li@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <4750ABCB.6090705@keyaccess.nl>
References: <1196442277.23251.318.camel@queen.suse.de>
	 <47509EB6.20300@keyaccess.nl> <200711301652.42110.bjorn.helgaas@hp.com>
	 <4750ABCB.6090705@keyaccess.nl>
Content-Type: text/plain
Date: Sun, 02 Dec 2007 14:34:56 +0100
Message-Id: <1196602496.4049.51.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-01 at 01:33 +0100, Rene Herman wrote:
> On 01-12-07 00:52, Bjorn Helgaas wrote:
> 
> > On Friday 30 November 2007 04:37:26 pm Rene Herman wrote:
> >> On 30-11-07 18:04, Thomas Renninger wrote:
> >>> If I have not overseen something, it should be rather obvious that those
> >>> can all be declared __init...
> >>> ---------------
> >>>
> >>> Declare PNP option parsing functions as __init
> >>>
> >>> There are three kind of parse functions provided by PNP acpi/bios:
> >>>  - get current resources
> >>>  - set resources
> >>>  - get possible resources
> >>> The first two may be needed later at runtime.
> >>> The possible resource settings should never change dynamically.
> >>> And even if this would make any sense (I doubt it), the current implementation
> >>> only parses possible resource settings at early init time:
> >>>   -> declare all the option parsing __init
> >>>
> >>> Signed-off-by: Thomas Renninger <trenn@suse.de>
> >> Yes. Obviousness aside,
> >>
> >> (0) pnpacpi_add_device                          is only caller of
> >> ...
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
> <shrug>
> 
> The PnPBIOS bits should still be fine at least I guess. And, it would seem 
> this is rather essential to Thomas' efforts of making this stuff dynamic in 
> the first place anyway.
No it is not. It is just another optimization I saw while going through
these code parts...

   Thomas

