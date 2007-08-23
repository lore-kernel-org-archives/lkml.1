Return-Path: <linux-kernel-owner+w=401wt.eu-S1764057AbXHWRI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764057AbXHWRI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbXHWRIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:08:52 -0400
Received: from iona.labri.fr ([147.210.8.143]:53673 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbXHWRIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:08:52 -0400
Date: Thu, 23 Aug 2007 19:08:45 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Console events and accessibility
Message-ID: <20070823170845.GA3721@interface.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070821212939.GD3658@interface.famille.thibault.fr> <20070822054855.GB23336@kroah.com> <20070822085355.GB3359@implementation.labri.fr> <20070822130520.GE3359@implementation.labri.fr> <20070823100402.GB6742@kroah.com> <20070823113035.GD3287@implementation.labri.fr> <20070823163318.GB5528@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070823163318.GB5528@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Greg KH, le Thu 23 Aug 2007 09:33:18 -0700, a écrit :
> Yes I did, sorry.  Do you have a pointer for it, all I see is these
> patches in -mm:
> 	console-keyboard-events-and-accessibility.patch

Here is the patch

> 	console-keyboard-events-and-accessibility-fix.patch
> 	console-keyboard-events-and-accessibility-fix-2.patch

These are just EXPORT_SYMBOL -> EXPORT_SYMBOL_GPL and #include fixes.

> > > The patches look sane but you should change the global symbols to play
> > > nicer in the namespace.  Care to respin them together with this change?
> > 
> > You mean inverse_translate and screen_glyph?
> 
> Yes.  Also, things like "register_keyboard_notifier" should be
> "keyboard_register_notifer", trying to keep everything in the
> "keyboard*" namespace to make things a bit easier overall[1].

Ok.

> > Well, the biggest problem is that we'd like to output on serial _before_
> > /dev gets mounted.
> 
> As we can do this today with the console layer (think boot consoles over
> serial and network and even USB), it should not be that tough.  Just be
> an early console yourself also.

Yes, that's on the plan too, but in some cases (like braille devices),
the driver needs to read from the port too, which is not provided by
early consoles.

> > > It doesn't look like these changes handle scrolling of the console, do
> > > they?
> > 
> > Ah, indeed, speakup doesn't seem to handle it, that's why I forgot it in
> > the patch.  I'll see what needs to be done.
> 
> Does speakup need to handle it?

I don't know exactly, but most probably yes, because else the cursor
position gets wrong.

> Also, we really would like to see the users of these hooks (meaning the
> speakup drivers) go into the tree at the same time the hooks do, as we
> don't like hooks with no users in the kernel.

OK.  Having my patches in the -mm tree for just some review time is
fine: at least we know that the way they're done is ok for people (or
else we're told how to fix them).

> I know the speakup code needs a lot of work to bring it up to
> kernel-acceptance level.  Has this work been done, or is it happening?

It is happening.

> If you need help in this area, I can see about doing a bit as I did a
> lot of cleanup of this codebase a few years ago.  I also know of a few
> users who are willing to help test this stuff out.

Oh, great!  Maybe Kirk should be contacted so he gives access to the git
tree of speakup.

Samuel
