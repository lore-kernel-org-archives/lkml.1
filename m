Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbZEMHtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbZEMHtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 03:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZEMHtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 03:49:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:52884 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbZEMHtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 03:49:08 -0400
Date: Wed, 13 May 2009 16:48:28 +0900 (JST)
Message-Id: <20090513.164828.56055985.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fixes for 2.6.30-rc6
From: Ryusuke Konishi <ryusuke@osrg.net>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 13 May 2009 16:48:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull nilfs2 bug-fixes from

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

The following changes since commit 091bf7624d1c90cec9e578a18529f615213ff847
 Linus Torvalds (1):
      Linux 2.6.30-rc5

Ryusuke Konishi (6):
      nilfs2: fix possible recovery failure due to block creation without writer
      nilfs2: fix circular locking dependency of writer mutex
      nilfs2: ensure to clear dirty state when deleting metadata file block
      nilfs2: fix possible circular locking for get information ioctls
      nilfs2: fix lock order reversal in nilfs_clean_segments ioctl
      nilfs2: check size of array structured data exchanged via ioctls

 fs/nilfs2/ioctl.c    |  281 ++++++++++++++++++++++++++------------------------
 fs/nilfs2/mdt.c      |   15 ++--
 fs/nilfs2/nilfs.h    |    3 +-
 fs/nilfs2/page.c     |    3 +-
 fs/nilfs2/recovery.c |    6 +-
 fs/nilfs2/segment.c  |    5 +-
 fs/nilfs2/segment.h  |    3 +-
 7 files changed, 167 insertions(+), 149 deletions(-)
-

The "nilfs2: check size of array structured data exchanged via ioctls"
adds missing sanity checks to ioctls.  These checks are needed to
prevent memory access overrun in kernel code due to incorrect
argument data.

The "nilfs2: ensure to clear dirty state when deleting metadata file
block" fixes user-reported GC failures.

The "nilfs2: fix possible recovery failure due to block creation
without writer" fixes recovery failure on mount which can happen in a
boundary condition.

The "nilfs2: fix circular locking dependency of writer mutex",
    "nilfs2: fix possible circular locking for get information ioctls", and
    "nilfs2: fix lock order reversal in nilfs_clean_segments ioctl"
fix circular locking problems and lock order reversal the lockdep
check has detected.

Thanks,
Ryusuke Konishi
