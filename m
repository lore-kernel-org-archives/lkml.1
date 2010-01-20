Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614Ab0ATCoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0ATCoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 21:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193Ab0ATCoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 21:44:08 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:30527 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0ATCoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 21:44:06 -0500
Date: Tue, 19 Jan 2010 21:42:46 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-btrfs@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 2.6.33-git
Message-ID: <20100120024246.GA3001@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B566DE6.00F4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

The master branch of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Is against 2.6.32 but pulls cleanly into Linus' current git.  These are
various bug fixes, nothing stands out but some are commonly hit.

The readdir fix brings btrfs in line with what xfs does, limiting the
max directory entry offset for proper results in both 32 bit and 64 bit
environments.

For everyone waiting for Josef's snapshot-rollback work for snapshot
protected upgrades, I'm collecting those into a .34 testing branch along
with other development work.  It will be available this week.

Chris Mason (1) commits (+7/-5):
    Btrfs: deal with NULL acl sent to btrfs_set_acl

Jan Engelhardt (1) commits (+5/-1):
    btrfs: fix missing last-entry in readdir(3)

Jiri Slaby (1) commits (+6/-2):
    Btrfs, fix memory leaks in error paths

Josef Bacik (2) commits (+25/-13):
    Btrfs: fix regression in orphan cleanup (+6/-0)
    Btrfs: fix possible panic on unmount (+19/-13)

Zheng Yan (2) commits (+82/-20):
    Btrfs: align offsets for btrfs_ordered_update_i_size (+2/-0)
    Btrfs: Fix race in btrfs_mark_extent_written (+80/-20)

Total: (7) commits

 fs/btrfs/acl.c          |   12 +++--
 fs/btrfs/extent-tree.c  |   32 +++++++++------
 fs/btrfs/file.c         |  100 ++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/inode.c        |   12 +++++
 fs/btrfs/ordered-data.c |    2 
 fs/btrfs/relocation.c   |    4 +
 fs/btrfs/volumes.c      |    4 +
 7 files changed, 125 insertions(+), 41 deletions(-)
