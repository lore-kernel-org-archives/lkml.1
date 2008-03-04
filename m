Return-Path: <linux-kernel-owner+w=401wt.eu-S933388AbYCDTxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbYCDTxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbYCDTwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:52:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:39180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758635AbYCDTwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:52:47 -0500
Date: Tue, 4 Mar 2008 11:30:36 -0800
From: Greg KH <gregkh@suse.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
       warthog19@eaglescrag.net, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080304193036.GB5534@suse.de>
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080301144307.GD24386@parisc-linux.org> <20080304054927.GA15566@suse.de> <200803041018.29035.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803041018.29035.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 10:18:28AM -0800, Jesse Barnes wrote:
> On Monday, March 03, 2008 9:49 pm Greg KH wrote:
> > On Sat, Mar 01, 2008 at 07:43:07AM -0700, Matthew Wilcox wrote:
> > > On Fri, Feb 29, 2008 at 09:25:42PM -0800, Greg KH wrote:
> > > > What is the guarantee that the names of these slots are correct and do
> > > > not happen to be the same as the hotpluggable ones?
> > >
> > > That would be a bug -- and yes, bugs happen, and we have to deal with
> > > them.
> >
> > My main concern is that BIOS vendors will not fix these bugs, as no
> > other OS cares/does this kind of thing today.  The ammount of bad
> > information out there might be quite large, and I think this was
> > confirmed by some initial testing of IBM systems, right?
> 
> Yeah, but there's a flip side to this too:  if no one uses the data, no one 
> will complain when it's wrong.  If Linux starts making it easy to see this 
> stuff, there's a chance system vendors will start taking an extra 5 min. 
> before shipment to make sure that the BIOS info is up to date...
> 
> OTOH, I'm not sure which is worse, bad data or no data.

bad data is worse.

And then there's the machines with duplicate slot names, how does this
code handle PCI slots with that?  I think some of the IBM machines had
non-hotplug slots named the same as the hotplug slots, right?

This stuff needs a _lot_ of testing on a lot of different machines, and
a sane way to fall-back if there are errors to ensure that working
machines don't break.

And then there's the issue with userspace programs only expecting
hotplugable slots in the slots/ directory...

thanks,

greg k-h
