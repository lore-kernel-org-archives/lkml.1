Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0CCOKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 09:10:40 -0500
Received: from sh.osrg.net ([192.16.179.4]:41401 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab0CCOKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 09:10:38 -0500
Date: Wed, 03 Mar 2010 23:10:05 +0900 (JST)
Message-Id: <20100303.231005.71011379.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 updates for 2.6.34
From: Ryusuke Konishi <ryusuke@osrg.net>
X-Mailer: Mew version 5.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 03 Mar 2010 23:10:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive the following updates.  There are minor fixes, several
cleanups, and a new mount option to use discard/trim for sector ranges
nilfs GC freed.

Thanks!

Ryusuke Konishi

--
The following changes since commit 724e6d3fe8003c3f60bf404bf22e4e331327c596:
  Linus Torvalds (1):
        Linux 2.6.33-rc8

Jiro SEKIBA (4):
      nilfs2: issue discard request after cleaning segments
      nilfs2: delete unnecessary condition in nilfs_dat_translate
      nilfs2: delete unnecessary condition in load_segment_summary
      nilfs2: add reader's lock for cno in nilfs_ioctl_sync

Ryusuke Konishi (5):
      nilfs2: use mnt_want_write in ioctls where write access is needed
      nilfs2: fix potential hang in nilfs_error on errors=remount-ro
      nilfs2: get rid of nilfs_segctor_req struct
      nilfs2: get rid of s_dirt flag use
      nilfs2: move iterator to write log into segment buffer

 Documentation/filesystems/nilfs2.txt |    3 +
 fs/nilfs2/dat.c                      |    3 +-
 fs/nilfs2/ioctl.c                    |   66 ++++++++++++++-----
 fs/nilfs2/recovery.c                 |   41 +++---------
 fs/nilfs2/segbuf.c                   |   18 +++++
 fs/nilfs2/segbuf.h                   |    5 +-
 fs/nilfs2/segment.c                  |  120 ++++++++++++++++++----------------
 fs/nilfs2/segment.h                  |    2 +
 fs/nilfs2/super.c                    |   15 +++--
 fs/nilfs2/the_nilfs.c                |   38 +++++++++++
 fs/nilfs2/the_nilfs.h                |    3 +
 include/linux/nilfs2_fs.h            |    1 +
 12 files changed, 199 insertions(+), 116 deletions(-)
