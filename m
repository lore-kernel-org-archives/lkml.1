Return-Path: <linux-kernel-owner+w=401wt.eu-S1764800AbXHWQek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764800AbXHWQek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 12:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763612AbXHWQec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 12:34:32 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35475 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763422AbXHWQeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 12:34:31 -0400
Date: Thu, 23 Aug 2007 09:33:18 -0700
From: Greg KH <greg@kroah.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Console events and accessibility
Message-ID: <20070823163318.GB5528@kroah.com>
References: <20070821212939.GD3658@interface.famille.thibault.fr> <20070822054855.GB23336@kroah.com> <20070822085355.GB3359@implementation.labri.fr> <20070822130520.GE3359@implementation.labri.fr> <20070823100402.GB6742@kroah.com> <20070823113035.GD3287@implementation.labri.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823113035.GD3287@implementation.labri.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 01:30:35PM +0200, Samuel Thibault wrote:
> Greg KH, le Thu 23 Aug 2007 03:04:02 -0700, a ?crit :
> > > I mean: yes, with these three patches, speakup will work fine.
> > 
> > 3 patches?  I only saw 2.  Or do you mean the modifications of the 3
> > files?
> 
> Maybe you missed the keyboard notification patch which is already in
> -mm.

Yes I did, sorry.  Do you have a pointer for it, all I see is these
patches in -mm:
	console-keyboard-events-and-accessibility.patch
	console-keyboard-events-and-accessibility-fix.patch
	console-keyboard-events-and-accessibility-fix-2.patch

> > The patches look sane but you should change the global symbols to play
> > nicer in the namespace.  Care to respin them together with this change?
> 
> You mean inverse_translate and screen_glyph?

Yes.  Also, things like "register_keyboard_notifier" should be
"keyboard_register_notifer", trying to keep everything in the
"keyboard*" namespace to make things a bit easier overall[1].

> > > The biggest change we'll have to do in speakup is the way it accesses
> > > the serial port, which is really dirty for now, but that's an internal
> > > matter.
> > 
> > Yeah, that shouldn't be that tough to do.
> 
> Well, the biggest problem is that we'd like to output on serial _before_
> /dev gets mounted.

As we can do this today with the console layer (think boot consoles over
serial and network and even USB), it should not be that tough.  Just be
an early console yourself also.

> > It doesn't look like these changes handle scrolling of the console, do
> > they?
> 
> Ah, indeed, speakup doesn't seem to handle it, that's why I forgot it in
> the patch.  I'll see what needs to be done.

Does speakup need to handle it?  I know it's the most popular reader
package out there, but other people seem to have other screen readers
too, but I am in no position to evaluate if their hacks/patches are
really something that is needed here.

Also, we really would like to see the users of these hooks (meaning the
speakup drivers) go into the tree at the same time the hooks do, as we
don't like hooks with no users in the kernel.

I know the speakup code needs a lot of work to bring it up to
kernel-acceptance level.  Has this work been done, or is it happening?
If you need help in this area, I can see about doing a bit as I did a
lot of cleanup of this codebase a few years ago.  I also know of a few
users who are willing to help test this stuff out.

Anyway, thanks a lot for working to get this code into the main tree,
it's very useful to an important group of users.

thanks,

greg k-h
