Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbZDRN77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbZDRN77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 09:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZDRN7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 09:59:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44845 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbZDRN7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 09:59:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Russell King <rmk@arm.linux.org.uk>
Subject: Re: 900af0d breaks some embedded suspend/resume
Date: Sat, 18 Apr 2009 15:59:18 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <200904181523.36010.rjw@sisk.pl>
In-Reply-To: <200904181523.36010.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904181559.19485.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 April 2009, Rafael J. Wysocki wrote:
> On Saturday 18 April 2009, Russell King wrote:
> > Some platforms need to talk via I2C to power control devices during
> > the suspend method.  Currently, they do this via the platform PM ops
> > prepare callback, relying on the I2C driver being hooked into the
> > 'late' suspend method, and hence being shut down _after_ the prepare
> > callback.
> 
> Well, I was not aware of this dependency and it seems quite unusual for a
> platform to depend on a driver like this.
> 
> > However, as of the above commit, the ordering is changed such that
> > platforms don't get notified of suspends until after all devices are
> > well and truely shut down.
> > 
> > This can't work, and actively breaks some platforms.
> 
> Sorry for that.
> 
> The patchset in question had been discussed quite extensively before it was
> merged and it's a pity none of the people caring for the affected platforms
> took part in those discussions.  That would allow us to avoid the breakage.
>  
> > Please come up with another solution for your PCI problems,
> 
> I don't think this is possible, sorry.
> 
> > or provide alternative equivalent functionality where the platform code is
> > notified of the PM event prior to the late suspend callback being issued.
> 
> There is the .begin() callback that could be used, but if you need the
> platform to be notified _just_ prior to the late suspend callback, then the
> only thing I can think of at the moment is the appended patch.
> 
> It shouldn't break anything in theory, because the majority of drivers put
> their devices into low power states in the "regular" suspend callbacks anyway.

Still, if it turns out to break anything, we'll have to think of an alternative
approach.

Which platforms exactly are affected?

Rafael
