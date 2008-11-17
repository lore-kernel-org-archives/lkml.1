Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYKQEG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYKQEG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 23:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838AbYKQEGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 23:06:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42444 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbYKQEGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 23:06:48 -0500
Date: Mon, 17 Nov 2008 04:06:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Palfrader <peter@palfrader.org>, linux-kernel@vger.kernel.org
Subject: Re: Fix broken ownership of /proc/sys/ files
Message-ID: <20081117040645.GS28946@ZenIV.linux.org.uk>
References: <20081116205922.GI28958@anguilla.noreply.org> <20081116221910.GQ28946@ZenIV.linux.org.uk> <alpine.LFD.2.00.0811161515040.9657@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811161515040.9657@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 03:23:47PM -0800, Linus Torvalds wrote:
> 
> 
> On Sun, 16 Nov 2008, Al Viro wrote:
> >
> > D'oh...
> 
> So I applied this, but I wonder if it might not be nice to make 
> new_inode() (or rather - 'alloc_inode()') initialize some more of the 
> really core members.
> 
> We already initialize a _lot_ of fields, including fields that most 
> filesystem would likely end up re-initializing when reading an inode (like 
> i_size and i_nlink). Maybe it would be more sensible to initialize 
> i_gid/uid there too, when we are guaranteed to have that cacheline dirty 
> anyway (because we're initializing everything around those fields).

*nod*

It certainly makes sense to do it in a uniform way - there's enough
users of new_inode() that want exactly that.  I'll do that as soon
as I get from under a huge pile of pending mail ;-/

ObPendingStuff: would you mind a series of section annotations?  That's
a bunch of trivial one-liners and it kills the section noise - the remaining
ones are few and tricky.  It had sat around in my tree for several weeks
and I can certainly carry it until the next cycle, but OTOH this stuff
*is* trivial and the noise is annoying as hell.
