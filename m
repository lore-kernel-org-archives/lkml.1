Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbZCSWz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbZCSWz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbZCSWzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:55:14 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:47229 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbZCSWzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:55:13 -0400
Date: Thu, 19 Mar 2009 15:55:10 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Alex Chiang <achiang@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/12] PCI: Introduce /sys/bus/pci/rescan
In-Reply-To: <20090319171107.GG8074@ldl.fc.hp.com>
Message-ID: <Pine.LNX.4.58.0903191547130.28292@shell2.speakeasy.net>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318224001.887.63554.stgit@bob.kio>
 <20090319023453.7467644a.akpm@linux-foundation.org> <20090319171107.GG8074@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009, Alex Chiang wrote:
> * Andrew Morton <akpm@linux-foundation.org>:
> > > +
> > > +struct bus_attribute pci_bus_attrs[] = {
> > > +	__ATTR(rescan, S_IWUSR, NULL, bus_rescan_store),
> > > +	__ATTR_NULL
> > > +};
> > > +#endif
> >
> > Why CONFIG_HOTPLUG rather than CONFIG_HOTPLUG_PCI (or similar)?
>
> I first started out with CONFIG_HOTPLUG_PCI but then all that
> stuff got compiled out, and I couldn't figure out why at the
> time.

HOTPLUG_PCI is a subset of HOTPLUG.  It gives you support for actual
hotplug hardware.  The rescan/remove functions don't do anything to hotplug
hardware and don't use any code from the pci hotplug core (which is
designed to support hotplug hardware).  Rescan and remove just need the
ability to unbind a driver from device, delete a device and create a new
device.  Which HOTPLUG gives us.

So, we use HOTPLUG because that's all we need.  The idea is to make the
sysfs interface for PCI have the most features it can support.

If we wanted to make the interface not have remove/rescan unless needed,
then using HOTPLUG_PCI wouldn't make much sense.  It would be better to
have a new option "PCI remove/rescan sysfs interface" or something that
turned it on.  But it isn't much code, so I don't think it's necessary to
do that.
