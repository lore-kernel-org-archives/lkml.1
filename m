Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZEOGoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZEOGoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 02:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZEOGno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 02:43:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:39325 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbZEOGnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 02:43:42 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/4] nilfs2: remove meaningless EBUSY case from nilfs_get_sb function
Date: Fri, 15 May 2009 15:37:23 +0900
Message-Id: <1242369446-25771-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242369446-25771-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1242369446-25771-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 15 May 2009 15:43:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following EBUSY case in nilfs_get_sb() is meaningless.  Indeed,
this error code is never returned to the caller.

    if (!s->s_root) {
          ...
    } else if (!(s->s_flags & MS_RDONLY)) {
        err = -EBUSY;
    }

This simply removes the else case.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/nilfs2/super.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 6989b03..8131615 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1172,8 +1172,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 
 		s->s_flags |= MS_ACTIVE;
 		need_to_close = 0;
-	} else if (!(s->s_flags & MS_RDONLY)) {
-		err = -EBUSY;
 	}
 
 	up(&sd.bdev->bd_mount_sem);
-- 
1.6.2

