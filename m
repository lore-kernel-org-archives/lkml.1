Return-Path: <linux-kernel-owner+w=401wt.eu-S1760313AbZCSXWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313AbZCSXWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZCSXV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:21:58 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:43680 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbZCSXV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:21:57 -0400
Date: Thu, 19 Mar 2009 17:21:54 -0600
From: Alex Chiang <achiang@hp.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/12] PCI: Introduce /sys/bus/pci/rescan
Message-ID: <20090319232154.GA30769@ldl.fc.hp.com>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318224001.887.63554.stgit@bob.kio> <20090319023453.7467644a.akpm@linux-foundation.org> <20090319171107.GG8074@ldl.fc.hp.com> <Pine.LNX.4.58.0903191547130.28292@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0903191547130.28292@shell2.speakeasy.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Trent Piepho <xyzzy@speakeasy.org>:
> On Thu, 19 Mar 2009, Alex Chiang wrote:
> > * Andrew Morton <akpm@linux-foundation.org>:
> > > > + +struct bus_attribute pci_bus_attrs[] = { +
> > > > __ATTR(rescan, S_IWUSR, NULL, bus_rescan_store), +
> > > > __ATTR_NULL +}; +#endif
> > >
> > > Why CONFIG_HOTPLUG rather than CONFIG_HOTPLUG_PCI (or
> > > similar)?
> >
> > I first started out with CONFIG_HOTPLUG_PCI but then all that
> > stuff got compiled out, and I couldn't figure out why at the
> > time.
>
> HOTPLUG_PCI is a subset of HOTPLUG.  It gives you support for
> actual hotplug hardware.  The rescan/remove functions don't do
> anything to hotplug hardware and don't use any code from the
> pci hotplug core (which is designed to support hotplug
> hardware).  Rescan and remove just need the ability to unbind a
> driver from device, delete a device and create a new device.
> Which HOTPLUG gives us.
> 
> So, we use HOTPLUG because that's all we need.  The idea is to
> make the sysfs interface for PCI have the most features it can
> support.
> 
> If we wanted to make the interface not have remove/rescan
> unless needed, then using HOTPLUG_PCI wouldn't make much sense.
> It would be better to have a new option "PCI remove/rescan
> sysfs interface" or something that turned it on.  But it isn't
> much code, so I don't think it's necessary to do that.
 
Well, I don't know what I did wrong last time, but I no longer
have technical difficulty putting it under CONFIG_HOTPLUG_PCI.

Looking at Documentation/PCI/pci.txt, and the various archs, it
seems they all assume CONFIG_HOTPLUG means PCI.

This could be cleaned up, but it's certainly non-trivial, and a
bit more than I'd want to bite off for this particular patchset.

Plus, Trent is right. Looks like we use HOTPLUG_PCI to really
mean physically supported hotplug, not the logical stuff that
this patchset is adding.

Thanks.

/ac

