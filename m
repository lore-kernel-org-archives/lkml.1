Return-Path: <linux-kernel-owner+w=401wt.eu-S1759046AbZD0SH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbZD0SH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbZD0SHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:07:31 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:62734 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991AbZD0SH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:07:29 -0400
Subject: [GIT PULL] Btrfs updates for 2.6.30-rc
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 14:05:55 -0400
Message-Id: <1240855555.5529.11.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.49F5F413.01E7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

The master branch of:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

Has a few btrfs bug fixes, performance fixes and a few cleanups.  The
highlights are some code from Josef Bacik to for metadata block group
preallocation, which will help cut down on the chances of metadata
enospc.

Linus found an acl caching bug that made for many many btree searches
for acls on inodes that didn't have acls, and that is fixed up as well.

Chris Mason (7) commits (+144/-237):
    Btrfs: look for acls during btrfs_read_locked_inode (+62/-0)
    Btrfs: fix deadlocks and stalls on dead root removal (+6/-0)
    Btrfs: fix fallocate deadlock on inode extent lock (+29/-17)
    Btrfs: remove unused btrfs_bit_radix slab (+0/-8)
    Btrfs: ratelimit IO error printks (+31/-17)
    Btrfs: remove #if 0 code (+1/-188)
    Btrfs: fix acl caching (+15/-7)

Christoph Hellwig (3) commits (+30/-66):
    Btrfs: kill btrfs_cache_create (+28/-43)
    Btrfs: don't export symbols (+0/-6)
    Btrfs: simplify makefile (+2/-17)

Joel Becker (2) commits (+41/-24):
    Btrfs: Fix a trivial warning using max() of u64 vs ULL. (+1/-1)
    Btrfs: Fix a bunch of printk() warnings. (+40/-23)

Josef Bacik (1) commits (+42/-2):
    Btrfs: try to keep a healthy ratio of metadata vs data block groups

Chris Ball (1) commits (+27/-11):
    Btrfs: When shrinking, only update disk size on success

Total: (14) commits

 fs/btrfs/Makefile           |   19 -----
 fs/btrfs/acl.c              |   18 +++--
 fs/btrfs/ctree.h            |    6 +
 fs/btrfs/disk-io.c          |   93 ++++++++------------------
 fs/btrfs/extent-tree.c      |   49 +++++++++++---
 fs/btrfs/extent_io.c        |   81 +----------------------
 fs/btrfs/extent_map.c       |   17 ----
 fs/btrfs/file.c             |   89 +------------------------
 fs/btrfs/free-space-cache.c |   15 ++--
 fs/btrfs/inode-map.c        |    2 
 fs/btrfs/inode.c            |  153 ++++++++++++++++++++++++++++++--------------
 fs/btrfs/ioctl.c            |    9 +-
 fs/btrfs/super.c            |   27 +++++--
 fs/btrfs/transaction.c      |    6 +
 fs/btrfs/tree-log.c         |    2 
 fs/btrfs/volumes.c          |   35 ++++++----
 fs/btrfs/volumes.h          |    3 
 17 files changed, 284 insertions(+), 340 deletions(-)


