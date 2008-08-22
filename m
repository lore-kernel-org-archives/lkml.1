Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbYHVMmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbYHVMmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYHVMmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:42:03 -0400
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:43179 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbYHVMmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:42:00 -0400
Date: Fri, 22 Aug 2008 15:44:29 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc2
To: Dave Chinner <david@fromorbit.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
 snapshotting file system)
In-Reply-To: <20080822022459.GL5706@disturbed>
Message-ID: <Pine.LNX.4.61.0808221519000.4532@dhcppc2>
References: <200808201613.AA00212@capsicum.lab.ntt.co.jp>
 <Pine.LNX.4.61.0808202352450.4532@dhcppc2> <20080820143916.1a7eddab.akpm@linux-foundation.org>
 <20080821021259.GA5706@disturbed> <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net>
 <20080821051508.GB5706@disturbed> <20080821060418.GC5706@disturbed>
 <20080821082532.GE5706@disturbed> <Pine.LNX.4.61.0808211447060.4532@dhcppc2>
 <Pine.LNX.4.61.0808212031050.4532@dhcppc2> <20080822022459.GL5706@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 22 Aug 2008, Dave Chinner wrote:
> On Thu, Aug 21, 2008 at 08:33:50PM +0300, Szabolcs Szakacsits wrote:
>
> > The 'nobarrier' mount option made a big improvement:
> 
> INteresting. Barriers make only a little difference on my laptop;
> 10-20% slower. But yes, barriers will have this effect on XFS.
> 
> If you've got NCQ, then you'd do better to turn off write caching
> on the drive, turn off barriers and use NCQ to give you back the
> performance that the write cache used to. That is, of course,
> assuming the NCQ implementation doesn't suck....

Write cache off, nobarrier and AHCI NCQ lowered the XFS result:

                               MB/s    Runtime (s)
                              -----    -----------
  btrfs unstable              17.09        572
  ext3                        13.24        877
  btrfs 0.16                  12.33        793
  ntfs-3g unstable            11.52        673
  nilfs2 2nd+ runs            11.29        674
  reiserfs                     8.38        966
  xfs nobarrier                7.89        949
  nilfs2 1st run               4.95       3800
  xfs nobarrier, ncq, wc off   3.81       1973
  xfs                          1.88       3901

	Szaka

-- 
NTFS-3G:  http://ntfs-3g.org

