Return-Path: <linux-kernel-owner+w=401wt.eu-S1762855AbZDJFdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855AbZDJFdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbZDJFdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:33:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:58953 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656AbZDJFdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:33:14 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] nilfs2 updates for 2.6.30
Date: Fri, 10 Apr 2009 14:27:53 +0900
Message-Id: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 14:33:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are some fixes of nilfs2 we have scheduled for 2.6.30.  I am
planning to send them to Linus a bit later.  This post is for your
review.

The "nilfs2: simplify handling of active state of segments fix" patch
is most important, which fixes user-reported file system corruption
through garbage collection.

The "nilfs2: fix lockdep recursive locking warning on bmap", and
    "nilfs2: fix lockdep recursive locking warning on meta data files"
fix known lockdep warnings.

The "nilfs2: fix wrong accounting and duplicate brelse in nilfs_sufile_set_error",
    "nilfs2: segment usage file cleanups", and
    "nilfs2: fix possible mismatch of sufile counters on recovery"
fix possible mismatch of on-disk counters keeping the number of dirty
or clean segments, where the second patch is a preparation for the
third one.

The "nilfs2: return f_fsid for statfs2" follows the recent change by
Coly Li's series "fs: return f_fsid for statfs(2)".

And, the "nilfs2: remove module version" deletes a MODULE_VERSION()
declaration which was used for the out-of-kernel module.


With regards,
Ryusuke Konishi
--
Ryusuke Konishi (8):
      nilfs2: return f_fsid for statfs2
      nilfs2: fix lockdep recursive locking warning on bmap
      nilfs2: fix lockdep recursive locking warning on meta data files
      nilfs2: remove module version
      nilfs2: simplify handling of active state of segments fix
      nilfs2: fix wrong accounting and duplicate brelse in nilfs_sufile_set_error
      nilfs2: segment usage file cleanups
      nilfs2: fix possible mismatch of sufile counters on recovery

 fs/nilfs2/bmap.c      |    5 +
 fs/nilfs2/nilfs.h     |    5 -
 fs/nilfs2/recovery.c  |   20 +---
 fs/nilfs2/sufile.c    |  290 ++++++++++++++++++-------------------------------
 fs/nilfs2/sufile.h    |   79 +++++++++++++-
 fs/nilfs2/super.c     |    7 +-
 fs/nilfs2/the_nilfs.c |    4 +
 7 files changed, 197 insertions(+), 213 deletions(-)

