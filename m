Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab0BEG2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 01:28:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52179 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab0BEG2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 01:28:09 -0500
Date: Fri, 5 Feb 2010 07:27:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] PM / Runtime: Add sysfs switch for disabling
	device run-time PM (rev. 2)
Message-ID: <20100205062718.GA1384@ucw.cz>
References: <201001180129.55219.rjw@sisk.pl> <201001212359.38886.rjw@sisk.pl> <20100204224623.GB1436@ucw.cz> <201002050008.52699.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002050008.52699.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > + *	The default for all devices is "auto", which means that devices may be
> > > + *	subject to automatic power management, depending on their drivers.
> > 
> > Is it wise to specify 'auto' default value for devices without runtime
> > pm?
> 
> Yes, it is.  It means the user space doesn't care whether or not the device is
> power managed at run-time.

Well, defaulting to 'on' for drivers when runtime pm is experimental
seems logical. and there will be such drivers...

> > > +		len = cp - buf;
> > > +	if (len == sizeof ctrl_auto - 1 && strncmp(buf, ctrl_auto, len) == 0)
> > > +		pm_runtime_allow(dev);
> > 
> > parenthesis after sizeof?
> 
> This notation is used throughout this file too.

...but is inconsistent with rest of kernel.

> > Do I read it correctly that all of
> > 
> > "auto"
> > "auto\n"
> > "auto\non\nIm confused"
> > 
> > will switch to auto?
> 
> Perhaps it would, but what exactly is the problem with that?

That apps will start depending on such broken behaviour?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
