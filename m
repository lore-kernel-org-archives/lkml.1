Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbZHJPpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbZHJPpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZHJPpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:45:14 -0400
Received: from kroah.org ([198.145.64.141]:55437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZHJPpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:45:13 -0400
Date: Mon, 10 Aug 2009 08:39:43 -0700
From: Greg KH <greg@kroah.com>
To: David Dillow <dave@thedillows.org>
Cc: Greg KH <gregkh@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090810153943.GB7652@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
 <20090805182805.GA7534@kroah.com>
 <20090805185136.GA21442@kroah.com>
 <87ljlxhrnr.fsf@basil.nowhere.org>
 <1249575658.19886.8.camel@lap75545.ornl.gov>
 <20090806183147.GA28409@suse.de>
 <1249772876.22248.34.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249772876.22248.34.camel@obelisk.thedillows.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08, 2009 at 07:07:56PM -0400, David Dillow wrote:
> On Thu, 2009-08-06 at 11:31 -0700, Greg KH wrote:
> > On Thu, Aug 06, 2009 at 12:20:58PM -0400, David Dillow wrote:
> > > If you use mount by label or UUID, you still need udev (or other tools)
> > > in the initrd to find the right disk, correct?
> > 
> > Yes, you would.
> > 
> > > And for distros that want to support that, does this really reduce the
> > > amount of code in the initrd?
> > 
> > Yes it does, see the code in the Novell Moblin images for an example of
> > how to use devtmpfs with udev for how to do this.
> 
> I followed up with Greg offline to make sure I was looking at the right
> thing, but the upshot is that Moblin does not use an initrd and devtmpfs
> does not in any way reduce the amount of code for those distros that
> want to support more than the root=/dev/blah syntax.

Like Scott points out, this option now allows distros to use blkid
directly instead of udev if they want to implement things like this
without udev.

> Given Eric and Arjan's numbers about the time it takes to populate /dev
> from /sys -- pointing the speed problem squarely at udev or the ruleset
> -- I don't see much of a win for devtmpfs other than avoiding a
> static /dev to make init=/bin/sh work.

That's a very big win right there, don't you think?  Also, embedded and
rescue disks also would like it for this very reason.

> You cannot rely on it for a hotplug disk such as USB, as it doesn't do
> the root=LABEL=usbroot that you'd want to do since the location is not
> stable.

Again, not all the world requires such labels.

thanks,

greg k-h
