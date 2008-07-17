Return-Path: <linux-kernel-owner+w=401wt.eu-S1760129AbYGQRv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129AbYGQRv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbYGQRvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:51:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbYGQRvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:51:48 -0400
Date: Thu, 17 Jul 2008 10:51:46 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git patches] Ocfs2 and Configfs updates for 2.6.27
Message-ID: <20080717175146.GH28014@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches were sent out earlier this week for review. The only change I
made since then was a small update to Coly's bugfix to remove some code
which it obsoleted.

Original message and revised diffstat follow:

I'm running a bit late with the e-mail this time around, but I think that's
ok since there really isn't any major new features here - the bulk of the
Ocfs2 update is bug fixes, or cleanups. The same goes for configfs.

The only two things that could be described as features would be:

- Sunil has updated Ocfs2 to provide even more live cluster locking
  information via debugfs.

- Joel updated configfs's ->make_item() and ->make_group() callbacks to
  return more descriptive error types. This update is responsible for the
  changes to drivers/net/netconsole.c and fs/dlm/config.c as shown in the diffstat.

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 Documentation/filesystems/configfs/configfs.txt    |   10 +-
 .../filesystems/configfs/configfs_example.c        |   14 +-
 drivers/net/netconsole.c                           |   10 +-
 fs/Kconfig                                         |    8 +
 fs/configfs/configfs_internal.h                    |    4 +
 fs/configfs/dir.c                                  |  147 ++++++++++++++------
 fs/configfs/inode.c                                |    2 +
 fs/configfs/symlink.c                              |   16 ++-
 fs/dlm/config.c                                    |   45 ++++---
 fs/ocfs2/aops.c                                    |   13 ++-
 fs/ocfs2/cluster/heartbeat.c                       |   17 ++-
 fs/ocfs2/cluster/netdebug.c                        |    8 +-
 fs/ocfs2/cluster/nodemanager.c                     |   45 ++++---
 fs/ocfs2/dlmglue.c                                 |  122 ++++++++++++++++-
 fs/ocfs2/file.c                                    |    2 +-
 fs/ocfs2/journal.c                                 |    2 +-
 fs/ocfs2/localalloc.c                              |    2 +-
 fs/ocfs2/ocfs2.h                                   |   12 ++
 fs/ocfs2/ocfs2_fs.h                                |    2 +-
 fs/ocfs2/stack_user.c                              |   19 +--
 fs/ocfs2/super.c                                   |    6 +-
 include/linux/configfs.h                           |    4 +-
 22 files changed, 383 insertions(+), 127 deletions(-)

Akinobu Mita (1):
      ocfs2: use simple_read_from_buffer()

Coly Li (1):
      ocfs2: fix oops in mmap_truncate testing

Joel Becker (3):
      ocfs2: Fix CONFIG_OCFS2_DEBUG_FS #ifdefs
      ocfs2: Don't snprintf() without a format.
      configfs: Allow ->make_item() and ->make_group() to return detailed errors.

Louis Rilling (6):
      configfs: Introduce configfs_dirent_lock
      configfs: Protect configfs_dirent s_links list mutations
      configfs: Make configfs_new_dirent() return error code instead of NULL
      configfs: Fix deadlock with racing rmdir() and rename()
      configfs: Fix failing mkdir() making racing rmdir() fail
      configfs: call drop_link() to cleanup after create_link() failure

Randy Dunlap (1):
      ocfs2: fix printk format warnings with OCFS2_FS_STATS=n

Sunil Mushran (4):
      ocfs2: Add CONFIG_OCFS2_FS_STATS config option
      ocfs2: Instrument fs cluster locks
      ocfs2: Silence an error message in ocfs2_file_aio_read()
      ocfs2/net: Silence build warnings on sparc64

Wengang Wang (1):
      ocfs2: Handle error during journal load

--
Mark Fasheh
