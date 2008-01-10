Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbYAJQG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbYAJQG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYAJQGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:06:53 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:20399 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbYAJQGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:06:51 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: Linux 2.6.23.12
Date: Thu, 10 Jan 2008 09:06:47 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       Zhao Yakui <yakui.zhao@intel.com>, Li Shaohua <shaohua.li@intel.com>,
       Thomas Renninger <trenn@suse.de>, Adam Belay <ambx1@neo.rr.com>,
       Len Brown <lenb@kernel.org>
References: <20071218224559.GA12696@kroah.com> <200801021342.23763.bjorn.helgaas@hp.com> <20080110034952.GC20448@suse.de>
In-Reply-To: <20080110034952.GC20448@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801100906.48288.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008 08:49:52 pm Greg KH wrote:
> On Wed, Jan 02, 2008 at 01:42:23PM -0700, Bjorn Helgaas wrote:
> > The patch below was put in 2.6.23.12 as a fix for
> > http://bugzilla.kernel.org/show_bug.cgi?id=9514.  It apparently
> > does make 9514 go away, but only by coincidence.  There are a
> > couple other ideas about fixing 9514.  My proposed patch is
> > attached in the bugzilla.
> > 
> > The .12 patch reduces the number of resources we reserve from
> > 24 to 8 ioport regions and from 12 to 4 mmio regions per PNP device.
> > It also removes a warning about regions we ignore.
> 
> That patch was merely a revert of a prior patch, it did not "do"
> anything new at all :)
> 
> > Obviously, we want to reserve ALL the regions for PNP devices,
> > and Thomas is working on a patch for that (which I hope will be
> > ready for 2.6.25).  But in the meantime, the .12 patch makes it
> > more likely that we will have resource conflicts with PNP devices.
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=9630 appears to be
> > such a conflict.
> > 
> > I think the patch below should be removed from the stable series.
> 
> What do you mean "removed"?  It was a revert of a prior patch, as this
> patch was reported to cause real problems.
> 
> Do you want me to add it back, and then add another patch?  If so, can
> you please send the requested patches to stable@kernel.org so I can do
> it?

Stepping back, the biggest part of the problem is that I replaced the
ACPI motherboard driver, which reserved all resources, with the PNP
motherboard driver, which currently can reserve only a limited number
of resources, because I didn't realize that restriction.

So we've had a variety of problems, and we've tried to address them
with hacks like increasing the PNP limits.  I think we need to put
back the ACPI motherboard driver until we have dynamic PNP resources.
We will also need an it87 change to deal with
http://bugzilla.kernel.org/show_bug.cgi?id=9514.

I'll work these up and post them soon.

Bjorn
