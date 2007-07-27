Return-Path: <linux-kernel-owner+w=401wt.eu-S937293AbXG0RZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937293AbXG0RZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbXG0RY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:24:59 -0400
Received: from mail.fieldses.org ([66.93.2.214]:55737 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbXG0RY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:24:58 -0400
Date: Fri, 27 Jul 2007 13:24:52 -0400
To: Michael Tharp <gxti@partiallystapled.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, Douglas J Hunley <doug@hunley.homeip.net>,
       slocate@trakker.ca, linux-kernel@vger.kernel.org
Subject: Re: solving(?) the updatedb problem w/ the kernel cache
Message-ID: <20070727172452.GD13965@fieldses.org>
References: <200707270855.26997.doug@hunley.homeip.net> <2c0942db0707270942k784890a2ld44d1312dde02379@mail.gmail.com> <46AA26B9.7050904@partiallystapled.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AA26B9.7050904@partiallystapled.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 01:09:13PM -0400, Michael Tharp wrote:
> Ray Lee wrote:
> > But yes, if we had a full filesystem events notifier, then we could
> > just toss updatedb aside and have the benefit of a live index into the
> > system. It's been suggested before, at least by me. Other projects
> > want this as well, such as an on-demand virus scanner, or a live
> > backup to another site, or beagle/tracker who would like to index
> > documents on the fly. beagled already uses inotify, I think, but as it
> > takes over my system (in a bad way) whenever I tried to run it, I had
> > no choice but to remove it.
> 
> Beagle's problem is that it inspects the file contents, often far too
> closely. I, too, had to uninstall it after it started indexing 40GB raw
> huffyuv video files (probably treating them as text) and driving load
> averages through the roof. Just watching for structure changes won't be
> nearly as painful, assuming inotify can handle watching the entire
> filesystem tree.

Events notification only helps while you've got someone around to listen
to the events.  If you reboot (or even just log out?  I don't know),
then when you come back the only completely reliable way to find out
what's changed may be to re-read everything.

So I'd think that far more important and basic than events notification
would be ways to reliably tell when a file have changed by looking just
at the attributes.

You can just use everything that "stat" gives you and figure that if a
file is still at the same path, with the same ctime, mtime, size,
permissions, owner, inode number, etc., then it's probably the same
file.

If that's not enough, then maybe you want a change attribute (that's
guaranteed to change even when changes happen within less than the
granularity of ctime), and generation number (that's bumped whenever an
inode number is reused).

--b.
