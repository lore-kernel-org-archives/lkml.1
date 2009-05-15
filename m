Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZEOGok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZEOGok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 02:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZEOGnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 02:43:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:39331 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241AbZEOGnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 02:43:46 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/4] cleanups on nilfs_get_sb()
Date: Fri, 15 May 2009 15:37:22 +0900
Message-Id: <1242369446-25771-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 15 May 2009 15:43:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have reduced use of sget() and bd_mount_sem in nilfs with the
following patches.  I believe the direction of this series is not
wrong, but if it discords from WIP cleanups in vfs, let me know
please.

This series is unfinished, and the following works are at least
remaining:

 * clarify exclusion control especially for MS_RDONLY flag in sb->s_flags.
 * cleanups of nilfs_remount().
 * clarify what is supposed to in nilfs_remount() and nilfs_get_sb().
   Spec comments should be added to these functions.

--
Ryusuke Konishi (4):
      nilfs2: remove meaningless EBUSY case from nilfs_get_sb function
      nilfs2: stop using sget to check if current mount is there
      nilfs2: stop using sget to acquire nilfs object
      nilfs2: reduce bd_mount_sem use to a minimum

 fs/nilfs2/cpfile.c    |    6 +-
 fs/nilfs2/super.c     |  165 ++++++++++--------------------------------------
 fs/nilfs2/the_nilfs.c |   93 +++++++++++++++++++++++++++-
 fs/nilfs2/the_nilfs.h |    8 ++-
 4 files changed, 135 insertions(+), 137 deletions(-)
-

The "nilfs2: stop using sget to check if current mount is there" and
    "nilfs2: stop using sget to acquire nilfs object"
eliminate two sget() calls from nilfs_get_sb().

The "nilfs2: reduce bd_mount_sem use to a minimum" eliminates
bd_mount_sem use except for ones surrouding an sget() call.

The "nilfs2: remove meaningless EBUSY case from nilfs_get_sb function"
is a trivial fix.


Thanks,
Ryusuke Konishi


