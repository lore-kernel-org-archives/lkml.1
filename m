Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbXFMT1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbXFMT1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXFMT1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:27:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:61120 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbXFMT12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=km1KA7oqGbKFMZvScZC7aY8oqFjSLu5du2gNq7a3+2Judqcbyh5JshFgqpWRzmPqE2qvHwCaLfazXC2+iLTspB5y9OJYiduf6f65TEujjjrUiJzF775gqi7bTrHcioWVKRicCc/TB5+BZt06Z02wBzdoTLQJosiXD1LX70Q/JV0=
Subject: [PATCHSET 2.6.22-rc4-mm2] sysfs: make directory dentries/inodes reclaimable, take#2
In-Reply-To: 
X-Mailer: git-send-email
Date: Thu, 14 Jun 2007 04:27:20 +0900
Message-Id: <1181762840495-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: greg@kroah.com, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset makes directory dentries and inodes reclaimable and is
consisted of the following eleven patches.

#01: make-sysfs_drop_dentry-access-inodes-using-ilookup
#02: rename-sysfs_dirent-s_type-to-s_flags-and-make-room-for-flags
#03: implement-SYSFS_FLAG_REMOVED-flag
#04: implement-sysfs_find_dirent-and-sysfs_get_dirent
#05: make-kobj-point-to-sysfs_dirent-instead-of-dentry
#06: consolidate-sysfs-spinlocks
#07: use-sysfs_mutex-to-protect-the-sysfs_dirent-tree
#08: restructure-add-remove-paths-and-fix-inode-up
#09: move-sysfs_drop_dentry-to-dir.c-and-make-it-static
#10: implement-sysfs_get_dentry
#11: make-directory-dentries-and-inodes-reclaimable

API changes...

* kobj->dentry replaced with kobj->sd as dentry can go away
* shadowed directory handling functions now take sysfs_dirent instead
  of dentry

Changes from the last take[L] are...

* #01 added.
* #02 and #03 splitted from the first patch of the last take.
* #06 added.  sysfs_lock isn't used as global sysfs_dirent tree lock.
   merge it with kobj_sysfs_assoc_lock.
* #07 modified to use sysfs_mutex instead of sysfs_lock to protect
  sysfs_dirent tree.  This resolves the problem Cornelia was seeing in
  the last take.
* #08 and #09 added.  This is primarily to keep the parent inode's
  timestamps and i_nlink in sync.  Code looks better after the change
  too.

I'm running stress test for several hours now and things look pretty
good.  This will save quite some amount of memory on big machines.

This patchset applies on top of 2.6.22-rc4-mm2 or

  current linux-2.6#master (a0e1d1d075cc0efe9a3ac8579bce9393d070e09f)
+ regenerated sysfs rework patchset (forgot to cc lkml when posting.
  the end result is practically the same to 2.6.22-rc4-mm2)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/535388


