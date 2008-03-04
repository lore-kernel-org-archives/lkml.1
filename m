Return-Path: <linux-kernel-owner+w=401wt.eu-S933765AbYCDUPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765AbYCDUPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYCDUPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:15:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:50013 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760269AbYCDUPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:15:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,444,1199692800"; 
   d="scan'208";a="214820347"
Date: Tue, 4 Mar 2008 12:12:35 -0800
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Alex Chiang <achiang@hp.com>, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080304121235.468756d6@appleyard>
In-Reply-To: <20080304193036.GB5534@suse.de>
References: <20080229002341.GA21420@ldl.fc.hp.com>
	<20080301144307.GD24386@parisc-linux.org>
	<20080304054927.GA15566@suse.de>
	<200803041018.29035.jbarnes@virtuousgeek.org>
	<20080304193036.GB5534@suse.de>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 11:30:36 -0800
Greg KH <gregkh@suse.de> wrote:

> On Tue, Mar 04, 2008 at 10:18:28AM -0800, Jesse Barnes wrote:
> > On Monday, March 03, 2008 9:49 pm Greg KH wrote:
> > > On Sat, Mar 01, 2008 at 07:43:07AM -0700, Matthew Wilcox wrote:
> > > > On Fri, Feb 29, 2008 at 09:25:42PM -0800, Greg KH wrote:
> > > > > What is the guarantee that the names of these slots are
> > > > > correct and do not happen to be the same as the hotpluggable
> > > > > ones?
> > > >
> > > > That would be a bug -- and yes, bugs happen, and we have to
> > > > deal with them.
> > >
> > > My main concern is that BIOS vendors will not fix these bugs, as
> > > no other OS cares/does this kind of thing today.  The ammount of
> > > bad information out there might be quite large, and I think this
> > > was confirmed by some initial testing of IBM systems, right?
> > 
> > Yeah, but there's a flip side to this too:  if no one uses the
> > data, no one will complain when it's wrong.  If Linux starts making
> > it easy to see this stuff, there's a chance system vendors will
> > start taking an extra 5 min. before shipment to make sure that the
> > BIOS info is up to date...
> > 
> > OTOH, I'm not sure which is worse, bad data or no data.
> 
> bad data is worse.
> 
> And then there's the machines with duplicate slot names, how does this
> code handle PCI slots with that?  I think some of the IBM machines had
> non-hotplug slots named the same as the hotplug slots, right?
> 
> This stuff needs a _lot_ of testing on a lot of different machines,
> and a sane way to fall-back if there are errors to ensure that working
> machines don't break.
> 
> And then there's the issue with userspace programs only expecting
> hotplugable slots in the slots/ directory...
> 
> thanks,
> 
> greg k-h
> 

I too worry about interaction with other vendor's machines, so maybe we
should make it easier to test by putting this series into linux-next?

