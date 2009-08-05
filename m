Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbZHEBDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbZHEBDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932632AbZHEBDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:03:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:44159 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161AbZHEBDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:03:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,325,1246863600"; 
   d="scan'208";a="480797981"
Subject: Re: [PATCH 0/3] Generic sysfs support for ACPI ALS and other ALS
	devices
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
In-Reply-To: <20090804132129.GH18974@elf.ucw.cz>
References: <1249290657.2670.250.camel@rzhang-dt>
	 <20090804132129.GH18974@elf.ucw.cz>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 09:02:50 +0800
Message-Id: <1249434170.2670.386.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 21:21 +0800, Pavel Machek wrote:
> On Mon 2009-08-03 17:10:57, Zhang Rui wrote:
> > Hi, all,
> > 
> > This is the patch set I made to introduce ACPI ALS device driver
> > and a generic sysfs I/F for all the ALS devices, like ACPI ALS,
> > platform ALS, etc.
> > 
> > Patch 01 introduces the ACPI ALS device driver.
> > 
> > Patch 02 introduces ALS sysfs class.
> > 	Two sysfs I/F are created for each ALS device.
> >   /sys/class/als/alsX/illuminance:
> > 	the amount of light incident upon a specified surface area.
> >   /sys/class/als/alsX/mappings:
> > 	ambient light illuminance to display luminance mappings
> > 	that can be used by an OS to calibrate its ambient light policy
> > 	this is what I got on a test box:
> > 	cat /sys/class/als/als0/mappings
> > 	???Illuminance	Adjustment
> > 	          0	       70
> > 	         10	       73
> > 	         80	       85
> > 	        300	      100
> > 	       1000	      150
> 
> There's one value per file for sysfs... You should definitely have the
> header. 
> 
> Is there chance to already return adjusted values, avoiding this
> uglyness?

No,
For a ALS policy, user space should set a brightness level as the base
point, i.e. the backlight when display adjustment is 100.
and then uses the adjustment values gotten from this mappings to
calculate the actual brightness level the display should be put in.

thanks,
rui

> 
> Plus I'd say Documentation/ file is needed.
> 
> 									Pavel

