Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbZKKV0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbZKKV0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759024AbZKKV0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:26:20 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:50235 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923AbZKKV0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:26:19 -0500
Date: Wed, 11 Nov 2009 16:25:54 -0500
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Btrfs updates for 2.6.32-rc
Message-ID: <20091111212554.GA2898@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AFB2BF4.0136:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

The master branch of the btrfs-unstable repo has an assortment of fixes
and speedups.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

These are mostly minor fixes, but there is an important fix for using
btrfs and ceph together.  Josef has a block group caching performance
patch that reduces his boot time dramatically, which is the biggest
change in the bunch.

We also now handle enospc with mount -o compress, before this was
actually more likely to fail than uncompressed mounts because mount -o
compress expected to be able to find multi-block contiguous extents on
disk.

I know Linus likes to look for obvious rebases, and I did rebase this
morning before pushing out to drop a small mount option patch that we
don't strictly need for .32.

Chris Mason (1) commits (+2/-2):
    Btrfs: allow more metadata chunk preallocation

Dan Carpenter (1) commits (+1/-1):
    Btrfs: avoid null deref in unpin_extent_cache()

Josef Bacik (7) commits (+180/-45):
    Btrfs: cleanup transaction starting and fix journal_info usage (+13/-6)
    Btrfs: fix panic when trying to destroy a newly allocated (+10/-0)
    Btrfs: fallback on uncompressed io if compressed io fails (+23/-8)
    Btrfs: fix how we set max_size for free space clusters (+1/-1)
    Btrfs: find ideal block group for caching (+86/-23)
    Btrfs: fix some metadata enospc issues (+31/-5)
    Btrfs: fix data allocation hint start (+16/-2)

Li Dongyang (1) commits (+0/-2):
    Btrfs: skip btrfs_release_path in btrfs_update_root and btrfs_del_root

Total: (10) commits

 fs/btrfs/extent-tree.c      |  113 ++++++++++++++++++++++++++++++++++----------
 fs/btrfs/extent_map.c       |    2 
 fs/btrfs/free-space-cache.c |    2 
 fs/btrfs/inode.c            |   95 +++++++++++++++++++++++++++++++-----
 fs/btrfs/root-tree.c        |    2 
 fs/btrfs/transaction.c      |   19 +++++--
 6 files changed, 183 insertions(+), 50 deletions(-)

