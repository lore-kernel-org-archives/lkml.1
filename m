Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZHULwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZHULwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZHULwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:52:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51548 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbZHULv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:51:59 -0400
Date: Fri, 21 Aug 2009 13:51:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/3] Generic sysfs support for ACPI ALS and other ALS
	devices
Message-ID: <20090821115100.GA20681@elf.ucw.cz>
References: <1249290657.2670.250.camel@rzhang-dt> <20090804132129.GH18974@elf.ucw.cz> <1249434170.2670.386.camel@rzhang-dt> <20090805161931.GA9749@elf.ucw.cz> <1249522879.2670.480.camel@rzhang-dt> <20090806071353.GB21847@elf.ucw.cz> <1249548430.2670.517.camel@rzhang-dt> <20090806095258.GA31370@elf.ucw.cz> <1250497963.5351.33.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250497963.5351.33.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Could you please look at the documentation about ALS sysfs class in the
> > > patch I sent out just now, and comment on that one please? thanks!
> > 
> > I did. The interface is too ugly to live.
> 
> Hi, Pavel,
> 
> I tried to convert the ALS sysfs I/F to two attributes only, i.e.
> illuminance and adjustment.
> But I found several potential problems.
> 1. the illuminance to display adjustment mappings can not be convert to
> a brightness level smoothly.
> for example,
> 	illuminance	adjustment
> 1	600		70
> 2	900		100
> 3	1500		120
> when the current illuminance is not one of the values listed in the
> mappings, e.g. 750, the ALS driver don't have enough knowledge to get
> the proper display adjustment, especially that a proper display
> adjustment would be easy to select a proper brightness level.
> We'd better leave this to user space, which is more flexible.

Well, what interpolation does ACPI specs suggest to do? Maybe it is
easier to have linear interpolation in the kernel than to have ugly
20-file interface?

> 2. I don't know if there will be laptops exporting buggy mappings that
> needs to be overridden some day, but the current sysfs I/F is easy for
> expanding.
> what do you think?

If you have buggy laptop, fix the laptop. (You can still export the
raw values... and btw if you have buggy laptop and want to work around
it, maybe the workaround is easier/better done in kernel?)

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
