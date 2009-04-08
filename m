Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbZDHAim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbZDHAim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 20:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbZDHAid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 20:38:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46890 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZDHAic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 20:38:32 -0400
Subject: Re: [PATCH -V2 02/13] fsnotify: unified filesystem notification
 backend
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org
In-Reply-To: <20090407160555.e5881481.akpm@linux-foundation.org>
References: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
	 <20090327200515.32007.53032.stgit@paris.rdu.redhat.com>
	 <20090407160555.e5881481.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 20:37:28 -0400
Message-Id: <1239151048.27468.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 16:05 -0700, Andrew Morton wrote:
> On Fri, 27 Mar 2009 16:05:15 -0400
> Eric Paris <eparis@redhat.com> wrote:
> 
> > fsnotify paves the way for fanotify.
> 
> It'd kinda help if the changelog were to tell us what fanotify is.

In the next patch I'm sorta inclined to drop all reference to fanotify
since any hint of fanotify/TALPA/anti-malware puts a bad taste in
people's mouth.  This patch set is by itself an improvement.  It gives
us a wonderful plugin mechanism I can use to build fanotify (the
mechanism in fsnotify is based on the old fanotify code.  Using
foundation I do all fanotify implementation in less than 1100 lines) but
we aren't committing to anything.  These 13 patches (plus a couple more
for audit) should be taken on their own.  They stand alone as an
improvement.

But I'll explain fanotify right here.  fanotify is different for 2 main
reasons.  1) There isn't the huge race between the event and the
notification.  When an "event" is given to an fanotify listener it comes
with a magically opened file descriptor in the context of the listener.
With inotify I either have to keep the fd open for everything I'm
listening to or watch the parent directory and based on the name in the
inotify event try to open the file in question some time after the
original open.  By that time the file could have been moved, deleted, or
who knows what.

2) inotify and dnotify are both based on naming the couple of specific
files or directories you care about.  fanotify is about giving you every
single event on the system and letting you instead descript what you do
NOT care about.

I've got 3 users for fanotify.  The first user is the AV community.  The
ones who pushed hard enough that I'm writing all of this.  But we have 2
other users who are interested.

boot profiling: they currently get open/close/read/write type info by
hijacking audit.  fanotify fits perfectly.

the desktop search/filesystem indexer group has also expressed interest
http://lkml.org/lkml/2009/3/27/166 and it's simple to do what they want.

> I'm inclined to merge this patch series if only to get us an
> inotify/dnotify maintainer ;)

That's in here, and we actually have an inotify patch floating in the
ether I'm going to just stick into this series to see if anyone
notices....   :)

> General comment on the patches: complex.  I found them depressingly
> hard to understand (and hence review) - the lack of high-level
> commentary in the code is pretty severe.  There's a nice-looking design
> document there, but like everyone else, I didn't look at it much ;)
> It's not really a successful substitute for carefully-chosen comments
> at the appropriate codesites and data structures.

I'll make another pass based on your comments to the rest of the series
and try to throw more random comments even when you didn't ask.  I
realize I need to make it accessible to more than just Al.

-Eric

