Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYIOIVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYIOIVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 04:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYIOIVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 04:21:42 -0400
Received: from phunq.net ([64.81.85.152]:39479 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750874AbYIOIVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 04:21:41 -0400
From: Daniel Phillips <phillips@phunq.net>
To: tux3@tux3.org
Subject: Tux3 Report: What next?
Date: Mon, 15 Sep 2008 01:21:39 -0700
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809150121.39672.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

It's been a busy week with all the checkins.  Not all of them from me!
And Tux3 university, which seems to be going quite well.  For the next
session (Tuesday, 8 p.m. pacific time on irc.oftc.net #tux3) the theme
will be: VFS read and write.  Yes, that's all, and it's a lot.

So getting xattrs working took a week, and it was quite a week with all
the design introspection about atoms and such.  In the end, the design
came out really nice and I guess we are going to be able to go with our
hoped for no-compromise solution: we translate xattr names into atoms
and refcount the atoms persistently, and do it all at close to the
speed we would get from just storing the xattr names as ascii strings,
per inode.  According to my calculations anyway.  We will have to wait
for something closer to production code before we can really measure
it, and I am presuming that there will be a little more work done to
put a simple cache, like a hash table, in front of the atom machinery.

An unexpected spinoff benefit of the atom work is, we now have a really
nice generic mechanism for implementing de-duplication, which work will
be attempted by an enthusiastic team of volunteers, as a university
project.  I expect we will hear more on that soon.

Now that question again: what next?  Big items still outstanding to
get to proof of concept:

 1) Atomic commit
 2) Versioning
 3) Extents
 4) Kernel port

The kernel port is underway, it started yesterday when Maciej decided
to barge in and implement his "junkfs", which as I understand it, is
fearlessly attempting to load a superblock at the moment.  Not one to
be left behind, I checked in a stub Tux3 filesystem to a new Git repo,
which I hope is going to become a real Tux3 filesystem in the not too
distant future:

   http://phunq.net/tux3fs/

And our fuse porters have been busy, with xattr support checked in by
Tero, mere hours after my first shaky prototype landed.  Well, I am so
happy with the way things are going in userspace that I plan to stay
there a while longer.  It is pretty much a coin toss which of the three
non-kernel projects to jump into, so I choose versioning.  Versioning
is, after all, the main reason this project exists.

In other news, it is getting close to Halloween, and that means getting
close to Tux3 Cabal party time.  More on that later.  As always,
everyone is welcome to jump in and join the development party, it's
fun:

   http://tux3.org/

Regards,

Daniel
