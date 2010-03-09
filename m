Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0CIQQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:16:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:52577 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab0CIQQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:16:29 -0500
Date: Tue, 9 Mar 2010 16:16:24 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Luca Tettamanti <kronos.it@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [Q] How to tell we're using the KMS (during suspend/resume)
 outside the graphics driver
In-Reply-To: <201003091234.59598.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1003091613390.30952@casper.infradead.org>
References: <201003062236.09801.rjw@sisk.pl> <68676e01003090301s5bb40d4hac1224a9658339ac@mail.gmail.com> <201003091234.59598.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Second, in the KMS case, we'd be able to skip the kernel VT switch, because
> > > the KMS driver uses its own framebuffer anyway.
> > >
> > > So, is there any reasonable way to check that from the outside of the graphics
> > > driver?  It should be general enough to cover the cases when there are two
> > > graphics adapters with different drivers in the system and so forth.
> > 
> > Inside the kernel? If you have a struct pci_dev you can get the
> > associated struct drm_device with pci_get_drvdata and then check the
> > KMS feature: drm_core_check_feature(dev, DRIVER_MODESET).
> 
> Yeah, I know that.
> 
> > I'm note sure how to check that a device is graphic card though :|
> 
> Well, that's the "outside of the graphics driver" part of my question. :-)

if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
	....


