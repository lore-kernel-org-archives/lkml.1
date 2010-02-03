Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab0BCQnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:43:50 -0500
Received: from sh.osrg.net ([192.16.179.4]:33378 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab0BCQnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:43:47 -0500
Date: Thu, 04 Feb 2010 01:43:41 +0900 (JST)
Message-Id: <20100204.014341.15330463.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fix for 2.6.33
From: Ryusuke Konishi <ryusuke@osrg.net>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 04 Feb 2010 01:43:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive a small bugfix of nilfs2, which corrects a potential data
integrity issue on unmount.

Thanks!

Ryusuke Konishi
--
The following changes since commit abe94c756c08d50566c09a65b9c7fe72f83071c5:
  Linus Torvalds (1):
        Linux 2.6.33-rc6

Ryusuke Konishi (1):
      nilfs2: fix potential leak of dirty data on umount

 fs/nilfs2/segment.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 17584c5..105b508 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2829,7 +2829,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 		|| sci->sc_seq_request != sci->sc_seq_done);
 	spin_unlock(&sci->sc_state_lock);
 
-	if (flag || nilfs_segctor_confirm(sci))
+	if (flag || !nilfs_segctor_confirm(sci))
 		nilfs_segctor_write_out(sci);
 
 	WARN_ON(!list_empty(&sci->sc_copied_buffers));
