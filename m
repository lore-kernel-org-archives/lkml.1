Return-Path: <linux-kernel-owner+w=401wt.eu-S1759882AbZCZRE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbZCZRE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbZCZRET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:04:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482AbZCZRET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:04:19 -0400
Date: Thu, 26 Mar 2009 09:53:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       mingo@elte.hu, jack@suse.cz, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
       jens.axboe@oracle.com, drees76@gmail.com, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, oleg@redhat.com, roland@redhat.com
Subject: Re: relatime: update once per day patches (was: ext3 IO latency
 measurements)
In-Reply-To: <20090326163026.GD6239@mit.edu>
Message-ID: <alpine.LFD.2.00.0903260940000.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326140312.GB14822@elte.hu>
 <20090326073013.2fa83178.akpm@linux-foundation.org> <200903261632.42439.elendil@planet.nl> <20090326084733.156c4910.akpm@linux-foundation.org> <alpine.LFD.2.00.0903260912270.3032@localhost.localdomain> <20090326163026.GD6239@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Theodore Tso wrote:
> 
> I've always thought the right approach would be to have a "atime
> dirty" flag, and update atime, but never flush it out to disk unless
> (a) we're about to unmount the disk, or (b) we need to update some
> other inode in the same inode table block, or (c) we have memory
> pressure and we're trying to evict the inode from the inode cache.

I tried to do that a few years ago (ok, probably more than a few by now).

It was surprisingly hard.

Some of it is absolutely trivial: we already have multiple "dirty" flags 
for the inode (I_DIRTY_SYNC vs I_DIRTY_DATASYNC vs I_DIRTY_PAGES). Adding 
a I_DIRTY_ATIME bit for unimportant data was trivial.

But at least back then, "sync_inode()" (or whatever) was called without 
the reason for doing the sync, so it was really hard to decide whether to 
write things out or not.

That may actually have changed these days. We now have that 
"writeback_control" thing that we pass around for all the IO.

Heh. I just looked back in the history. That writeback_control thing was 
added back in 2002, so it's a _really_ long time since I tried to do that 
whole atime thing.

Maybe it's really easy these days.

				Linus
