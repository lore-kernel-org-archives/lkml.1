Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbZDMSmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbZDMSmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZDMSmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:42:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:10817 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZDMSmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=l4dvImGNnJ8fvBg108YPWzBNdbVZI3lbP7fMTX5bkjO0AdSIc0Mx73nORIai65Fj2A
         SzPFlscwYmYZdVrUkgbQ4Ux7hOrkHxg1H8TEW9DMi/6LGtu7BGsDmamDaPcM2gsUYlVN
         NnwRlgpmJYqwpVQ3An1v3zFCTTnLjaCyWgybY=
Message-ID: <49E38779.9060705@tuffmail.co.uk>
Date: Mon, 13 Apr 2009 19:42:01 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: yakui_zhao <yakui.zhao@intel.com>, Zhang Rui <rui.zhang@intel.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [BISECTED] 20 ACPI interrupts per second on EEEPC 4G
References: <49DF6835.9040501@tuffmail.co.uk> <49DFE345.3010109@gmail.com> <49E05F83.2090500@tuffmail.co.uk> <49E20EBA.2090708@tuffmail.co.uk> <1239588248.5564.19.camel@localhost.localdomain> <49E3085D.3060403@tuffmail.co.uk> <20090413170531.GA13188@srcf.ucam.org>
In-Reply-To: <20090413170531.GA13188@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> Ok, I think I've got it. Does this fix things? Ridiculous thinko...
>
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 9cd15e8..564ea14 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -909,7 +909,7 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
>  			thermal_zone_device_register("acpitz", trips, tz,
>  						     &acpi_thermal_zone_ops,
>  						     0, 0, 0,
> -						     tz->polling_frequency);
> +						     tz->polling_frequency*100);
>  	if (IS_ERR(tz->thermal_zone))
>  		return -ENODEV;
>  
>
>   

Yup, that does it.

Thanks!
Alan

