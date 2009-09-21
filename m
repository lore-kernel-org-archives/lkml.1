Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbZIUX4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbZIUX4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 19:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbZIUX43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 19:56:29 -0400
Received: from mail2.shareable.org ([80.68.89.115]:50449 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbZIUX42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 19:56:28 -0400
Date: Tue, 22 Sep 2009 00:56:15 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
Subject: Re: fanotify as syscalls
Message-ID: <20090921235615.GK14700@shareable.org>
References: <20090912094110.GB24709@ioremap.net> <200909212327.20978.agruen@suse.de> <20090921220002.GE14700@shareable.org> <200909220109.05995.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909220109.05995.agruen@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Gruenbacher wrote:
> If the antimalware vendors want to base their decisions on pathnames then 
> that's their decision, and they can check /proc/self/fd/N.

Race hazards and loopholes.  It doesn't work.

> Waiting for your code to demonstrate; an object based cache (e.g.,
> st_dev + st_ino) rather than a pathname based cache would seem more
> reasonable.

Nearly everything that people do with files involves paths.  The point
is to cache what people (or their programs) do.  Apache does not
consult inodes by number, and rsync does not write inodes by number :-)
Yes, to the code...

> > > but I see no need for access decisions on them.
> >
> > Please excuse me; I'm a bit confused.  Is fanotify intended just for
> > use by access decision programs, or is the plan now for it to also be
> > a replacement for inotify?  I'm getting conflicting signals about
> > that.
> 
> Inotify doesn't support access decisions. So where's the problem with 
> having "notify only" events for directory / mount / unmount events?

No problem here.

You seemed to be saying you want to add directory events to fanotify.
But if fanotify is only intended for access decisions?  Something I
must have misunderstood in that.

> > If it's just for access decision programs, and if those aren't going
> > to care about location, then there's no need to add directory events
> > to fanotify at all.  But then I'll be demanding subtree support in
> > inotify, please :-)
> >
> > > Even less so for mounts and unmounts.
> >
> >    (as root) mkdir foo; mount dodgy foo -oloop; mount --bind foo/cat
> > /bin/cat
> 
> ... and then someone accesses /bin/cat, which triggers a fanotify access 
> decision.

That's fine as long as there was no location-awareness in the logic
which checked foo/innocent.txt and set that inode's "read-ok,cache-me" bit.

Mount only matters if you're sensitive to location.  If you think
location-independent checks make good anti-malware
I_have_a_bridge_to_sell^H^H^H^H^H^H^H^H^H^H^Hfine with me :-)

-- Jamie
