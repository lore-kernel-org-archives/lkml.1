Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYHUCNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYHUCNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYHUCNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:13:06 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:22988 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbYHUCNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:13:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAAxsrEh5LD0w/2dsb2JhbAC1ZIFZ
X-IronPort-AV: E=Sophos;i="4.32,243,1217773800"; 
   d="scan'208";a="175981629"
Date: Thu, 21 Aug 2008 12:12:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Szabolcs Szakacsits <szaka@ntfs-3g.org>, konishi.ryusuke@lab.ntt.co.jp,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
Message-ID: <20080821021259.GA5706@disturbed>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Szabolcs Szakacsits <szaka@ntfs-3g.org>,
	konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080820004326.519405a2.akpm@linux-foundation.org> <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808202352450.4532@dhcppc2> <20080820143916.1a7eddab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820143916.1a7eddab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 02:39:16PM -0700, Andrew Morton wrote:
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
> err, what the heck happened to xfs?  Is this usual?

No, definitely not usual. I suspect it's from an old mkfs and
barriers being used.  What is the output of the xfs.mkfs when
you make the filesystem and what mount options being used?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
