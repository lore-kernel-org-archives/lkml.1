Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYGNQsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYGNQsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYGNQsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:48:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43028 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335AbYGNQsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:48:22 -0400
To: torvalds@linux-foundation.org
Subject: [git pull] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20080714164819.054924CB672@norville.austin.ibm.com>
Date: Mon, 14 Jul 2008 11:48:19 -0500 (CDT)
From: shaggy@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/jfs_debug.c    |   62 ++++++++++++++++++++------------------------
 fs/jfs/jfs_debug.h    |   10 +++---
 fs/jfs/jfs_dtree.h    |    3 --
 fs/jfs/jfs_imap.c     |    2 +-
 fs/jfs/jfs_logmgr.c   |   35 +++++++++++-------------
 fs/jfs/jfs_metapage.c |   36 ++++++++++++-------------
 fs/jfs/jfs_txnmgr.c   |   68 ++++++++++++++++++++++--------------------------
 fs/jfs/jfs_xtree.c    |   36 ++++++++++++-------------
 fs/jfs/namei.c        |    2 +-
 fs/jfs/super.c        |    7 ++---
 10 files changed, 119 insertions(+), 142 deletions(-)

through these ChangeSets:

commit ec1aef33668448718fcba79e4e981592bfd7e0a3
Author: Adrian Bunk <bunk@kernel.org>
Date:   Tue Jun 10 15:12:58 2008 -0500

    jfs: remove DIRENTSIZ
    
    After fat gets fixed the unused DIRENTSIZ macro was the last user of
    struct dirent we should get rid of since the kernel and userspace
    versions differed.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit 3c65e8743bf8b5cf0f90e8d767bf1d8b50c14c76
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Wed May 28 08:58:56 2008 -0500

    JFS: diAlloc() should return -EIO rather than EIO
    
    The comment above the function says one of its return value is -EIO,
    and also the caller of diAlloc() checks for -EIO:
    
    struct inode *ialloc(struct inode *parent, umode_t mode)
    {
    	...
    	rc = diAlloc(parent, S_ISDIR(mode), inode);
    	if (rc) {
    		jfs_warn("ialloc: diAlloc returned %d!", rc);
    		if (rc == -EIO)
    			make_bad_inode(inode);
    	...
    
    Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit 6536d2891ba2c4e837ba8478dc13bb173ed24a23
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Date:   Wed May 21 10:45:16 2008 -0500

    JFS: skip bad iput() call in error path
    
    If jfs_iget() fails, we can't call iput() on the returned error.
    Thanks to Eric Sesterhenn's fuzzer testing for reporting the problem.
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit b2e03ca7485cac033a0667d9e45e28d32fdee9a5
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Tue May 13 08:22:10 2008 -0500

    JFS: switch to seq_files
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit 88f85a55c0645c2b7e03bf34d2a90eddf6de34fa
Author: Marcin Slusarz <marcin.slusarz@gmail.com>
Date:   Mon May 12 16:42:43 2008 -0500

    JFS: 0 is not valid errno value so return NULL from jfs_lookup
    
    Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
    Cc: jfs-discussion@lists.sourceforge.net
    Cc: Alexander Viro <viro@zeniv.linux.org.uk>
