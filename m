Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbYGBWHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbYGBWHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYGBWHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:07:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38873 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbYGBWG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:06:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: Removing sysdevs? (was: Re: Is sysfs the right place to get cache and CPU topology info?)
Date: Thu, 3 Jul 2008 00:08:45 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andi Kleen <andi@firstfloor.org>, Nathan Lynch <ntl@pobox.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com> <200807022341.44965.rjw@sisk.pl> <20080702214853.GA10451@kroah.com>
In-Reply-To: <20080702214853.GA10451@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807030008.46851.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of July 2008, Greg KH wrote:
> On Wed, Jul 02, 2008 at 11:41:44PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, 2 of July 2008, Greg KH wrote:
> > > On Wed, Jul 02, 2008 at 05:14:02PM +0200, Andi Kleen wrote:
> > > > Nathan Lynch wrote:
> > > > > Andi Kleen wrote:
> > > > >> Andrew Morton <akpm@linux-foundation.org> writes:
> > > > >>> sysfs is part of the kernel ABI.  We should design our interfaces there
> > > > >>> as carefully as we design any others.
> > > > >> The basic problem is that sysfs exports an internal kernel object model
> > > > >> and these tend to change. To really make it stable would require 
> > > > >> splitting it into internal and presented interface.
> > > > > 
> > > > > True, but... /sys/devices/system/cpu has been there since around 2.6.5
> > > > > iirc.  A google code search for that path shows plenty of programs
> > > > > (including hal) that hard-code it.  Exposed object model or not,
> > > > > changing that path would break lots of software.
> > > > 
> > > > Yes it would.
> > > > 
> > > > But Greg is making noises of getting rid of sysdevs and it wouldn't
> > > > surprise me if that ended up being user visible since most object
> > > > model changes end up being visible.
> > > 
> > > I hope to make sysdevs go away in such a manner that the sysfs tree does
> > > not change at all.  That's my goal, but we still have a long ways to go
> > > before we can even consider attempting to do this, so don't worry about
> > > putting things in this location if you feel it is the best fit.
> > 
> > Speaking of which, I'm very interested in the removing of sysdevs, since they
> > don't fit into the new suspend/hibernation framework I'm working on.  Can you
> > please tell me what the plan is?
> 
> The plan is:
> 	- remaining driver core cleanups to allow for multiple drivers
> 	  to be bound to individual devices
> 	- add multiple binding support to the core
> 	- migrate existing sysdevs to struct device, now that multiple
> 	  binding is allowed

Once they've been migrated to struct device, will they reside on specific
'system' bus, or will they be platform devices?

> 	- delete sysdev structure
> 	- profit!
> 
> It's that first step that is taking a while, the last big changes will
> be going into 2.6.27 to help accomplish this, after that merge happens
> for 2.6.27-rc1 I'll be working on the remaining steps.

Sounds good, please let me know if you need help.

Thanks,
Rafael
