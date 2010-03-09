Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0CILcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 06:32:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40165 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab0CILcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:32:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: [Q] How to tell we're using the KMS (during suspend/resume) outside the graphics driver
Date: Tue, 9 Mar 2010 12:34:59 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
References: <201003062236.09801.rjw@sisk.pl> <68676e01003090301s5bb40d4hac1224a9658339ac@mail.gmail.com>
In-Reply-To: <68676e01003090301s5bb40d4hac1224a9658339ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003091234.59598.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 March 2010, Luca Tettamanti wrote:
> On Sat, Mar 6, 2010 at 10:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > For at least two reasons it would be beneficial for some code outisde the
> > graphics driver(s) to know if the KMS are used.
> >
> > First, in the non-KMS (ie. UMS) case we probably wouldn't want to call
> > acpi_video_resume(), because that has a potential to mess up with the GPU
> > (it actually is known to do that on at least one system).
> >
> > Second, in the KMS case, we'd be able to skip the kernel VT switch, because
> > the KMS driver uses its own framebuffer anyway.
> >
> > So, is there any reasonable way to check that from the outside of the graphics
> > driver?  It should be general enough to cover the cases when there are two
> > graphics adapters with different drivers in the system and so forth.
> 
> Inside the kernel? If you have a struct pci_dev you can get the
> associated struct drm_device with pci_get_drvdata and then check the
> KMS feature: drm_core_check_feature(dev, DRIVER_MODESET).

Yeah, I know that.

> I'm note sure how to check that a device is graphic card though :|

Well, that's the "outside of the graphics driver" part of my question. :-)

Rafael
