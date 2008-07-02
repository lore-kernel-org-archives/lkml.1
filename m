Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYGBXFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYGBXFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 19:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYGBXFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 19:05:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39051 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbYGBXF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 19:05:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: Removing sysdevs? (was: Re: Is sysfs the right place to get cache and CPU topology info?)
Date: Thu, 3 Jul 2008 01:06:45 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andi Kleen <andi@firstfloor.org>, Nathan Lynch <ntl@pobox.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com> <200807030008.46851.rjw@sisk.pl> <20080702221600.GB17929@kroah.com>
In-Reply-To: <20080702221600.GB17929@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807030106.46196.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of July 2008, Greg KH wrote:
> On Thu, Jul 03, 2008 at 12:08:45AM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, 2 of July 2008, Greg KH wrote:
> > > On Wed, Jul 02, 2008 at 11:41:44PM +0200, Rafael J. Wysocki wrote:
> > > > On Wednesday, 2 of July 2008, Greg KH wrote:
> > > > > On Wed, Jul 02, 2008 at 05:14:02PM +0200, Andi Kleen wrote:
> > > > > > Nathan Lynch wrote:
> > > > > > > Andi Kleen wrote:
> > > > > > >> Andrew Morton <akpm@linux-foundation.org> writes:
> > > > > > >>> sysfs is part of the kernel ABI.  We should design our interfaces there
> > > > > > >>> as carefully as we design any others.
> > > > > > >> The basic problem is that sysfs exports an internal kernel object model
> > > > > > >> and these tend to change. To really make it stable would require 
> > > > > > >> splitting it into internal and presented interface.
> > > > > > > 
> > > > > > > True, but... /sys/devices/system/cpu has been there since around 2.6.5
> > > > > > > iirc.  A google code search for that path shows plenty of programs
> > > > > > > (including hal) that hard-code it.  Exposed object model or not,
> > > > > > > changing that path would break lots of software.
> > > > > > 
> > > > > > Yes it would.
> > > > > > 
> > > > > > But Greg is making noises of getting rid of sysdevs and it wouldn't
> > > > > > surprise me if that ended up being user visible since most object
> > > > > > model changes end up being visible.
> > > > > 
> > > > > I hope to make sysdevs go away in such a manner that the sysfs tree does
> > > > > not change at all.  That's my goal, but we still have a long ways to go
> > > > > before we can even consider attempting to do this, so don't worry about
> > > > > putting things in this location if you feel it is the best fit.
> > > > 
> > > > Speaking of which, I'm very interested in the removing of sysdevs, since they
> > > > don't fit into the new suspend/hibernation framework I'm working on.  Can you
> > > > please tell me what the plan is?
> > > 
> > > The plan is:
> > > 	- remaining driver core cleanups to allow for multiple drivers
> > > 	  to be bound to individual devices
> > > 	- add multiple binding support to the core
> > > 	- migrate existing sysdevs to struct device, now that multiple
> > > 	  binding is allowed
> > 
> > Once they've been migrated to struct device, will they reside on specific
> > 'system' bus, or will they be platform devices?
> 
> I haven't really thought it through more than the above yet, so I don't
> know :)

This is quite important, though, because the device objects that sysdevs will
be replaced with should provide suspend/hibernation callbacks to be run with
interrupts disabled, while for some of them it may also be convenient to
provide "normal" suspend/hibernation callbacks to be run with interrupts
enabled.

For this reason their bus type will have to be quite similar to the platform bus
type.

Thanks,
Rafael
