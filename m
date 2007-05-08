Return-Path: <linux-kernel-owner+w=401wt.eu-S968318AbXEHOv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968318AbXEHOv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967771AbXEHOvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:51:55 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39111 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968227AbXEHOvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:51:54 -0400
To: torvalds@linux-foundation.org
Subject: [git pull] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20070508145116.DBAD784C0E@kleikamp.austin.ibm.com>
Date: Tue,  8 May 2007 09:51:16 -0500 (CDT)
From: shaggy@linux.vnet.ibm.com (Dave Kleikamp)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

I added one patch since the last pull request.  This fixes a hang that
has been seen a few times in recent kernels.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 Documentation/filesystems/jfs.txt |    8 +++++++-
 fs/jfs/inode.c                    |    1 -
 fs/jfs/ioctl.c                    |    2 ++
 fs/jfs/jfs_imap.c                 |    2 ++
 fs/jfs/jfs_inode.c                |   18 ++++++++++++++++++
 fs/jfs/jfs_inode.h                |    1 +
 fs/jfs/jfs_lock.h                 |    2 +-
 fs/jfs/jfs_logmgr.c               |    7 ++++---
 fs/jfs/jfs_txnmgr.c               |    6 +++---
 9 files changed, 38 insertions(+), 9 deletions(-)

through these ChangeSets:

Commit: 05ec9e26be1f668ccba4ca54d9a4966c6208c611 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Sat, 05 May 2007 14:24:05 -0500 

    JFS: Fix race waking up jfsIO kernel thread
    
    It's possible for a journal I/O request to be added to the log_redrive
    queue and the jfsIO thread to be awakened after the thread releases
    log_redrive_lock but before it sets its state to TASK_INTERRUPTIBLE.
    
    The jfsIO thread should set the state before giving up the spinlock, so
    the waking thread will really wake it.
    
    Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>

Commit: 3cbb1c8e1a4787d3dc2951b7615d7bb3788c49a0 
Author: Milind Arun Choudhary <milindchoudhary@gmail.com> Thu, 26 Apr 2007 07:30:29 -0500 

    JFS: use __set_current_state()
    
    use __set_current_state(TASK_*) instead of current->state = TASK_*
    
    Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: 3e2221c73cba7d33fd5706f9bc4906ffaf421478 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Wed, 25 Apr 2007 09:36:20 -0500 

    Copy i_flags to jfs inode flags on write
    
    This mirrors Jan Kara's patches for ext3.  This patch makes sure that
    changes made to inode->i_flags are reflected on disk for jfs.  It also
    moves a call of jfs_set_inode_flags() to be more consistent with where
    jfs_get_inode_flags() is called.
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: ba863a0016a33637acc7888698a5d75096fcec05 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Fri, 09 Mar 2007 10:27:31 -0600 

    JFS: document uid, gid, and umask mount options in jfs.txt
    
    Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>

