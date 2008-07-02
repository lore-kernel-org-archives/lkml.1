Return-Path: <linux-kernel-owner+w=401wt.eu-S1760454AbYGBVvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454AbYGBVvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbYGBVvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:51:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59094 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbYGBVvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:51:10 -0400
Date: Wed, 2 Jul 2008 14:48:53 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>, Nathan Lynch <ntl@pobox.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Removing sysdevs? (was: Re: Is sysfs the right place to get
	cache and CPU topology info?)
Message-ID: <20080702214853.GA10451@kroah.com>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com> <486B9B3A.4060709@firstfloor.org> <20080702185145.GB20938@kroah.com> <200807022341.44965.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807022341.44965.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 11:41:44PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, 2 of July 2008, Greg KH wrote:
> > On Wed, Jul 02, 2008 at 05:14:02PM +0200, Andi Kleen wrote:
> > > Nathan Lynch wrote:
> > > > Andi Kleen wrote:
> > > >> Andrew Morton <akpm@linux-foundation.org> writes:
> > > >>> sysfs is part of the kernel ABI.  We should design our interfaces there
> > > >>> as carefully as we design any others.
> > > >> The basic problem is that sysfs exports an internal kernel object model
> > > >> and these tend to change. To really make it stable would require 
> > > >> splitting it into internal and presented interface.
> > > > 
> > > > True, but... /sys/devices/system/cpu has been there since around 2.6.5
> > > > iirc.  A google code search for that path shows plenty of programs
> > > > (including hal) that hard-code it.  Exposed object model or not,
> > > > changing that path would break lots of software.
> > > 
> > > Yes it would.
> > > 
> > > But Greg is making noises of getting rid of sysdevs and it wouldn't
> > > surprise me if that ended up being user visible since most object
> > > model changes end up being visible.
> > 
> > I hope to make sysdevs go away in such a manner that the sysfs tree does
> > not change at all.  That's my goal, but we still have a long ways to go
> > before we can even consider attempting to do this, so don't worry about
> > putting things in this location if you feel it is the best fit.
> 
> Speaking of which, I'm very interested in the removing of sysdevs, since they
> don't fit into the new suspend/hibernation framework I'm working on.  Can you
> please tell me what the plan is?

The plan is:
	- remaining driver core cleanups to allow for multiple drivers
	  to be bound to individual devices
	- add multiple binding support to the core
	- migrate existing sysdevs to struct device, now that multiple
	  binding is allowed
	- delete sysdev structure
	- profit!

It's that first step that is taking a while, the last big changes will
be going into 2.6.27 to help accomplish this, after that merge happens
for 2.6.27-rc1 I'll be working on the remaining steps.

thanks,

greg k-h
