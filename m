Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbZHFIrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbZHFIrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZHFIrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:47:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:23315 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZHFIro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:47:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,332,1246863600"; 
   d="scan'208";a="172923919"
Subject: Re: [PATCH 0/3] Generic sysfs support for ACPI ALS and other ALS
	devices
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
In-Reply-To: <20090806071353.GB21847@elf.ucw.cz>
References: <1249290657.2670.250.camel@rzhang-dt>
	 <20090804132129.GH18974@elf.ucw.cz> <1249434170.2670.386.camel@rzhang-dt>
	 <20090805161931.GA9749@elf.ucw.cz> <1249522879.2670.480.camel@rzhang-dt>
	 <20090806071353.GB21847@elf.ucw.cz>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 16:47:10 +0800
Message-Id: <1249548430.2670.517.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 15:13 +0800, Pavel Machek wrote:
> > > > No,
> > > > For a ALS policy, user space should set a brightness level as the base
> > > > point, i.e. the backlight when display adjustment is 100.
> > > > and then uses the adjustment values gotten from this mappings to
> > > > calculate the actual brightness level the display should be put in.
> > > 
> > > Ok, so just make the code return only the "adjustement" -- userspace
> > > does not really need to know "illuminance" and you can do the mapping
> > > in the kernel AFAICT.
> > > 			
> > 
> > ALS exports
> > 1. the current ambient light illuminance
> > 2. the mappings
> > 
> > Backlight device exports
> > 1. the brightness levels.
> > 
> > User space needs to:
> > 1. set a brightness level as the base point
> > 2. read the current ambient light illuminance from ALS device
> > 3. read the ambient light illuminance to display adjustment mappings
> > 4. calculate a proper brightness level we should set.
> > 
> > For example, if we set brightness 6 as the default brightness, i.e. the
> > brightness level when ambient light illuminance is 300.
> > Now we walk outdoors, and the current illuminance is 1000,
> > then we should set the new_brightness_level to (6 * 150%)
> 
> Yes, so just export
> 
> ALS exports
> 1. the current ambient light illuminance
> 2. the current mapped ambient light illuminance
> 
In fact, only one attribute is enough.
The ALS driver can query the current illuminance, parse the mapping and
only export the display luminance adjustment values to user space.

> Backlight device exports
> 1. the brightness levels.
>  
> User space needs to:
> 1. set a brightness level as the base point
> 2. read the current mapped ambient light illuminance from ALS device
> 3. calculate a proper brightness level we should set.
> 
then user space just needs to
1. set a brightness level as the base point
2. get the display adjustment value and calculate a proper brightness
level at any time.

this is easier, but it makes me feel that this doesn't look like an
_ALS_ device any more.
We still should export some ALS properties to user space, shouldn't we?

Could you please look at the documentation about ALS sysfs class in the
patch I sent out just now, and comment on that one please? thanks!

thanks,
rui


