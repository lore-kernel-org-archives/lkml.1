Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZD1U2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZD1U2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbZD1U1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:27:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45478 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZD1U1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:27:53 -0400
Date: Sun, 26 Apr 2009 11:25:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>, Len Brown <lenb@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: 900af0d breaks some embedded suspend/resume
Message-ID: <20090426092550.GB1354@ucw.cz>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <20090418135323.GA7148@flint.arm.linux.org.uk> <alpine.LFD.2.00.0904181205010.4042@localhost.localdomain> <200904190044.58444.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904190044.58444.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-04-19 00:44:57, Rafael J. Wysocki wrote:
> On Saturday 18 April 2009, Linus Torvalds wrote:
> > 
> > On Sat, 18 Apr 2009, Russell King wrote:
> > > 
> > > What I need to be able to do is to suspend most devices on the host side
> > > which may involve talking to a separate microcontroller via I2C to shut
> > > down power to peripherals.
> > 
> > I suspect that for cases like this, the simplest thing to do is to just 
> > add a marker for "don't mess with my power management, I'm doing 
> > everything through sysdev" for the specified devices.
> 
> In this particular case, if sysdev was used, there would be no problem, but the
> platform uses a platform device to suspend-resume the i2c controller.
> In principle we could convert it to use a sysdev, but that would be more
> difficult than the last patch I sent IMO (at least to me).
> 
> Also, apparently it is not the only platform doing it.

OTOH... if the device is needed in late phases of sleep, sysdev *does*
sound like a way to go. So it would be nice to convert those devices
to sysdevs one day.....
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
