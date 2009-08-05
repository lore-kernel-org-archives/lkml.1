Return-Path: <linux-kernel-owner+w=401wt.eu-S934619AbZHEQTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619AbZHEQTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934023AbZHEQTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:19:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41410 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933979AbZHEQTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:19:37 -0400
Date: Wed, 5 Aug 2009 18:19:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/3] Generic sysfs support for ACPI ALS and other ALS
	devices
Message-ID: <20090805161931.GA9749@elf.ucw.cz>
References: <1249290657.2670.250.camel@rzhang-dt> <20090804132129.GH18974@elf.ucw.cz> <1249434170.2670.386.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249434170.2670.386.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-08-05 09:02:50, Zhang Rui wrote:
> On Tue, 2009-08-04 at 21:21 +0800, Pavel Machek wrote:
> > On Mon 2009-08-03 17:10:57, Zhang Rui wrote:
> > > Hi, all,
> > > 
> > > This is the patch set I made to introduce ACPI ALS device driver
> > > and a generic sysfs I/F for all the ALS devices, like ACPI ALS,
> > > platform ALS, etc.
> > > 
> > > Patch 01 introduces the ACPI ALS device driver.
> > > 
> > > Patch 02 introduces ALS sysfs class.
> > > 	Two sysfs I/F are created for each ALS device.
> > >   /sys/class/als/alsX/illuminance:
> > > 	the amount of light incident upon a specified surface area.
> > >   /sys/class/als/alsX/mappings:
> > > 	ambient light illuminance to display luminance mappings
> > > 	that can be used by an OS to calibrate its ambient light policy
> > > 	this is what I got on a test box:
> > > 	cat /sys/class/als/als0/mappings
> > > 	???Illuminance	Adjustment
> > > 	          0	       70
> > > 	         10	       73
> > > 	         80	       85
> > > 	        300	      100
> > > 	       1000	      150
> > 
> > There's one value per file for sysfs... You should definitely have the
> > header. 
> > 
> > Is there chance to already return adjusted values, avoiding this
> > uglyness?
> 
> No,
> For a ALS policy, user space should set a brightness level as the base
> point, i.e. the backlight when display adjustment is 100.
> and then uses the adjustment values gotten from this mappings to
> calculate the actual brightness level the display should be put in.

Ok, so just make the code return only the "adjustement" -- userspace
does not really need to know "illuminance" and you can do the mapping
in the kernel AFAICT.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
