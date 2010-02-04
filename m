Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab0BDXH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:07:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46298 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab0BDXH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:07:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/2] PM / Runtime: Add sysfs switch for disabling device run-time PM (rev. 2)
Date: Fri, 5 Feb 2010 00:08:52 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
References: <201001180129.55219.rjw@sisk.pl> <201001212359.38886.rjw@sisk.pl> <20100204224623.GB1436@ucw.cz>
In-Reply-To: <20100204224623.GB1436@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002050008.52699.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 February 2010, Pavel Machek wrote:
> Hi!
> 
> >  /*
> > + *	control - Report/change current runtime PM setting of the device
> > + *
> > + *	Runtime power management of a device can be blocked with the help of
> > + *	this attribute.  All devices have one of the following two values for
> > + *	the power/control file:
> > + *
> > + *	 + "auto\n" to allow the device to be power managed at run time;
> > + *	 + "on\n" to prevent the device from being power managed at run time;
> 
> I find interface with mandatory \n quite 'interesting'. 

This simply follows the other descriptions in this file.

> Plus english is strange here. All devices have ... "auto" to allow...?
> Strange formulation. List the values first, then add "write ... to allow"?

Ditto.

> > + *	The default for all devices is "auto", which means that devices may be
> > + *	subject to automatic power management, depending on their drivers.
> 
> Is it wise to specify 'auto' default value for devices without runtime
> pm?

Yes, it is.  It means the user space doesn't care whether or not the device is
power managed at run-time.

> > +static ssize_t control_store(struct device * dev, struct device_attribute *attr,
> > +			     const char * buf, size_t n)
> > +{
> > +	char *cp;
> > +	int len = n;
> > +
> > +	cp = memchr(buf, '\n', n);
> > +	if (cp)
> > +		len = cp - buf;
> > +	if (len == sizeof ctrl_auto - 1 && strncmp(buf, ctrl_auto, len) == 0)
> > +		pm_runtime_allow(dev);
> 
> parenthesis after sizeof?

This notation is used throughout this file too.

> Do I read it correctly that all of
> 
> "auto"
> "auto\n"
> "auto\non\nIm confused"
> 
> will switch to auto?

Perhaps it would, but what exactly is the problem with that?

Rafael
