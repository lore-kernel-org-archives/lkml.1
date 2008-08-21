Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYHUCq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYHUCq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYHUCqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:46:14 -0400
Received: from tamago.serverit.net ([91.189.209.155]:45620 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752725AbYHUCqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:46:13 -0400
Date: Thu, 21 Aug 2008 05:46:00 +0300 (EEST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@tamago.serverit.net
To: Dave Chinner <david@fromorbit.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
In-Reply-To: <20080821021259.GA5706@disturbed>
Message-ID: <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net>
References: <20080820004326.519405a2.akpm@linux-foundation.org>
 <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808202352450.4532@dhcppc2>
 <20080820143916.1a7eddab.akpm@linux-foundation.org> <20080821021259.GA5706@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 Aug 2008, Dave Chinner wrote:
> On Wed, Aug 20, 2008 at 02:39:16PM -0700, Andrew Morton wrote:
> > On Thu, 21 Aug 2008 00:25:55 +0300 (MET DST)
> > Szabolcs Szakacsits <szaka@ntfs-3g.org> wrote:
> > > I ran compilebench on kernel 2.6.26 with freshly formatted volumes. 
> > > The behavior of NILFS2 was interesting.
> > > 
> > > Its peformance rapidly degrades to the lowest ever measured level 
> > > (< 1 MB/s) but after a while it recovers and gives consistent numbers.
> > > However it's still very far from the current unstable btrfs performance. 
> > > The results are reproducible.
> > > 
> > >                     MB/s    Runtime (s)
> > >                    -----    -----------
> > >   btrfs unstable   17.09        572
> > >   ext3             13.24        877
> > >   btrfs 0.16       12.33        793
> > >   nilfs2 2nd+ runs 11.29        674
> > >   ntfs-3g           8.55        865
> > >   reiserfs          8.38        966
> > >   nilfs2 1st run    4.95       3800
> > >   xfs               1.88       3901
> > 
> > err, what the heck happened to xfs?  Is this usual?
> 
> No, definitely not usual. I suspect it's from an old mkfs and
> barriers being used.  What is the output of the xfs.mkfs when
> you make the filesystem and what mount options being used?

Everything is default.

  % rpm -qf =mkfs.xfs
  xfsprogs-2.9.8-7.1 

which, according to ftp://oss.sgi.com/projects/xfs/cmd_tars, is the 
latest stable mkfs.xfs. Its output is

meta-data=/dev/sda8              isize=256    agcount=4, agsize=1221440 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=4885760, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

Kernel xfs log:

SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sda8
Ending clean XFS mount for filesystem: sda8

	Szaka

--
NTFS-3G:  http://ntfs-3g.org

