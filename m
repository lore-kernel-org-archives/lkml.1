Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbYHTVtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbYHTVtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYHTVs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:48:58 -0400
Received: from tamago.serverit.net ([91.189.209.155]:52094 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752793AbYHTVs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:48:57 -0400
Date: Thu, 21 Aug 2008 00:48:45 +0300 (EEST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@tamago.serverit.net
To: Andrew Morton <akpm@linux-foundation.org>
cc: konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
In-Reply-To: <20080820143916.1a7eddab.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.62.0808210044050.25448@tamago.serverit.net>
References: <20080820004326.519405a2.akpm@linux-foundation.org>
 <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808202352450.4532@dhcppc2>
 <20080820143916.1a7eddab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 20 Aug 2008, Andrew Morton wrote:
> On Thu, 21 Aug 2008 00:25:55 +0300 (MET DST)
> Szabolcs Szakacsits <szaka@ntfs-3g.org> wrote:
> 
> > 
> > On Thu, 21 Aug 2008, Ryusuke Konishi wrote:
> > > >> Some impressive benchmark results on SSD are shown in [3],
> > > >
> > > >heh.  It wipes the floor with everything, including btrfs.
> > 
> > It seems the benchmark was done over half year ago. It's questionable how 
> > relevant today the performance comparison is with actively developed file 
> > systems ...
> > 
> > > >But a log-based fs will do that, initially.  What will the performace
> > > >look like after a month or two's usage?
> > > 
> > > I'm using NILFS2 for my home directory for serveral months, but so far
> > > I don't feel notable performance degradation. 
> > 
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
> err, what the heck happened to xfs?  Is this usual?

vmstat typically shows that xfs does ... "nothing". It uses no CPU time and 
doesn't wait for I/O either. 

	Szaka

--
NTFS-3G:  http://ntfs-3g.org

