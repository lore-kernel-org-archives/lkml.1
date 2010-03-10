Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab0CJKyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:54:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:23030 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab0CJKyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:54:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qrAT1sk0GANJG99TnracgZw2SJVXfRj55d1RplZlLgqDUEO6SKdl5ThaluhstpVepW
         QF5IXRjnSSo78TkMXd9y6vsNI0aeMZAoNSRlum6SvBmxq+JdjJ82drmy1dXvFnjgKweL
         +QeqzKMqrTK/k6zORPLWls5COYtk1QQqz5MF8=
MIME-Version: 1.0
In-Reply-To: <20100310055013.GC19518@linux-sh.org>
References: <201003062236.09801.rjw@sisk.pl> <201003091234.59598.rjw@sisk.pl>
	 <alpine.LFD.2.00.1003091613390.30952@casper.infradead.org>
	 <201003092208.28175.rjw@sisk.pl> <20100310055013.GC19518@linux-sh.org>
Date: Wed, 10 Mar 2010 12:54:46 +0200
Message-ID: <548cdfc21003100254t5c94aca5u5cf1e9eb29215325@mail.gmail.com>
Subject: Re: [Q] How to tell we're using the KMS (during suspend/resume) 
	outside the graphics driver
From: Pauli Nieminen <suokkos@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Luca Tettamanti <kronos.it@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 7:50 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Tue, Mar 09, 2010 at 10:08:28PM +0100, Rafael J. Wysocki wrote:
>> On Tuesday 09 March 2010, James Simmons wrote:
>> >
>> > > > > Second, in the KMS case, we'd be able to skip the kernel VT switch, because
>> > > > > the KMS driver uses its own framebuffer anyway.
>> > > > >
>> > > > > So, is there any reasonable way to check that from the outside of the graphics
>> > > > > driver?  It should be general enough to cover the cases when there are two
>> > > > > graphics adapters with different drivers in the system and so forth.
>> > > >
>> > > > Inside the kernel? If you have a struct pci_dev you can get the
>> > > > associated struct drm_device with pci_get_drvdata and then check the
>> > > > KMS feature: drm_core_check_feature(dev, DRIVER_MODESET).
>> > >
>> > > Yeah, I know that.
>> > >
>> > > > I'm note sure how to check that a device is graphic card though :|
>> > >
>> > > Well, that's the "outside of the graphics driver" part of my question. :-)
>> >
>> > if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
>> >     ....
>>
>> I'm not sure if searching through all PCI devices really is an option.
>>
> Why not? The VGA arbitration code tracks a list of VGA class devices, so
> could easily be queried. It looks like it might need a bit more work for
> PCI hotplug, but it should already have all of the infrastructure you
> need for getting at the pdev for the suspend/resume case.
>
>

It would be better to add interface that can be used to query if a
graphic device supports KMS. This should support multi-gpu setups at
least. I don't think anything prevents running mixed system where
secundary gpu is driven by UMS code in X.

Are you sure that all vga class devices have private device data that
matches private drm_device structure?
