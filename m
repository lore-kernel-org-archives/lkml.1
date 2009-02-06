Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbZBFQW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbZBFQW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZBFQWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:22:49 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:46258 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbZBFQWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:22:48 -0500
Subject: [GIT PULL] Btrfs updates for 2.6.29-rc
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 11:22:29 -0500
Message-Id: <1233937349.17551.18.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.498C63CB.0284:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

The current btrfs unstable tree should be ready for 2.6.29-rc:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

We've been busy working on cleanups and improvements based on the
feedback for Btrfs.  There are still lots of cleanups left to do,
especially the ones pointed out by Andrew.

Some of them I've been holding on to as starter tasks for people that
are interested in the project.

The current btrfs unstable tree also has a number of fixes hit by
testers and by the Fedora alpha integration.  These include selinux
support, an oops in the compression code, and a few different IO stalls.

There are two big performance related changes in the tree.  I got rid of
the adaptive mutex implementation and switched to a lock that explicitly
switches between a spinlock and a waitqueue.  This is faster and it
allows us to pick off the blocking lock points one by one over time in a
controlled fashion.

The second big performance fix deals with snapshot deletion.  It makes
progress much more effectively and is able to keep up with bigger
workloads.  This is important because every transaction ends up deleting
a snapshot.

There wasn't much code involved in the snapshot deletion improvements,
it is basically just sorting the block pointers before updating their
reference counts, and working on leaves in bulk instead of one by one.

Here's the shortlog:

Chris Ball (1):
      Btrfs: Handle SGID bit when creating inodes

Chris Mason (14):
      Btrfs: Catch missed bios in the async bio submission thread
      Btrfs: async threads should try harder to find work
      Btrfs: sort references by byte number during btrfs_inc_ref
      Btrfs: disable leak debugging checks in extent_io.c
      Btrfs: hash_lock is no longer needed
      Btrfs: Change btree locking to use explicit blocking points
      Btrfs: Make btrfs_drop_snapshot work in larger and more efficient chunks
      Btrfs: Don't try to compress pages past i_size
      Btrfs: Change btrfs_truncate_inode_items to stop when it hits the inode
      Btrfs: change btrfs_del_leaf to drop locks earlier
      Btrfs: fix btrfs_unlock_up_safe to walk the entire path
      Btrfs: Only prep for btree deletion balances when nodes are mostly empty
      Btrfs: don't return congestion in write_cache_pages as often
      Btrfs: Fix memory leak in cache_drop_leaf_ref

Christian Hesse (1):
      Btrfs: make btrfs acls selectable

Jim Owens (1):
      Btrfs: selinux support

Josef Bacik (1):
      Btrfs: join the transaction in __btrfs_setxattr



