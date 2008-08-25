Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbYHYFZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbYHYFZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 01:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYHYFZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 01:25:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35991 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYHYFZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 01:25:35 -0400
Date: Mon, 25 Aug 2008 06:25:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs fixes
Message-ID: <20080825052533.GW28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted fixes.  Note on d_add_ci patch - we definitely want it to have the
same order of arguments as in d_add(), so we'd better fix that before .27.
Please pull from 
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (6):
      fix efs_lookup()
      fix osf_getdirents()
      fix hpux_getdents()
      fix regular readdir() and friends
      fix ->llseek() for a bunch of directories
      deal with the first call of ->show() generating no output

Alexey Dobriyan (1):
      proc: inode number fixlet

Christoph Hellwig (2):
      change d_add_ci argument ordering
      ntfs: use d_add_ci

Diffstat:
 arch/alpha/kernel/osf_sys.c |   19 ++++++---
 arch/parisc/hpux/fs.c       |   30 +++++++++-----
 drivers/misc/acer-wmi.c     |    5 --
 fs/9p/vfs_dir.c             |    1 +
 fs/adfs/dir.c               |    1 +
 fs/affs/dir.c               |    1 +
 fs/autofs4/root.c           |    2 +
 fs/befs/linuxvfs.c          |    1 +
 fs/compat.c                 |    8 +++-
 fs/dcache.c                 |    2 +-
 fs/efs/namei.c              |    3 +-
 fs/ntfs/namei.c             |   89 +------------------------------------------
 fs/proc/generic.c           |    1 +
 fs/readdir.c                |    8 +++-
 fs/seq_file.c               |   11 ++++-
 fs/xfs/linux-2.6/xfs_file.c |    1 +
 fs/xfs/linux-2.6/xfs_iops.c |    2 +-
 include/linux/dcache.h      |    2 +-
 18 files changed, 66 insertions(+), 121 deletions(-)
