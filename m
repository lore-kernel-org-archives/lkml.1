Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZDNMmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZDNMmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZDNMlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:41:52 -0400
Received: from sh.osrg.net ([192.16.179.4]:39928 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbZDNMlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:41:51 -0400
Date: Tue, 14 Apr 2009 21:41:09 +0900 (JST)
Message-Id: <20090414.214109.13228807.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 updates for 2.6.30-rc2
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 14 Apr 2009 21:41:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull nilfs2 updates from

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

The following changes since commit b0cbc861a3c05e634520b049b5cc27ad6febb51f:
 Linus Torvalds (1):
      Revert "ACPI battery: fix async boot oops"

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
-

The "nilfs2: simplify handling of active state of segments fix" patch
is most important; this fixes user-reported file system corruption
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
declaration we have used for out-of-kernel modules.


Thanks,
Ryusuke Konishi
