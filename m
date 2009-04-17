Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbZDQBg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbZDQBg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZDQBgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:36:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:26499 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbZDQBgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:36:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,201,1239001200"; 
   d="scan'208";a="132456183"
Subject: Re: [PATCH] thermal: Fix polling frequency for systems without
	passive cooling
From: Zhang Rui <rui.zhang@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "Zhao, Yakui" <yakui.zhao@intel.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <20090414191645.GB7940@srcf.ucam.org>
References: <49DF6835.9040501@tuffmail.co.uk> <49DFE345.3010109@gmail.com>
	 <49E05F83.2090500@tuffmail.co.uk> <49E20EBA.2090708@tuffmail.co.uk>
	 <1239588248.5564.19.camel@localhost.localdomain>
	 <49E3085D.3060403@tuffmail.co.uk> <20090413170531.GA13188@srcf.ucam.org>
	 <49E38779.9060705@tuffmail.co.uk>  <20090414191645.GB7940@srcf.ucam.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 17 Apr 2009 09:37:07 +0800
Message-Id: <1239932227.7661.397.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 03:16 +0800, Matthew Garrett wrote:
> The polling interval (in deciseconds) was accidently interpreted as 
> being in milliseconds in one codepath, resulting in excessively frequent 
> polling. Ensure that the conversion is performed.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Zhang Rui <rui.zhang@intel.com>

﻿Len,
I think we can ship this patch in 2.6.30-rc3.

thanks,
rui
> 
> ---
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

