Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZFHTok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZFHTok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbZFHTob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:44:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50284 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbZFHToa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:44:30 -0400
Date: Mon, 8 Jun 2009 12:44:04 -0700
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jblunck@suse.de, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Message-ID: <20090608194404.GC4363@fsbox>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <E1M6LvU-0000mN-HN@pomaz-ex.szeredi.hu> <20090519172327.GB722@shell> <E1M6hjr-00032A-EX@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M6hjr-00032A-EX@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 11:05:27AM +0200, Miklos Szeredi wrote:
> On Tue, 19 May 2009, Valerie Aurora wrote:
> > As Jan said, readdir() of read-only unioned file systems works with a
> > tmpfs top layer.  If you think about it, this is the exact equivalent
> > of the version of union mounts which used the in-kernel caching
> > approach - except that it's better, because it reuses existing code
> > and caches between readdir() calls.  Cool, huh?
> 
> Yeah... OTOH tmpfs is probably a way too heavyweight solution for
> cases where memory is short, and union mounts would typically be used
> on such systems.

(Sorry for the delay - I've been on vacation.)

Hm, my intuition is that a tmpfs mount would be fairly lightweight in
terms of memory - the main overhead over the barebones solution would
be one superblock and vfsmount struct per mount.  What am I missing?

> The big reason why kernel impementation of readdir is hard is that
> unswappable kernel memory needs to be used for caching directory
> contents while the directory is open.  Well, tmpfs does the same,
> dentries and inodes are _not_ swappable, and they gobble up memory.

That's a good point.  It seemed to me that it wouldn't be too
difficult to make those entries evictable - drop a reference count and
set the ->d_release to mark the directory as needing rebuilding.  What
do you think?

> So where's the advantage over implementing a thin deduplicating and
> caching layer for union mounts?
> 
> Thanks,
> Miklos

-VAL
