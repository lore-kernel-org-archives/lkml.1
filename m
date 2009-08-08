Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZHHXPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZHHXPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 19:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZHHXPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 19:15:19 -0400
Received: from smtp.knology.net ([24.214.63.101]:33893 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbZHHXPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 19:15:17 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Aug 2009 19:15:17 EDT
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
From: David Dillow <dave@thedillows.org>
To: Greg KH <gregkh@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
In-Reply-To: <20090806183147.GA28409@suse.de>
References: <20090805171513.GA10443@kroah.com>
	 <20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
	 <20090805182805.GA7534@kroah.com> <20090805185136.GA21442@kroah.com>
	 <87ljlxhrnr.fsf@basil.nowhere.org>
	 <1249575658.19886.8.camel@lap75545.ornl.gov>
	 <20090806183147.GA28409@suse.de>
Content-Type: text/plain
Date: Sat, 08 Aug 2009 19:07:56 -0400
Message-Id: <1249772876.22248.34.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 11:31 -0700, Greg KH wrote:
> On Thu, Aug 06, 2009 at 12:20:58PM -0400, David Dillow wrote:
> > If you use mount by label or UUID, you still need udev (or other tools)
> > in the initrd to find the right disk, correct?
> 
> Yes, you would.
> 
> > And for distros that want to support that, does this really reduce the
> > amount of code in the initrd?
> 
> Yes it does, see the code in the Novell Moblin images for an example of
> how to use devtmpfs with udev for how to do this.

I followed up with Greg offline to make sure I was looking at the right
thing, but the upshot is that Moblin does not use an initrd and devtmpfs
does not in any way reduce the amount of code for those distros that
want to support more than the root=/dev/blah syntax.

Given Eric and Arjan's numbers about the time it takes to populate /dev
from /sys -- pointing the speed problem squarely at udev or the ruleset
-- I don't see much of a win for devtmpfs other than avoiding a
static /dev to make init=/bin/sh work. You cannot rely on it for a
hotplug disk such as USB, as it doesn't do the root=LABEL=usbroot that
you'd want to do since the location is not stable.


