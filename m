Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZHQIeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZHQIeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbZHQIeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:34:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:24845 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757147AbZHQIeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:34:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,394,1246863600"; 
   d="scan'208";a="439552978"
Subject: Re: [PATCH 0/3] Generic sysfs support for ACPI ALS and other ALS
	devices
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
In-Reply-To: <20090806095258.GA31370@elf.ucw.cz>
References: <1249290657.2670.250.camel@rzhang-dt>
	 <20090804132129.GH18974@elf.ucw.cz> <1249434170.2670.386.camel@rzhang-dt>
	 <20090805161931.GA9749@elf.ucw.cz> <1249522879.2670.480.camel@rzhang-dt>
	 <20090806071353.GB21847@elf.ucw.cz> <1249548430.2670.517.camel@rzhang-dt>
	 <20090806095258.GA31370@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 16:32:43 +0800
Message-Id: <1250497963.5351.33.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 17:52 +0800, Pavel Machek wrote:
> Hi!
> 
> > > Yes, so just export
> > > 
> > > ALS exports
> > > 1. the current ambient light illuminance
> > > 2. the current mapped ambient light illuminance
> > > 
> > In fact, only one attribute is enough.
> 
> Good. (I thought you would want to export the 1) too, mainly for debugging).
> 
> > The ALS driver can query the current illuminance, parse the mapping and
> > only export the display luminance adjustment values to user space.
> 
> > then user space just needs to
> > 1. set a brightness level as the base point
> > 2. get the display adjustment value and calculate a proper brightness
> > level at any time.
> > 
> > this is easier, but it makes me feel that this doesn't look like an
> > _ALS_ device any more.
> > We still should export some ALS properties to user space, shouldn't
> > we?
> 
> Why? Just because ACPI specs is ugly does not mean we should make
> Linux ugly, too. Please just use suggestion above.
> 
> > Could you please look at the documentation about ALS sysfs class in the
> > patch I sent out just now, and comment on that one please? thanks!
> 
> I did. The interface is too ugly to live.

Hi, Pavel,

I tried to convert the ALS sysfs I/F to two attributes only, i.e.
illuminance and adjustment.
But I found several potential problems.
1. the illuminance to display adjustment mappings can not be convert to
a brightness level smoothly.
for example,
	illuminance	adjustment
1	600		70
2	900		100
3	1500		120
when the current illuminance is not one of the values listed in the
mappings, e.g. 750, the ALS driver don't have enough knowledge to get
the proper display adjustment, especially that a proper display
adjustment would be easy to select a proper brightness level.
We'd better leave this to user space, which is more flexible.
2. I don't know if there will be laptops exporting buggy mappings that
needs to be overridden some day, but the current sysfs I/F is easy for
expanding.
what do you think?

thanks,
rui



> 								Pavel
> 

