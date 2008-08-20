Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYHTVXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYHTVXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYHTVX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:23:26 -0400
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:55096 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYHTVXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:23:25 -0400
Date: Thu, 21 Aug 2008 00:25:55 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc2
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
In-Reply-To: <200808201613.AA00212@capsicum.lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.61.0808202352450.4532@dhcppc2>
References: <20080820004326.519405a2.akpm@linux-foundation.org>
 <200808201613.AA00212@capsicum.lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 Aug 2008, Ryusuke Konishi wrote:
> >> Some impressive benchmark results on SSD are shown in [3],
> >
> >heh.  It wipes the floor with everything, including btrfs.

It seems the benchmark was done over half year ago. It's questionable how 
relevant today the performance comparison is with actively developed file 
systems ...

> >But a log-based fs will do that, initially.  What will the performace
> >look like after a month or two's usage?
> 
> I'm using NILFS2 for my home directory for serveral months, but so far
> I don't feel notable performance degradation. 

I ran compilebench on kernel 2.6.26 with freshly formatted volumes. 
The behavior of NILFS2 was interesting.

Its peformance rapidly degrades to the lowest ever measured level 
(< 1 MB/s) but after a while it recovers and gives consistent numbers.
However it's still very far from the current unstable btrfs performance. 
The results are reproducible.

                    MB/s    Runtime (s)
                   -----    -----------
  btrfs unstable   17.09        572
  ext3             13.24        877
  btrfs 0.16       12.33        793
  nilfs2 2nd+ runs 11.29        674
  ntfs-3g           8.55        865
  reiserfs          8.38        966
  nilfs2 1st run    4.95       3800
  xfs               1.88       3901

	Szaka

-- 
NTFS-3G:  http://ntfs-3g.org

