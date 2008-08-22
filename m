Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbYHVCZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbYHVCZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbYHVCZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:25:08 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:53010 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471AbYHVCZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:25:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMDAMC2rUh5LD0wiGdsb2JhbACSIAEBAQ8gpEWBaA
X-IronPort-AV: E=Sophos;i="4.32,248,1217773800"; 
   d="scan'208";a="177029559"
Date: Fri, 22 Aug 2008 12:24:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080822022459.GL5706@disturbed>
Mail-Followup-To: Szabolcs Szakacsits <szaka@ntfs-3g.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808202352450.4532@dhcppc2> <20080820143916.1a7eddab.akpm@linux-foundation.org> <20080821021259.GA5706@disturbed> <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net> <20080821051508.GB5706@disturbed> <20080821060418.GC5706@disturbed> <20080821082532.GE5706@disturbed> <Pine.LNX.4.61.0808211447060.4532@dhcppc2> <Pine.LNX.4.61.0808212031050.4532@dhcppc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0808212031050.4532@dhcppc2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 08:33:50PM +0300, Szabolcs Szakacsits wrote:
> 
> On Thu, 21 Aug 2008, Szabolcs Szakacsits wrote:
> > On Thu, 21 Aug 2008, Dave Chinner wrote:
> > > On Thu, Aug 21, 2008 at 04:04:18PM +1000, Dave Chinner wrote:
> > > > 
> > > > One thing I just found out - my old *laptop* is 4-5x faster than the
> > > > 10krpm scsi disk behind an old cciss raid controller.  I'm wondering
> > > > if the long delays in dispatch is caused by an interaction with CTQ
> > > > but I can't change it on the cciss raid controllers. Are you using
> > > > ctq/ncq on your machine?  
> > 
> > It's a laptop and has NCQ. It makes no difference if NCQ is enabled or 
> > disabled. The problem seems to be XFS only.
> 
> The 'nobarrier' mount option made a big improvement:
> 
>                     MB/s    Runtime (s)
>                    -----    -----------
>   btrfs unstable   17.09        572
>   ext3             13.24        877
>   btrfs 0.16       12.33        793
>   nilfs2 2nd+ runs 11.29        674
>   ntfs-3g           8.55        865
>   reiserfs          8.38        966
>   xfs nobarrier     7.89        949
>   nilfs2 1st run    4.95       3800
>   xfs               1.88       3901

INteresting. Barriers make only a little difference on my laptop;
10-20% slower. But yes, barriers will have this effect on XFS.

If you've got NCQ, then you'd do better to turn off write caching
on the drive, turn off barriers and use NCQ to give you back the
performance that the write cache used to. That is, of course,
assuming the NCQ implementation doesn't suck....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
