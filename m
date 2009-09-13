Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZIMWwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZIMWwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 18:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZIMWwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 18:52:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50745 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbZIMWwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 18:52:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC][PATCH 3/4] PCI / ACPI PM: Platform support for PCI PME wake-up
Date: Mon, 14 Sep 2009 00:53:05 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Shaohua Li <shaohua.li@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <200909132320.05077.rjw@sisk.pl> <200909132324.03340.rjw@sisk.pl> <20090913222505.GC31175@srcf.ucam.org>
In-Reply-To: <20090913222505.GC31175@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909140053.05779.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 September 2009, Matthew Garrett wrote:
> On Sun, Sep 13, 2009 at 11:24:03PM +0200, Rafael J. Wysocki wrote:
> > +	} else if (!dev->wakeup.flags.run_wake) {
> > +		acpi_set_gpe_type(dev->wakeup.gpe_device,
> > +					dev->wakeup.gpe_number,
> > +					ACPI_GPE_TYPE_WAKE);
> 
> Is this going to work for cases where we have multiple devices attached 
> to the same GPE? The common one is EHCI, where both EHCI HCDs will be 
> one a single GPE. If we wake one, that'll then disable the GPE for the 
> other. Further wakeup events will then be lost.

You're right, I overlooked that.  Some kind of refcounting is needed here.

> > +	if (device->wakeup.flags.valid)
> > +		acpi_install_notify_handler(device->handle, ACPI_SYSTEM_NOTIFY,
> > +						pci_acpi_device_wakeup,
> > +						&dev->dev);
> > +
> 
> I think this will fail for the root bridge if acpiphp has already 
> grabbed it to check for hotplug events.

The root bridge is not a struct pci_dev and this is called only for these.

Thanks,
Rafael
