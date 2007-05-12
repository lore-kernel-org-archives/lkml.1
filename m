Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbXELHIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbXELHIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 03:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbXELHI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 03:08:27 -0400
Received: from canuck.infradead.org ([209.217.80.40]:51479 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbXELHI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 03:08:27 -0400
Date: Sat, 12 May 2007 00:08:51 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       linuxpps@ml.enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Message-ID: <20070512070851.GA18752@kroah.com>
References: <20070321074121.GA13843@enneenne.com> <20070502193314.GA23367@enneenne.com> <20070510002740.c4350813.akpm@linux-foundation.org> <20070512055935.GD979@enneenne.com> <20070511231711.21b8a334.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511231711.21b8a334.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 11:17:11PM -0700, Andrew Morton wrote:
> On Fri, 11 May 2007 23:55:37 +0200
> Rodolfo Giometti <giometti@enneenne.com> wrote:
> 
> > Hello,
> > 
> > here my new patch with a lot of fixes.
> > 
> > The only issue not still fixed is the one related with:
> > 
> > 	#define NETLINK_PPSAPI          20
> > 
> > I need time to resolve it.
> > 
> > Follows my comments and then the patch, hope now I can came back into
> > -mm tree again! :)
> 
> Well I suppose I could toss it in there for a bit of review-and-test.  But
> I'll need to drop it again because we do need to split this patch into the series
> of patches, please.
> 
> You should do this earlier rather than later because it improves reviewability.
> 
> > > - This:
> > > 
> > > 	static void pps_class_release(struct class_device *cdev)
> > > 	{
> > > 		/* Nop??? */
> > > 	}
> > > 
> > >   is a bug and it earns you a nastygram from Greg.  These objects must be
> > >   dynamically allocated - this is not optional.
> > 
> > It could be acceptable defining this function as void?
> 
> No, it needs to be a proper release function, like all the other ones
> around the place.
> 
> This comes up again and again and again and I recently asked Greg to direct
> me to (or to write) suitable documentation, and I think he did, but I lost
> it.  Greg, can you remind us please?

I need to put it in some permanent place, but basically the problem is
that if you need to shut the kernel up by using an empty function for a
release, then you are not understanding why the kernel was trying to
warn you in the first place :(

You need to free your memory for the class_device in the release
function, you can not have a static structure, or rely on some other
reference count to handle the cleanup properly.

Also note that 'struct class_device' is going away and you should use
'struct device' instead.  That too needs to be documented better, and is
on my list of things to do...

thanks,

greg k-h
