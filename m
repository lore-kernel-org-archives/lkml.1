Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZHLPaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZHLPaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbZHLPaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:30:07 -0400
Received: from kroah.org ([198.145.64.141]:60179 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbZHLPaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:30:05 -0400
Date: Wed, 12 Aug 2009 08:26:23 -0700
From: Greg KH <greg@kroah.com>
To: David Dillow <dave@thedillows.org>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090812152623.GB29407@kroah.com>
References: <20090806183147.GA28409@suse.de>
 <1249772876.22248.34.camel@obelisk.thedillows.org>
 <20090810153943.GB7652@kroah.com>
 <1250001374.22248.65.camel@obelisk.thedillows.org>
 <20090811145523.GD14368@basil.fritz.box>
 <1250036727.26788.7.camel@obelisk.thedillows.org>
 <20090812003433.GA25392@kroah.com>
 <1250081813.26788.13.camel@obelisk.thedillows.org>
 <20090812134440.GA28839@kroah.com>
 <1250087997.8566.9.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250087997.8566.9.camel@obelisk.thedillows.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 10:39:57AM -0400, David Dillow wrote:
> On Wed, 2009-08-12 at 06:44 -0700, Greg KH wrote:
> > On Wed, Aug 12, 2009 at 08:56:53AM -0400, David Dillow wrote:
> > > On Tue, 2009-08-11 at 17:34 -0700, Greg KH wrote:
> > > > On Tue, Aug 11, 2009 at 08:25:27PM -0400, David Dillow wrote:
> > > > > So use Eric/Arjan's program that does it in 60ms -- you get a
> > > > > dynamic /dev, no initrd, fast boot, and no kernel changes required.
> > > > 
> > > > Their program only handles it for a reconstruction of /dev based on
> > > > sysfs one time at boot.  It does not handle things that are added or
> > > > discovered by the system after that, you need udev for that.
> > > > 
> > > > So it's a great hack for boot time stuff, but not a complete /dev
> > > > management replacement like this code can be for numerous systems.
> > > 
> > > What systems would those be?
> > 
> > Rescue disks, Embedded systems with no local users, servers with no
> > local users, etc.  Basically anything that you are only root on, and
> > don't care about group permissions.
> 
> We've discussed those, though, and I think most of those fall under
> either having full control of their static environment, or would have
> something to watch for hotplug events -- udev or a replacement -- and so
> would have the ability to create the node from user space.

Rescue disks and booting to /init/bash have full control over their
static environment?  I don't think so.

> Rescue disks may be an exception, but they only need a minimal
> static /dev and then run a tool to get the initial setup. If you are
> expecting an expert to use them, then either running the tool by hand or
> as a post-modprobe rule should catch updates. They can also run udev (or
> a replacement) with stripped rules if you want to make it friendlier to
> non-expert users.

Ok, so don't use devtmpfs on your rescue disk, let the rest of us have a
choice :)

thanks,

greg k-h
