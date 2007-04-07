Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbXDGFKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbXDGFKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 01:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXDGFKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 01:10:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:41345 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbXDGFKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 01:10:35 -0400
Date: Fri, 6 Apr 2007 22:01:31 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: Zhang Rui <rui.zhang@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       lenb@kernel.org, "linux-acpi@vger" <linux-acpi@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
Message-ID: <20070407050131.GB25511@kroah.com>
References: <200704031741.42273.david-b@pacbell.net> <200704050358.43689.david-b@pacbell.net> <1175852213.2650.4.camel@localhost.localdomain> <200704060843.30723.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704060843.30723.david-b@pacbell.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 08:43:30AM -0700, David Brownell wrote:
> > > If this patch starts to get deployed, I expect other people will find
> > > a few other curiousities ... and likely some things to be fixed.
> > 
> > > The /sys/devices/acpi_system:00/ tree is kind of new.  I suspect one
> > > way it could be more informative is to set up cross-links in sysfs
> > > between the ACPI devices and the "real" device nodes ... e.g. on the
> > > system I'm using right now .../device:00/PNP0A03:00/device:15/PNP0B00:00
> > > could have a link pointing to /sys/devices/pnp0/00:06 ... and that PNP
> > > node in turn could have an "acpi" link pointing back to the ACPI thing.
> > > 
> > > Such cross-links would let people see those relationships, and observe
> > > which links are missing or otherwise strange.  Fixing the bugs would
> > > seem unlikely until those things become visible.
> >
> > Sounds nice.
> > The patch below should make sense.
> 
> Yeah, that's the idea.  Let's see if it's any good.  :)
> 
> I'd just call it "acpi_node" not "ACPI_node" (NO POINT IN SHOUTING),
> and might not even use the "_node" suffix.

Yes, please don't shout :)

> I cc'd Greg, who's our resident (or is that itinerant?) sysfs guru,
> in case he has comments on this issue.

Are you _sure_ you have a 1-to-1 relationship here?  No multiple devices
pointing to the same acpi node?  Or the other way around?  If so, you
are going to have to change the name to be something more unique.

Or how about "firmware" instead of "acpi" to be able to have the
userspace tools work on any type of firmware that provides this, like
openfirmware?

thanks,

greg k-h
