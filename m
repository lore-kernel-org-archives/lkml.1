Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYLESiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYLESiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYLESiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:38:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52024 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbYLESh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:37:59 -0500
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
In-Reply-To: <49394C1B.2010001@us.ibm.com>
References: <1228394671.3732.77.camel@blaa> <49385DB7.4060306@gmail.com>
	 <4938EE0B.8020501@msgid.tls.msk.ru>  <493929D2.4070900@gmail.com>
	 <1228488921.3858.25.camel@blaa>  <49394C1B.2010001@us.ibm.com>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 18:36:29 +0000
Message-Id: <1228502189.3858.57.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 09:43 -0600, Anthony Liguori wrote:
> Mark McLoughlin wrote:
> > On Fri, 2008-12-05 at 14:17 +0100, Jiri Slaby wrote:
> >   
> > +static void virtio_pci_release_dev(struct device *dev)
> > +{
> > +}
> > +
> >  /* A PCI device has it's own struct device and so does a virtio device so
> >   * we create a place for the virtio devices to show up in sysfs.  I think it
> >   * would make more sense for virtio to not insist on having it's own device. */
> >  static struct device virtio_pci_root = {
> >  	.parent		= NULL,
> >  	.bus_id		= "virtio-pci",
> > +	.release	= virtio_pci_release_dev,
> >  };
> >   
> 
> Actually, we should be able to delete this virtio_pci_root entirely.  
> The device is a dummy one anyway.

Care to recall why it was added initially and what's changed?

One side effect of removing it is that each device appears on its own
in /sys/devices rather than neatly under /sys/devices/virtio-pci.

(And one side effect of that is that the aforementioned Fedora mkinitrd
kludge stops working which would make me sad :-)

Cheers,
mark.

