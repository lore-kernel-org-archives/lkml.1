Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZIAIoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZIAIoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZIAIoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:44:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56521 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZIAIoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:44:20 -0400
Date: Tue, 1 Sep 2009 10:44:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH V6 2/2] introduce ACPI ALS device driver
Message-ID: <20090901084401.GE9942@elf.ucw.cz>
References: <1251789956.3483.216.camel@rzhang-dt> <20090901081342.GB9942@elf.ucw.cz> <1251794376.3483.238.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251794376.3483.238.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-01 16:39:36, Zhang Rui wrote:
> On Tue, 2009-09-01 at 16:13 +0800, Pavel Machek wrote:
> > Hi!
> > 
> > > ACPI spec defines ACPI Ambient Light Sensor device (hid ACPI0008),
> > > which provides a standard interface by which the OS may query properties
> > > of the ambient light environment the system is currently operating in,
> > > as well as the ability to detect meaningful changes in these values when
> > > the environment changes.
> > 
> > > +struct acpi_als {
> > > +	struct acpi_device *device;
> > > +	struct als_device *als_sys;
> > > +	int illuminance;
> > > +	int chromaticity;
> > > +	int temperature;
> > > +	int polling;
> > > +	int count;
> > > +	struct als_mapping *mappings;
> > > +};
> > 
> > chromaticity is write-only variable.
> 
> >  I believe you can drop it and
> > associted code.
> > 
> > temperature ditto. Drop from this version?
> > 
> > polling ditto. Drop from this version?
> > 
> ???color temperature, chromaticity and polling are three optional features
> defined in the ACPI spec, which are not supported yet in the ACPI ALS
> driver right now.
> 
> I think it's okay to add the code first and then generate some
> incremental patches to enable these features once we found such kind of
> platforms.

I'd avoid adding dead code to ease review etc... You can add it back
easily when it actually has users...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
