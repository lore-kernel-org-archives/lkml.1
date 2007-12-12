Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbXLLXqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbXLLXqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 18:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXLLXqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 18:46:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbXLLXqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 18:46:43 -0500
Date: Wed, 12 Dec 2007 18:46:40 -0500
From: Dave Jones <davej@redhat.com>
To: Peter Stahlir <peter.stahlir@googlemail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux kernel history from 0.0.1
Message-ID: <20071212234640.GA452@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Stahlir <peter.stahlir@googlemail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <fbe8b1780712121410u41517699v6e0b991d1a262ffd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbe8b1780712121410u41517699v6e0b991d1a262ffd@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 11:10:05PM +0100, Peter Stahlir wrote:

 > I know the git tree of linux kernel up to version 1.0:
 > git://git.kernel.org/pub/scm/linux/kernel/git/nico/archive.git
 > And i am aware of the history tree from 2.5.0 to 2.6.12 at
 > http://www.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
 > 
 > Has somebody done a _complete_ git tree from version 0.0.1 until now?

For a while I've been pulling together some scripts to create
a git repo with every single ancient Linux version up to 2.4
before we had an SCM tracking commits.
(from 0.01, up to 2.4.0, including every -pre,-test and -rc along
 the way as a separate commit).

And now for the really crazy part:

    With actual changelogs for as many commits as possible.

This seemed like a fun idea at first, then about a third the way through
I began to think this was nuts.  At halfway, I'd decided I'd gone too far
to not finish it, and this is the result.   There's still a lot of
un-changelogged commits, but I've sat on this for about a month
making slow further progress. (It's getting harder to find changelogs)

About halfway through, in September of 2007, someone called
'Gonsolo' did something similar to all this.  [http://lwn.net/Articles/250699/]
Though his version lacked changelogs, and missed a ton of prepatches.
It was also around this time, I found that I'm not the only person loony
enough to attempt this, and stumbled across
 git://git.kernel.org/pub/scm/linux/kernel/git/nico/archive.git
Nico's archive had some bits I missed, and there were some bits
in his that I had got, so where possible, I stole some of his changelogs.
I think my variant is as complete as we're going to get.
(modulo new arrivals of missing changelogs: read below)

I only went as far as 2.4.0, because we have a git tree of 2.4.x already.
Should someone be so motivated, grafting it (and/or linus' tree
to get 2.5/2.6) onto this tree shouldn't be too much effort.

The whole process takes about 90 minutes to unpack/create 36G of
kernel trees, create interdiffs between them all, and then import
them into a git tree on a pretty speedy core2 duo, with two raid0
disks (and boy, is this operation IO bound).

Some other stats:
 - commits: 1040
 - commits with changelogs: 420
 - repo size  1.9G.  (git-repack shrinks this to a mere 78M)

The repository can be found at
 git://git.kernel.org/pub/scm/linux/kernel/git/davej/history.git 

Each time a new development tree was forked, I created
a branch for the stable series to continue on.
It looks something like..

[master] 0.x-----1.1---1.3---2.1---2.3
          \      \     \     \
           1.0    1.2   2.0   2.2

Recreating a complete history of the Linux kernel is something
of a challenge.

* Some versions are missing, presumed lost forever.
- Riley Williams (RIP) kept a log of these at
  http://ftp.cdut.edu.cn/pub/linux/kernel/history/lka-001.html
- Several missing versions that weren't on kernel.org were found at
  http://www.linuxgrill.com/anonymous/kernel/Archive/historic/
  ftp://ftp.lublin.pl/vol/1/alan/Software/Obsolete/Old-Kernel/
  Some pre-patches were also pulled from early Linux kernel archives where
  no other form for that version existed.
- Sadly some early releases seem lost to the sands of time, even though
  I managed to dig up changelogs for them. (The final 0.96 release for example).
- Even amongst pre-patches, we seem to have lost a few along the way.
  2.3.36 has prepatches 1 2 3 5 and 6 for example. pre4 is nowhere to be found.

* Some patches needed to be hand edited.
- linux-0.96a.patch1 doesn't seem to exist online in a non whitespace damaged form,
  so I had to recreate it by hand.
  Thankfully interdiffs were a lot smaller back in 1992.
- linux-0.97.patch5 doesn't apply on top of patch4.
  The Makefile fragment that changes CC neglects to note that the previous version
  had $(PROFILING) at the end of the line.
- 2.3.15pre1 tries to delete drivers/video/modedb.c, even though the file
  was never in 2.3.14
- Several other variants of the above.

* Some diffs don't seem to apply to any released tree (including pre-patched ones).
  In some cases, I was able to fix this up, by removing a single bogus hunk,
  but some (like 2.0.34pre13 & pre14 don't make any sense at all --
   It's possible they were incrementals against the missing 2.0.34pre12)

* Where a tarball exists, it was used rather than patching from the previous version.
  This was done due to what I believe are a combination of bugs in diff(1) at
  the time the patches were being created, and/or possibly bugs in patch(1) currently
  preventing these diffs from applying.

* It's not clear what exactly happened around 2.2.0pre1
  patch-2.2.0-pre1 is diffed against 2.1.132, yet there exists
  five 2.1.133 prepatches (although only 4 have been found).
  For the git tree, I've created a history that looks like..
  .132 .133-1 .133-3 .133-4 .133-5 2.2.0pre1

* diff(1) seems to have some odd 'features'.
  2.4.0test3pre3 has a hunk that adds mm/vmscan.c
  However, this file has been there since 1.3.57
  I converted this hunk to a vmscan.c, dropped it into the
  tree and diffed from test3pre2 to find the real differences.
  Seems to have done the right thing.  

* Changelog entries.
- Early entries came from:
  - Linus' notes at http://linus.bkbits.net:8080/linux-historic/?PAGE=changes
  - Some culled from Linux-activists
- Some later changelogs from:
  - Linux-kernel archives
    (special thanks to uswg for sending me ancient mboxes to grep through)
    Sadly there doesn't seem to be any online archives of the period between
    Linux-activists ending in 1993 and Linux Kernel from 1998. Anyone?
    (I find it amazing that five whole years of history have disappeared
     from the net).
  - Where changelogs were missing/never announced, I tried to piece
    together some interesting changelog fodder from relevant discussions
    from around the time.  Ah, nostalgia.
  - Later changelogs came from various sites such as lwn & linuxtoday,
    and assorted sites that google turned up.
- Many of the changelogs that did get created by Linus/Alan are still MIA.
  Entries without changelogs show up in git as something
  like 'Import 2.5.5.'
  If you find changelogs for entries that don't have them,
  please forward, and I'll recreate history.
- Some of them were reformatted, or slightly edited to
  do things like s/me/Alan Cox/ or s/me/Linus Torvalds/ where
  applicable.

* Attributions.
  All commits are done with a committer and author git id of
  "Linus Torvalds", except for the stable kernels which were
  set to "Alan Cox" or "David Weinehall" etc where applicable.

	Dave

-- 
http://www.codemonkey.org.uk
