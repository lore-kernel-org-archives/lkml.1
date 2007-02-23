Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbXBWOtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbXBWOtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932447AbXBWOtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:49:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932442AbXBWOte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:49:34 -0500
Date: Fri, 23 Feb 2007 15:53:06 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI driver support for pata
Message-ID: <20070223155306.0e8aeee5@lxorguk.ukuu.org.uk>
In-Reply-To: <45DEFC48.8060802@shaw.ca>
References: <fa.IjFXvdcBtWXV65pRZipPd0NVTOA@ifi.uio.no>
	<45DD2E12.6000705@shaw.ca>
	<45DD3F20.7050907@pobox.com>
	<20070222142439.50cff3e9@lxorguk.ukuu.org.uk>
	<45DDCEC4.7050208@garzik.org>
	<20070222182939.56d43a68@lxorguk.ukuu.org.uk>
	<45DE3207.6020707@shaw.ca>
	<20070223125027.3f0a7f14@lxorguk.ukuu.org.uk>
	<45DEFC48.8060802@shaw.ca>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Unfortunately, link order appears to have no effect when the drivers in 
> question are built modular, as appears to be the typical case, unlike 
> old IDE where they were generally built in because of all the other 
> busted behavior if you built the drivers as modules. This means that 
> userspace tools like mkinitrd, udev, etc. will need to be taught to try 
> to load drivers in this order, and not to try to use pata_acpi on an 

They already have to do this because of the sata_nv module for one
example where ordering matters. So it's already the case, and it has to
be dealt with run time because the resolution is dynamic and depends upon
user configurable boot settings.

> Plus there's controller hotplug - if multiple loaded drivers are listed 
> as being able to drive a piece of hardware, does anything define which 
> driver will get first dibs on attaching to the device when it's 
> hotplugged? I don't know how this ordering will be enforced in that case.

That feature is lacking in the PCI layer at the moment which is
problematic. When the PCI layer develops this feature I'll make use of
it. In the mean time send patches to Greg KH for that if you want to hack
on it.

Alan
