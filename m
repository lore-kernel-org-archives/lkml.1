Return-Path: <linux-kernel-owner+w=401wt.eu-S932651AbZHDHa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbZHDHa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 03:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932642AbZHDHa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 03:30:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:41418 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515AbZHDHaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:30:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,320,1246863600"; 
   d="scan'208";a="480523393"
Subject: Re: [PATCH 0/3] Generic sysfs support for ACPI ALS and other ALS
	devices
From: Zhang Rui <rui.zhang@intel.com>
To: "Zhao, Yakui" <yakui.zhao@intel.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <1249348343.3556.120.camel@localhost.localdomain>
References: <1249290657.2670.250.camel@rzhang-dt>
	 <1249348343.3556.120.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 15:30:01 +0800
Message-Id: <1249371001.2670.375.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 09:12 +0800, Zhao, Yakui wrote:
> On Mon, 2009-08-03 at 17:10 +0800, Zhang Rui wrote:
> > Hi, all,
> > 
> > This is the patch set I made to introduce ACPI ALS device driver
> > and a generic sysfs I/F for all the ALS devices, like ACPI ALS,
> > platform ALS, etc.
> > 
> > Patch 01 introduces the ACPI ALS device driver.
> Great jobs.
> But I still have two questions about the patch set.
> 1. _ALP polling method
>    This optional object returns the recommended polling frequency for
> the ambient sensor. And OSPM can use the recommended polling frequency
> to poll the ambient sensor.
>    Of course the spec 9.2.6 also says that the use of polling is allowed
> but strongly discouraged by this specification. In such case we had
> better not use the polling frequency. Instead it will totally depend on
> the async notification event.
>    Can some message be printed that the polling frequency is depreciated
> when the _ALP is not zero?

In fact, currently the driver just follows ACPI spec to support _ALP
method for ACPI ALS device. But _ALP return value is not used at all.

As we don't have any platform that _ALP is actually implemented, why not
leave the code there for now. And a warning message is reasonable.

> 2. what is the ALS policy and how to use it?
>    The main purpose of ambient sensor is to adjust the brightness
> according to the current luminance environment. From this patch set it
> seems that this will be done in user space. But it is not very clear how
> to adjust the brightness based on the current luminance. 
>    Can we describe it more clearly?
> 
Generally, in order to make ALS work, user space needs to:
1. set an backlight value as the base point, i.e. the display brightness
   level when the display luminance adjustment value is 100%.
2. when the ambient light illuminance changes, find a proper element in
   /sys/class/als/als0/mappings, and get the display adjustment value.
3. use this adjustment value to get the proper display brightness
   level and set it via the backlight sysfs I/F.

I'll add the ALS documentation to describe how to use this sysfs I/F,
if the current approach is accepted. :)

>   
> Another  little issue is the memory leak in the patch 1.
> When it receives the notification event(0x82), it will re-evaluate the
> mapping between brightness and luminance. The memory space occupied by
> previous mapping should be freed.
> 
good catch.

refreshed patch has been sent out.

thanks,
rui


