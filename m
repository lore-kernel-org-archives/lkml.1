Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab0BDWqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 17:46:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37298 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab0BDWqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 17:46:34 -0500
Date: Thu, 4 Feb 2010 23:46:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] PM / Runtime: Add sysfs switch for disabling
	device run-time PM (rev. 2)
Message-ID: <20100204224623.GB1436@ucw.cz>
References: <201001180129.55219.rjw@sisk.pl> <201001212357.46483.rjw@sisk.pl> <201001212359.38886.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001212359.38886.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  /*
> + *	control - Report/change current runtime PM setting of the device
> + *
> + *	Runtime power management of a device can be blocked with the help of
> + *	this attribute.  All devices have one of the following two values for
> + *	the power/control file:
> + *
> + *	 + "auto\n" to allow the device to be power managed at run time;
> + *	 + "on\n" to prevent the device from being power managed at run time;

I find interface with mandatory \n quite 'interesting'. 

Plus english is strange here. All devices have ... "auto" to allow...?
Strange formulation. List the values first, then add "write ... to allow"?

> + *	The default for all devices is "auto", which means that devices may be
> + *	subject to automatic power management, depending on their drivers.

Is it wise to specify 'auto' default value for devices without runtime
pm?


> +static ssize_t control_store(struct device * dev, struct device_attribute *attr,
> +			     const char * buf, size_t n)
> +{
> +	char *cp;
> +	int len = n;
> +
> +	cp = memchr(buf, '\n', n);
> +	if (cp)
> +		len = cp - buf;
> +	if (len == sizeof ctrl_auto - 1 && strncmp(buf, ctrl_auto, len) == 0)
> +		pm_runtime_allow(dev);

parenthesis after sizeof?

Do I read it correctly that all of

"auto"
"auto\n"
"auto\non\nIm confused"

will switch to auto?

(and sorry for late reply...)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
