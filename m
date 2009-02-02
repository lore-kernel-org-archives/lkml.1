Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZBBUW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZBBUW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZBBUWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:22:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:56037 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbZBBUWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:22:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Obcoa/Ul2VJXg4zHuEjmPNSOYfSE3e62uUT14+ecOXjCi/8q+mV3SyYQaXrNPuSt7B
         fg6fOqiyJ9x301FBpX5fDf0+kogX0pU/fPmWCnjv1G7KnPgxNvqRWDhEsY2e44bsqJw2
         QGl7+b6dzfEceDHqqxfw9t1xXB46zba1Z1KNs=
Date: Mon, 2 Feb 2009 21:22:46 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Jean Delvare <khali@linux-fr.org>, Hans de Goede <hdegoede@redhat.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 1/2] RFC: ACPI: Interface for ACPI drivers to place
	quirk code which gets executed early
Message-ID: <20090202202246.GA9023@dreamland.darkstar.lan>
References: <20090125210520.GA12963@dreamland.darkstar.lan> <20090202101103.1208c035@hyperion.delvare> <68676e00902020338o7326ff7dx4efadf94ed534acf@mail.gmail.com> <200902021822.11906.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902021822.11906.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il Mon, Feb 02, 2009 at 06:22:10PM +0100, Thomas Renninger ha scritto: 
> These two patches are tested on a ASUS machine and worked as expected,
> but probably may still need some cleanup.

I'd keep the DMI+HID approach since it's more flexible:
- (AFAICS) Thinkpads have different methods for hwmon depending on the
  model and no fixed HID
- With DMI it would be possible to include ASUS motherboards (ATK w/
  hwmon) but exclude ASUS laptops (ATK w/o hwmon).

> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index c54d7b6..1c25747 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -10,6 +10,7 @@
>  #include <linux/kthread.h>
>  
>  #include <acpi/acpi_drivers.h>
> +#include "acpi.h"
>  
>  #define _COMPONENT		ACPI_BUS_COMPONENT
>  ACPI_MODULE_NAME("scan");
> @@ -1562,6 +1563,8 @@ static int __init acpi_scan_init(void)
>  
>  	if (result)
>  		acpi_device_unregister(acpi_root, ACPI_BUS_REMOVAL_NORMAL);
> +	else
> +		acpi_device_quirks();

Hum, it's not immediatly clear why you put that call in the else
branch. Maybe put:

if (!result)
        acpi_device_quirks();

before the cleanup?

Luca
-- 
"La mia teoria scientifica preferita e` quella secondo la quale gli 
 anelli di Saturno sarebbero interamente composti dai bagagli andati 
 persi nei viaggi aerei." -- Mark Russel
