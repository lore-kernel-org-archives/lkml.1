Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbXKMUad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbXKMUad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbXKMUaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:30:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60681 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbXKMUaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:30:24 -0500
Date: Tue, 13 Nov 2007 12:26:32 -0800
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, matthew@wil.cx, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113202632.GA3227@kroah.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113202154.GA22812@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113202154.GA22812@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 01:21:54PM -0700, Alex Chiang wrote:
> * Greg KH <greg@kroah.com>:
> > On Mon, Nov 12, 2007 at 05:08:53PM -0700, Alex Chiang wrote:
> > > 
> > > Recently, Matthew Wilcox sent out the following mail about
> > > PCI slots:
> > > 
> > >   http://marc.info/?l=linux-pci&m=119432330418980&w=2
> > > 
> > > The following patch series is a rough first cut at
> > > implementing the ideas he outlined, namely, that PCI slots
> > > are physical objects that we care about, independent of their
> > > hotplug capabilities.
> > 
> > Also, some companies already provide userspace tools to get all
> > of this information about the different slots in a system and
> > what is where, from userspace, no kernel changes are needed.
> > So, why add all this extra complexity to the kernel if it is
> > not needed?
> 
> On HP ia64 systems, that information is locked away in ACPI, and
> there's no easy way to get at it. Alex Williamson tried providing
> a generic dev_acpi driver, so that userspace could do whatever
> they wanted to with the information:
> 
>   http://lkml.org/lkml/2004/8/3/106
> 
> And that effort kinda died. I'm of mixed feelings on that driver,
> since it would be really nice to get unfettered access to the
> ACPI namespace, but it's pretty dangerous, since any interesting
> thing you might want to do is actually a method (aka, it calls
> into firmware) and who knows what side effects there might be.
> 
> So from my point of view, if ia64 customers want to know about
> the slots they have in their systems, we're gonna have to do
> something kernel-intrusive anyhow.

Doesn't /sys/firmware/acpi give you raw access to the correct tables
already?

And isn't there some other tool that dumps the raw ACPI tables?  I
thought the acpi developers used it all the time when debugging things
with users.

thanks,

greg k-h
