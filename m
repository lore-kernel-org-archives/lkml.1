Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYIPNiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYIPNiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 09:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYIPNip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 09:38:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41578 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYIPNio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 09:38:44 -0400
Date: Tue, 16 Sep 2008 09:38:18 -0400
From: Chris Mason <chris.mason@oracle.com>
To: konishi.ryusuke@lab.ntt.co.jp
Cc: pavel@suse.cz, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/27] nilfs2: add document
Message-ID: <20080916133818.GA7472@think.oraclecorp.com>
References: <1221419304-18572-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <20080915095427.GA1861@elf.ucw.cz> <20080916.051041.110880811.ryusuke@osrg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916.051041.110880811.ryusuke@osrg.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 05:10:41AM +0900, konishi.ryusuke@lab.ntt.co.jp wrote:
> Hi!
> 
> On Mon, 15 Sep 2008 11:54:27 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > +NILFS2 is a log-structured file system (LFS) supporting continuous
> > > +snapshotting.  In addition to versioning capability of the entire file
> > > +system, users can even restore files mistakenly overwritten or
> > 
> > Hmm, undelete done right. Just one question... how slow/fast is it
> > compared to conventional filesystems (ext3?)?
> > 								Pavel
> 
> After my first submission, Szabolcs Szakacsits showed benchmark
> results using compilebench.
> 
> On Thu, 21 Aug 2008 00:25:55 +0300 (MET DST)
> Szabolcs Szakacsits <szaka@ntfs-3g.org> wrote:
> > I ran compilebench on kernel 2.6.26 with freshly formatted volumes.
> > The behavior of NILFS2 was interesting.
> >
> > Its peformance rapidly degrades to the lowest ever measured level
> > (< 1 MB/s) but after a while it recovers and gives consistent numbers.
> > However it's still very far from the current unstable btrfs performance.
> > The results are reproducible.
> >
> >                     MB/s    Runtime (s)
> >                    -----    -----------
> >   btrfs unstable   17.09        572
> >   ext3             13.24        877
> >   btrfs 0.16       12.33        793
> >   nilfs2 2nd+ runs 11.29        674
> >   ntfs-3g           8.55        865
> >   reiserfs          8.38        966
> >   nilfs2 1st run    4.95       3800
> >   xfs               1.88       3901
> 
> Accordint to his measurement, NILFS2 showed a very low performance
> on the first measument, and it recovered after a while.
> 
> I still don't know the reason why NILFS2 shows such behaviour, and
> I'm thinking to follow the benchmark.

Normally, compilebench has read phases that time how quickly the FS can
read the files after a bunch of operations.  The runs above didn't
include the read phase, but in order to be fair to all the filesystems,
compilebench figures out the native readdir order of the FS so it can
create files in the optimal order for each fs.

It does this by creating all the files in its datasets and using readdir
to find out what order the FS returns.  The files are all deleted
and the real runs start.

It is possible that bad perf in the first compilebench run is from
cleanup or transaction commits being done after the deletions.

-chris
