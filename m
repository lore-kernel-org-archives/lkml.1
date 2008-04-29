Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbYD2WLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbYD2WLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbYD2WLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:11:14 -0400
Received: from mail.fieldses.org ([66.93.2.214]:51842 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757953AbYD2WLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:11:13 -0400
Date: Tue, 29 Apr 2008 18:11:07 -0400
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       willy@debian.org, viro@zeniv.linux.org.uk,
       uclinux-dist-devel@blackfin.uclinux.org, richterd@citi.umich.edu
Subject: Re: [LTP/VFS] fcntl SETLEASE fails on ramfs/tmpfs
Message-ID: <20080429221107.GH26468@fieldses.org>
References: <386072610804282042y2dda4b52h927683a8a938ce1f@mail.gmail.com> <20080429135454.efebec8f.akpm@linux-foundation.org> <20080429214231.GC26468@fieldses.org> <8bd0f97a0804291501i2751d688h933508df2a4587b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0804291501i2751d688h933508df2a4587b4@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 06:01:47PM -0400, Mike Frysinger wrote:
> On Tue, Apr 29, 2008 at 5:42 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> >  The one thing I suspect is *not* a really serious problem here is the
> >  reported LTP failure, since probably the only user of this is Samba,
> >  which probably doesn't do a lot of tmpfs exports, and in any case it can
> >  probably soldier on (if with degraded performance--how badly I don't
> >  know) without getting the write lease it wants.
> 
> i'm not sure i follow.  the reported problem is that file locking does
> not work on tmpfs/ramfs storage.  a not terribly uncommon scenario is
> to use tmpfs on /tmp (or similar location) and have file locking not
> work at all.  so programs that use file locking or scripts that
> leverage the flock utility from the util-linux package break.

There are three different mechanisms that might be called "file locks":

	- fcntl() locks, aka "posix locks", "byte-range locks":
	  documented in the "Advisory locking" section of fcntl(2).
	- flock() locks: documented in flock(2) This is what the shell
	  utility from util-linux uses.
	- leases, documented in the "Leases" section of fcntl(2).

For the former two, I agree with you, applications actually depend on
them.

The bug report, however, is for leases, which are much less widely used.
(The only users I know of are Samba and, to a lesser extent, NFSv4
(which doesn't currently use write leases due to all these problems).)

--b.
