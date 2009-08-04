Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbZHDBLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbZHDBLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 21:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbZHDBLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 21:11:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:21131 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbZHDBLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 21:11:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,317,1246863600"; 
   d="scan'208";a="435854452"
Subject: Re: [PATCH 0/3] Generic sysfs support for ACPI ALS and other
	ALS	devices
From: ykzhao <yakui.zhao@intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <1249290657.2670.250.camel@rzhang-dt>
References: <1249290657.2670.250.camel@rzhang-dt>
Content-Type: text/plain; charset=utf-8
Organization: Intel Open Source Technology Center
Date: Tue, 04 Aug 2009 09:12:23 +0800
Message-Id: <1249348343.3556.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 17:10 +0800, Zhang Rui wrote:
> Hi, all,
> 
> This is the patch set I made to introduce ACPI ALS device driver
> and a generic sysfs I/F for all the ALS devices, like ACPI ALS,
> platform ALS, etc.
> 
> Patch 01 introduces the ACPI ALS device driver.
Great jobs.
But I still have two questions about the patch set.
1. _ALP polling method
   This optional object returns the recommended polling frequency for
the ambient sensor. And OSPM can use the recommended polling frequency
to poll the ambient sensor.
   Of course the spec 9.2.6 also says that the use of polling is allowed
but strongly discouraged by this specification. In such case we had
better not use the polling frequency. Instead it will totally depend on
the async notification event.
   Can some message be printed that the polling frequency is depreciated
when the _ALP is not zero?
   
2. what is the ALS policy and how to use it?
   The main purpose of ambient sensor is to adjust the brightness
according to the current luminance environment. From this patch set it
seems that this will be done in user space. But it is not very clear how
to adjust the brightness based on the current luminance. 
   Can we describe it more clearly?
  
  
Another  little issue is the memory leak in the patch 1.
When it receives the notification event(0x82), it will re-evaluate the
mapping between brightness and luminance. The memory space occupied by
previous mapping should be freed.

Thanks.
    
   
> 
> Patch 02 introduces ALS sysfs class.
> 	Two sysfs I/F are created for each ALS device.
>   /sys/class/als/alsX/illuminance:
> 	the amount of light incident upon a specified surface area.
>   /sys/class/als/alsX/mappings:
> 	ambient light illuminance to display luminance mappings
> 	that can be used by an OS to calibrate its ambient light policy
> 	this is what I got on a test box:
> 	cat /sys/class/als/als0/mappings
> 	﻿Illuminance	Adjustment
> 	          0	       70
> 	         10	       73
> 	         80	       85
> 	        300	      100
> 	       1000	      150
> ﻿	 - noting that ﻿display luminance adjustment values are specified
> 	using relative percentages in order simplify the means by which
> 	these adjustments are applied in lieu of changes to the user’s
> 	display brightness preference.
> 
> Patch 03 introduces the generic sysfs I/F for ACPI ALS devices.
> 
> Patch 02/03 are RFC patches because I'm not sure if these sysfs I/F are
> generic enough for other ALS devices, and if there is any attribute that
> I missed.
> For example, ACPI ALS has some optional properties like ambient light
> temperature and ambient light color chromaticity, but I'm not sure if
> they should be exported to user spaces via ALS sysfs class.
> 
> Any comments are welcome.
> 
> thanks,
> rui
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

