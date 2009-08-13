Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZHMMan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZHMMan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 08:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbZHMMam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 08:30:42 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54726 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbZHMMal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 08:30:41 -0400
Date: Thu, 13 Aug 2009 13:30:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC] usb: Add support for runtime power management
	of the hcd
Message-ID: <20090813123034.GA25770@srcf.ucam.org>
References: <200908081625.57333.rjw@sisk.pl> <20090813002925.GA2532@srcf.ucam.org> <20090813003544.GB2532@srcf.ucam.org> <200908131416.42189.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908131416.42189.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 02:16:41PM +0200, Oliver Neukum wrote:
> Am Donnerstag, 13. August 2009 02:35:44 schrieb Matthew Garrett:
> 
> > The power savings from this are measurable but not huge - it still seems
> 
> How large?

About 0.2W on an ich9 system.

> > like a decent optimisation. The main problem is that BIOS bugs on some
> > Dell laptops will kill USB if this is used, so we either default to off
> > or add some quirks to handle that case (I have some ideas in that
> > respect).
> 
> Your earlier failures don't look promising regarding BIOSes.
> What do you have in mind?

They range from pragmatic to ugly. We could blacklist all Dells, though 
I'm trying to find out if there's a BIOS date that guarantees the system 
is fixed. Alternatively, it's a single-line bug in the DSDT - we could 
implement some kind of fixup in the ACPI parsing code. I find the latter 
interesting but possibly too hideous to live :)

> > @@ -1968,6 +1972,9 @@ struct usb_hcd *usb_create_hcd (const struct
> > hc_driver *driver, INIT_WORK(&hcd->wakeup_work, hcd_resume_work);
> >  #endif
> >
> > +	pm_runtime_enable(dev);
> 
> So you don't get a reference from that?

No, but...

> > +	pm_runtime_get(dev);
> 
> What happens if you get a runtime suspend request in between? Is this a flaw
> of the API?

I suspect that just swapping the order of those two lines would be fine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
