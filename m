Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbZDRO3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbZDRO3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 10:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbZDRO3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 10:29:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34644 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbZDRO3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 10:29:15 -0400
Date: Sat, 18 Apr 2009 15:28:07 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: 900af0d breaks some embedded suspend/resume
Message-ID: <20090418142807.GB7148@flint.arm.linux.org.uk>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <200904181523.36010.rjw@sisk.pl> <200904181559.19485.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904181559.19485.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 03:59:18PM +0200, Rafael J. Wysocki wrote:
> On Saturday 18 April 2009, Rafael J. Wysocki wrote:
> > On Saturday 18 April 2009, Russell King wrote:
> > > Some platforms need to talk via I2C to power control devices during
> > > the suspend method.  Currently, they do this via the platform PM ops
> > > prepare callback, relying on the I2C driver being hooked into the
> > > 'late' suspend method, and hence being shut down _after_ the prepare
> > > callback.
> > 
> > Well, I was not aware of this dependency and it seems quite unusual for a
> > platform to depend on a driver like this.
> > 
> > > However, as of the above commit, the ordering is changed such that
> > > platforms don't get notified of suspends until after all devices are
> > > well and truely shut down.
> > > 
> > > This can't work, and actively breaks some platforms.
> > 
> > Sorry for that.
> > 
> > The patchset in question had been discussed quite extensively before it was
> > merged and it's a pity none of the people caring for the affected platforms
> > took part in those discussions.  That would allow us to avoid the breakage.
> >  
> > > Please come up with another solution for your PCI problems,
> > 
> > I don't think this is possible, sorry.
> > 
> > > or provide alternative equivalent functionality where the platform code is
> > > notified of the PM event prior to the late suspend callback being issued.
> > 
> > There is the .begin() callback that could be used, but if you need the
> > platform to be notified _just_ prior to the late suspend callback, then the
> > only thing I can think of at the moment is the appended patch.
> > 
> > It shouldn't break anything in theory, because the majority of drivers put
> > their devices into low power states in the "regular" suspend callbacks anyway.
> 
> Still, if it turns out to break anything, we'll have to think of an alternative
> approach.
> 
> Which platforms exactly are affected?

The one I've maintained since 2.6.9 and am just sending out the initial
bits for final review.

(It's taking a long time to get it out there because I can only spend
very little time on it, and it keeps getting broken - ALSA, SCSI and
now PM have all broken it in the last couple of months.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
