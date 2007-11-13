Return-Path: <linux-kernel-owner+w=401wt.eu-S1761961AbXKMXCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761961AbXKMXCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbXKMXCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:02:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:47321 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbXKMXCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:02:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,412,1188802800"; 
   d="scan'208";a="317811155"
Date: Tue, 13 Nov 2007 14:59:36 -0800
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Alex Chiang <achiang@hp.com>, gregkh@suse.de, lenb@kernel.org,
       matthew@wil.cx, rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-Id: <20071113145936.7e1c58fb.kristen.c.accardi@intel.com>
In-Reply-To: <20071113202632.GA3227@kroah.com>
References: <20071113000853.GA13341@ldl.fc.hp.com>
	<20071113170129.GA20185@kroah.com>
	<20071113202154.GA22812@ldl.fc.hp.com>
	<20071113202632.GA3227@kroah.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 12:26:32 -0800
Greg KH <greg@kroah.com> wrote:

> On Tue, Nov 13, 2007 at 01:21:54PM -0700, Alex Chiang wrote:
> > * Greg KH <greg@kroah.com>:
> > > On Mon, Nov 12, 2007 at 05:08:53PM -0700, Alex Chiang wrote:
> > > > 
> > > > Recently, Matthew Wilcox sent out the following mail about
> > > > PCI slots:
> > > > 
> > > >   http://marc.info/?l=linux-pci&m=119432330418980&w=2
> > > > 
> > > > The following patch series is a rough first cut at
> > > > implementing the ideas he outlined, namely, that PCI slots
> > > > are physical objects that we care about, independent of their
> > > > hotplug capabilities.
> > > 
> > > Also, some companies already provide userspace tools to get all
> > > of this information about the different slots in a system and
> > > what is where, from userspace, no kernel changes are needed.
> > > So, why add all this extra complexity to the kernel if it is
> > > not needed?
> > 
> > On HP ia64 systems, that information is locked away in ACPI, and
> > there's no easy way to get at it. Alex Williamson tried providing
> > a generic dev_acpi driver, so that userspace could do whatever
> > they wanted to with the information:
> > 
> >   http://lkml.org/lkml/2004/8/3/106
> > 
> > And that effort kinda died. I'm of mixed feelings on that driver,
> > since it would be really nice to get unfettered access to the
> > ACPI namespace, but it's pretty dangerous, since any interesting
> > thing you might want to do is actually a method (aka, it calls
> > into firmware) and who knows what side effects there might be.
> > 
> > So from my point of view, if ia64 customers want to know about
> > the slots they have in their systems, we're gonna have to do
> > something kernel-intrusive anyhow.
> 
> Doesn't /sys/firmware/acpi give you raw access to the correct tables
> already?
> 
> And isn't there some other tool that dumps the raw ACPI tables?  I
> thought the acpi developers used it all the time when debugging things
> with users.
> 
> thanks,
> 
> greg k-h
> 

There are - people should take a look at the Intel Linux Firmware Kit
for an example of how to parse ACPI tables in userspace - the code
is also GPL'd, so you are free to use it in another GPL application.

http://www.linuxfirmwarekit.org/download.php#source

In many DSDTs I've seen, _SUN is hardcoded anyway and can be found
by reading the DSDT from userspace.  This is what the firmwarekit
does to check for duplicate _SUN in one of it's tests.

Kristen

