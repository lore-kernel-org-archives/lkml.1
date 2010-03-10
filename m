Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab0CJFvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:51:08 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34008 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab0CJFvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:51:05 -0500
Date: Wed, 10 Mar 2010 14:50:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Simmons <jsimmons@infradead.org>,
       Luca Tettamanti <kronos.it@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [Q] How to tell we're using the KMS (during suspend/resume) outside the graphics driver
Message-ID: <20100310055013.GC19518@linux-sh.org>
References: <201003062236.09801.rjw@sisk.pl> <201003091234.59598.rjw@sisk.pl> <alpine.LFD.2.00.1003091613390.30952@casper.infradead.org> <201003092208.28175.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003092208.28175.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 10:08:28PM +0100, Rafael J. Wysocki wrote:
> On Tuesday 09 March 2010, James Simmons wrote:
> > 
> > > > > Second, in the KMS case, we'd be able to skip the kernel VT switch, because
> > > > > the KMS driver uses its own framebuffer anyway.
> > > > >
> > > > > So, is there any reasonable way to check that from the outside of the graphics
> > > > > driver?  It should be general enough to cover the cases when there are two
> > > > > graphics adapters with different drivers in the system and so forth.
> > > > 
> > > > Inside the kernel? If you have a struct pci_dev you can get the
> > > > associated struct drm_device with pci_get_drvdata and then check the
> > > > KMS feature: drm_core_check_feature(dev, DRIVER_MODESET).
> > > 
> > > Yeah, I know that.
> > > 
> > > > I'm note sure how to check that a device is graphic card though :|
> > > 
> > > Well, that's the "outside of the graphics driver" part of my question. :-)
> > 
> > if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
> > 	....
> 
> I'm not sure if searching through all PCI devices really is an option.
> 
Why not? The VGA arbitration code tracks a list of VGA class devices, so
could easily be queried. It looks like it might need a bit more work for
PCI hotplug, but it should already have all of the infrastructure you
need for getting at the pdev for the suspend/resume case.
