Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZBCNIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZBCNIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZBCNIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:08:15 -0500
Received: from ns2.suse.de ([195.135.220.15]:48986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbZBCNIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:08:14 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: [PATCH 1/2] RFC: ACPI: Interface for ACPI drivers to place quirk code which gets executed early
Date: Tue, 3 Feb 2009 14:08:10 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.13-HEAD_20090130075504_71baee03-default; KDE/4.1.3; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>, Hans de Goede <hdegoede@redhat.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
References: <20090125210520.GA12963@dreamland.darkstar.lan> <200902021822.11906.trenn@suse.de> <20090202202246.GA9023@dreamland.darkstar.lan>
In-Reply-To: <20090202202246.GA9023@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031408.12237.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009 21:22:46 Luca Tettamanti wrote:
> Il Mon, Feb 02, 2009 at 06:22:10PM +0100, Thomas Renninger ha scritto:
> > These two patches are tested on a ASUS machine and worked as expected,
> > but probably may still need some cleanup.
>
> I'd keep the DMI+HID approach since it's more flexible:
> - (AFAICS) Thinkpads have different methods for hwmon depending on the
>   model and no fixed HID
> - With DMI it would be possible to include ASUS motherboards (ATK w/
>   hwmon) but exclude ASUS laptops (ATK w/o hwmon).
I thought the ATK01[01]0 devices are ASUS specific.
I now found an ATK0100 (not the ATK0110 this is about) on a Sony and a
Samsung.
I still wonder why you want to restrict the check to ASUS.
Your ATK0110 driver would also load on any other machine which has such
a device. And why shouldn't a Samsung/Sony/... machine with a ATK0110
device not access the hwmon sensor through it?
Should we already look a bit deeper into the ATK0110 device in the quirk
to make sure it provides thermal, fan or other hwmon device accessing
functionality?

> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index c54d7b6..1c25747 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/kthread.h>
> >
> >  #include <acpi/acpi_drivers.h>
> > +#include "acpi.h"
> >
> >  #define _COMPONENT		ACPI_BUS_COMPONENT
> >  ACPI_MODULE_NAME("scan");
> > @@ -1562,6 +1563,8 @@ static int __init acpi_scan_init(void)
> >
> >  	if (result)
> >  		acpi_device_unregister(acpi_root, ACPI_BUS_REMOVAL_NORMAL);
> > +	else
> > +		acpi_device_quirks();
>
> Hum, it's not immediatly clear why you put that call in the else
> branch. Maybe put:
>
> if (!result)
>         acpi_device_quirks();
>
> before the cleanup?
Yes that looks ugly, yours is nicer...

Also thanks for the "auto not handled properly" hint, I forgot
that part.

Thanks,

    Thomas
