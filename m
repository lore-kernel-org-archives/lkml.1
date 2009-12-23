Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZLWMvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZLWMvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 07:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZLWMvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 07:51:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:49305 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbZLWMvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 07:51:19 -0500
Date: Wed, 23 Dec 2009 13:51:10 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, tytso@mit.edu,
       linux-ext4@vger.kernel.org
Subject: [PULL REQUEST] Ext3, ext4 and quota fixes for 2.6.33-rc2
Message-ID: <20091223125110.GA3159@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get:

Dmitry Monakhov (7):
      ext3: quota macros cleanup [V2]
      Add unlocked version of inode_add_bytes() function
      quota: decouple fs reserved space from quota reservation
      ext4: Convert to generic reserved quota's space management.
      quota: Move duplicated code to separate functions
      ext4: Fix potential quota deadlock
      ext4: fix sleep inside spinlock issue with quota and dealloc (#14739)

Eric Sandeen (4):
      ext3: Remove outdated comment about lock_super()
      ext3: ext3_mark_recovery_complete() doesn't need to use lock_super
      ext3: Replace lock/unlock_super() with an explicit lock for the orphan list
      ext3: Replace lock/unlock_super() with an explicit lock for resizing

Jan Kara (2):
      quota: Fix 64-bit limits setting on 32-bit archs
      quota: Improve checking of quota file header

Yin Kangkai (1):
      jbd: jbd-debug and jbd2-debug should be writable

I push ext4 fixes instead of Ted because of quota dependencies. Ext3
locking changes fix deadlock during filesystem resizing so I hope they're
fine even for -rc2.

The diffstat is

 fs/ext3/inode.c            |    8 +-
 fs/ext3/namei.c            |   28 +++--
 fs/ext3/resize.c           |   35 +++---
 fs/ext3/super.c            |   19 +---
 fs/ext4/ext4.h             |    6 +-
 fs/ext4/inode.c            |   36 +++---
 fs/ext4/mballoc.c          |    6 -
 fs/ext4/super.c            |    5 +
 fs/jbd/journal.c           |    2 +-
 fs/jbd2/journal.c          |    3 +-
 fs/quota/dquot.c           |  288 ++++++++++++++++++++++++--------------------
 fs/quota/quota_v2.c        |    9 +-
 fs/stat.c                  |   10 ++-
 include/linux/ext3_fs_sb.h |    2 +
 include/linux/ext3_jbd.h   |    7 +-
 include/linux/fs.h         |    1 +
 include/linux/quota.h      |    5 +-
 17 files changed, 253 insertions(+), 217 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
