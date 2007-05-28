Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbXE1Qg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbXE1Qg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756988AbXE1Qgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:36:36 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:60242 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbXE1Qge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:36:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=iI0WFt3s+KtXJiB4JIiMRiNGttFViqFgz51jLMULc2gMzOfZBhZQiarSqP23c5eBHO8F3aVK07MGLPjX3i3noGZwS6wc7ufmnnI5ydSQjN7GIOqCxcdZk5DO/SBalCquGEoKdHXI58gIxm8cRnDonOB1wfffTaHA0S3ebPftcUc=
Subject: [PATCHSET 2.6.22-rc2-mm1 REVIEW] sysfs: make directory dentries/inodes reclaimable
In-Reply-To: 
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:36:26 +0900
Message-Id: <11803701861778-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

THIS PATCHSET NEEDS MORE REVIEW AND TESTING.  PLEASE DO NOT APPLY YET.

This patchset makes directory dentries and inodes reclaimable and is
consisted of the following six patches.

#01: implement-sysfs-flags-and-SYSFS_FLAG_REMOVED
#02: implement-sysfs_find_dirent-and-sysfs_get_dirent
#03: make-kobj-point-to-sysfs_dirent-instead-of-dentry
#04: use-sysfs_lock-to-protect-the-sysfs_dirent-tree
#05: implement-sysfs_get_dentry
#06: make-directory-dentries-and-inodes-reclaimable

Patch #01 and #06 probably need more splitting and #04-06 definitely
need a lot more testing and review but the basic seems to work.  Now
having 10k sysfs files/directories cost slightly under 9 megabytes,
which isn't too bad and makes sysfs useable on wider range of systems.

API changes...

* kobj->dentry replaced with kobj->sd as dentry can go away
* shadowed directory handling functions now take sysfs_dirent instead
  of dentry

As dirent and dentry are confusing as hell, I'd like to rename
sysfs_dirent to sysfs_node or something.  Any better ideas?

Please review, test, scream... :-)

This patchset is on top of

  2.6.22-rc2-mm1
+ [1] sysfs-assorted-fixes patchset
+ [2] sysfs-reduce-memory-footprint-of-sysfs_dirent patchset

 fs/sysfs/bin.c          |    6 
 fs/sysfs/dir.c          |  590 +++++++++++++++++++++++++++++++-----------------
 fs/sysfs/file.c         |  196 +++++++--------
 fs/sysfs/group.c        |   54 ++--
 fs/sysfs/inode.c        |   36 +-
 fs/sysfs/mount.c        |    4 
 fs/sysfs/symlink.c      |   67 ++---
 fs/sysfs/sysfs.h        |   25 +-
 include/linux/kobject.h |    9 
 include/linux/sysfs.h   |   24 +
 lib/kobject.c           |   10 
 11 files changed, 603 insertions(+), 418 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/535372
[2] http://thread.gmane.org/gmane.linux.kernel/535379


