Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbYHUGEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbYHUGEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYHUGEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:04:37 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:19939 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494AbYHUGEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:04:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAAShrEh5LD0w/2dsb2JhbAC1NIFm
X-IronPort-AV: E=Sophos;i="4.32,243,1217773800"; 
   d="scan'208";a="176211865"
Date: Thu, 21 Aug 2008 16:04:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080821060418.GC5706@disturbed>
Mail-Followup-To: Szabolcs Szakacsits <szaka@ntfs-3g.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <20080820004326.519405a2.akpm@linux-foundation.org> <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808202352450.4532@dhcppc2> <20080820143916.1a7eddab.akpm@linux-foundation.org> <20080821021259.GA5706@disturbed> <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net> <20080821051508.GB5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821051508.GB5706@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 03:15:08PM +1000, Dave Chinner wrote:
> On Thu, Aug 21, 2008 at 05:46:00AM +0300, Szabolcs Szakacsits wrote:
> > On Thu, 21 Aug 2008, Dave Chinner wrote:
> > Everything is default.
> > 
> >   % rpm -qf =mkfs.xfs
> >   xfsprogs-2.9.8-7.1 
> > 
> > which, according to ftp://oss.sgi.com/projects/xfs/cmd_tars, is the 
> > latest stable mkfs.xfs. Its output is
> > 
> > meta-data=/dev/sda8              isize=256    agcount=4, agsize=1221440 blks
> >          =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=4885760, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096  
> > log      =internal log           bsize=4096   blocks=2560, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=0
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Ok, I thought it might be the tiny log, but it didn't improve anything
> here when increased the log size, or the log buffer size.

One thing I just found out - my old *laptop* is 4-5x faster than the
10krpm scsi disk behind an old cciss raid controller.  I'm wondering
if the long delays in dispatch is caused by an interaction with CTQ
but I can't change it on the cciss raid controllers. Are you using
ctq/ncq on your machine?  If so, can you reduce the depth to
something less than 4 and see what difference that makes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
