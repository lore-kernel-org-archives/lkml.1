Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbZHFHOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbZHFHOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:14:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZHFHOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:14:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35600 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZHFHOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:14:00 -0400
Date: Thu, 6 Aug 2009 09:13:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/3] Generic sysfs support for ACPI ALS and other ALS
	devices
Message-ID: <20090806071353.GB21847@elf.ucw.cz>
References: <1249290657.2670.250.camel@rzhang-dt> <20090804132129.GH18974@elf.ucw.cz> <1249434170.2670.386.camel@rzhang-dt> <20090805161931.GA9749@elf.ucw.cz> <1249522879.2670.480.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249522879.2670.480.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > No,
> > > For a ALS policy, user space should set a brightness level as the base
> > > point, i.e. the backlight when display adjustment is 100.
> > > and then uses the adjustment values gotten from this mappings to
> > > calculate the actual brightness level the display should be put in.
> > 
> > Ok, so just make the code return only the "adjustement" -- userspace
> > does not really need to know "illuminance" and you can do the mapping
> > in the kernel AFAICT.
> > 			
> 
> ALS exports
> 1. the current ambient light illuminance
> 2. the mappings
> 
> Backlight device exports
> 1. the brightness levels.
> 
> User space needs to:
> 1. set a brightness level as the base point
> 2. read the current ambient light illuminance from ALS device
> 3. read the ambient light illuminance to display adjustment mappings
> 4. calculate a proper brightness level we should set.
> 
> For example, if we set brightness 6 as the default brightness, i.e. the
> brightness level when ambient light illuminance is 300.
> Now we walk outdoors, and the current illuminance is 1000,
> then we should set the new_brightness_level to (6 * 150%)

Yes, so just export

ALS exports
1. the current ambient light illuminance
2. the current mapped ambient light illuminance

Backlight device exports
1. the brightness levels.
 
User space needs to:
1. set a brightness level as the base point
2. read the current mapped ambient light illuminance from ALS device
3. calculate a proper brightness level we should set.

You get

a) nicer interface
b) simpler userland
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
