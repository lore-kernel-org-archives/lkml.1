Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbYHUMww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbYHUMww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYHUMwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:52:42 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59200 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbYHUMwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:52:41 -0400
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
From: Chris Mason <chris.mason@oracle.com>
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0808202352450.4532@dhcppc2>
References: <20080820004326.519405a2.akpm@linux-foundation.org>
	 <200808201613.AA00212@capsicum.lab.ntt.co.jp>
	 <Pine.LNX.4.61.0808202352450.4532@dhcppc2>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 08:51:31 -0400
Message-Id: <1219323091.7854.45.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 00:25 +0300, Szabolcs Szakacsits wrote:
> On Thu, 21 Aug 2008, Ryusuke Konishi wrote:
> > >> Some impressive benchmark results on SSD are shown in [3],
> > >
> > >heh.  It wipes the floor with everything, including btrfs.
> 
> It seems the benchmark was done over half year ago. It's questionable how 
> relevant today the performance comparison is with actively developed file 
> systems ...
> 

I'd expect that nilfs continues to win postmark.  Btrfs splits data and
metadata into different parts of the disk, so at best btrfs is going to
produce two streams of writes into the SSD while nilfs is doing one.
Most consumer ssds still benefit from huge writes, and so nilfs is
pretty optimal in that case.

The main benefit of the split for btrfs is being able to have different
duplication policies for metadata and data, and faster fsck times
because the metadata is more compact.  Over time that may prove less
relevant on SSD, and changing it in btrfs is just flipping a few bits
during allocation.

-chris


