Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYHURb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYHURb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYHURbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:31:19 -0400
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:56517 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYHURbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:31:18 -0400
Date: Thu, 21 Aug 2008 20:33:50 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc2
To: Dave Chinner <david@fromorbit.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
 snapshotting file system)
In-Reply-To: <Pine.LNX.4.61.0808211447060.4532@dhcppc2>
Message-ID: <Pine.LNX.4.61.0808212031050.4532@dhcppc2>
References: <20080820004326.519405a2.akpm@linux-foundation.org>
 <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808202352450.4532@dhcppc2>
 <20080820143916.1a7eddab.akpm@linux-foundation.org> <20080821021259.GA5706@disturbed>
 <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net> <20080821051508.GB5706@disturbed>
 <20080821060418.GC5706@disturbed> <20080821082532.GE5706@disturbed>
 <Pine.LNX.4.61.0808211447060.4532@dhcppc2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 Aug 2008, Szabolcs Szakacsits wrote:
> On Thu, 21 Aug 2008, Dave Chinner wrote:
> > On Thu, Aug 21, 2008 at 04:04:18PM +1000, Dave Chinner wrote:
> > > 
> > > One thing I just found out - my old *laptop* is 4-5x faster than the
> > > 10krpm scsi disk behind an old cciss raid controller.  I'm wondering
> > > if the long delays in dispatch is caused by an interaction with CTQ
> > > but I can't change it on the cciss raid controllers. Are you using
> > > ctq/ncq on your machine?  
> 
> It's a laptop and has NCQ. It makes no difference if NCQ is enabled or 
> disabled. The problem seems to be XFS only.

The 'nobarrier' mount option made a big improvement:

                    MB/s    Runtime (s)
                   -----    -----------
  btrfs unstable   17.09        572
  ext3             13.24        877
  btrfs 0.16       12.33        793
  nilfs2 2nd+ runs 11.29        674
  ntfs-3g           8.55        865
  reiserfs          8.38        966
  xfs nobarrier     7.89        949
  nilfs2 1st run    4.95       3800
  xfs               1.88       3901

	Szaka
 
-- 
NTFS-3G:  http://ntfs-3g.org
