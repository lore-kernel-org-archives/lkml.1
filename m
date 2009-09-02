Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZIBUCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZIBUCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 16:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZIBUCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 16:02:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46201 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZIBUCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 16:02:40 -0400
Date: Wed, 2 Sep 2009 22:02:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Frans Pop <elendil@planet.nl>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas, Sujith" <sujith.thomas@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/6] thermal: sysfs-api.txt - document passive
	attribute for thermal zones
Message-ID: <20090902200233.GB1918@ucw.cz>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl> <1251303445-25317-3-git-send-email-elendil@planet.nl> <1251706691.3483.169.camel@rzhang-dt> <200908311320.00632.elendil@planet.nl> <1251765882.3483.193.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251765882.3483.193.camel@rzhang-dt>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > We should not involve any platform specific stuff in this
> > > documentation. how about "Attribute is only present for zones in which
> > > the passive cooling policy is not supported by native thermal driver"
> > [...]
> > > > -If the processor is listed in _PSL method, and the fan is listed in
> > > > _AL0 -method, the sys I/F structure will be built like this:
> > > > +If the processor is listed in _PSL method, the fan is listed in _AL0
> > > > +method, and the zone has a _PSV method, the sys I/F structure will
> > > > be +built like this:
> > >
> > > For an ACPI thermal zone, supporting passive cooling means that both
> > > _PSL and _PSV are available.
> > > so I don't think we need to change this. :)
> > 
> > OK. Updated patch below.
> > 
> > 
> > From: Frans Pop <elendil@planet.nl>
> > Subject: thermal: sysfs-api.txt - document passive attribute for thermal zones
> > 
> > Signed-off-by: Frans Pop <elendil@planet.nl>
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Sujith Thomas <sujith.thomas@intel.com>
> > Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> > 
> Acked-by: Zhang Rui <rui.zhang@intel.com>
> 
> thanks,
> rui
> > diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
> > index 895337f..a87dc27 100644
> > --- a/Documentation/thermal/sysfs-api.txt
> > +++ b/Documentation/thermal/sysfs-api.txt
> > @@ -199,6 +199,15 @@ cdev[0-*]_trip_point
> >  	point.
> >  	RO, Optional
> >  
> > +passive
> > +	Attribute is only present for zones in which the passive cooling
> > +	policy is not supported by native thermal driver. Default is zero
> > +	and can be set to a temperature (in millidegrees) to enable a
> > +	passive trip point for the zone. Activation is done by polling
> > +	with an interval of 1 second.
> > +	Unit: millidegrees Celsius
> > +	RW, Optional
> > +

So '0=disabled'? Better say that, because throttling at 0C would be
useless in most of the world.

Are values below zero supported? Maybe -28000mC should mean
'disabled'? :-).

									Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
