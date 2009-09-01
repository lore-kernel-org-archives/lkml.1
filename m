Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZIASqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZIASqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 14:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZIASp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 14:45:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZIASp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 14:45:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH V6 1/2] introduce ALS sysfs class
Date: Tue, 1 Sep 2009 20:47:00 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1251789947.3483.215.camel@rzhang-dt> <1251793844.3483.228.camel@rzhang-dt> <20090901084306.GD9942@elf.ucw.cz>
In-Reply-To: <20090901084306.GD9942@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909012047.00606.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 September 2009, Pavel Machek wrote:
> On Tue 2009-09-01 16:30:44, Zhang Rui wrote:
> > On Tue, 2009-09-01 at 16:11 +0800, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > Introduce ALS sysfs class.
> > > > 
> > > > ALS sysfs class provides a standard sysfs interface for
> > > > Ambient Light Sensor devices.
> > > > 
> > > > please read Documentation/ABI/testing/sysfs-class-als for
> > > > detailed sysfs designs.
> > > 
> > > Thanks for fixing the interface!
> > > 
> > > > +static ssize_t
> > > > +illuminance_show(struct device *dev, struct device_attribute *attr, char *buf)
> > > > +{
> > > > +	struct als_device *als = to_als_device(dev);
> > > > +	int illuminance;
> > > > +	int result;
> > > > +
> > > > +	result = als->ops->get_illuminance(als, &illuminance);
> > > > +	if (result)
> > > > +		return result;
> > > > +
> > > > +	if (!illuminance)
> > > > +		return sprintf(buf, "Illuminance below the supported range\n");
> > > > +	else if (illuminance == -1)
> > > > +		return sprintf(buf, "Illuminance above the supported range\n");
> > > > +	else if (illuminance < -1)
> > > > +		return -ERANGE;
> > > > +	else
> > > > +		return sprintf(buf, "%d\n", illuminance);
> > > > +}
> > > 
> > > that's nor particulary clean. One value per file and all that. Could
> > > we simply return errnos in _all_ the error cases? (Docs would suggest
> > > this contains integer so string is definitely unexpected).
> > > 
> > IMO, 0 and -1 are not errors. they just suggest that the Ambient Light
> > illuminance is beyond the device support range, while the device is
> > still working normally.
> > what about exporting these values (0 and -1) to user space directly?
> 
> Returning 0 for "below" range and 99999999 for "above" range would be
> nice, yes. 

Why not 0 and "all ones" or 0 and -1.

Is there anything wrong with -1 in particular?

Best,
Rafael
