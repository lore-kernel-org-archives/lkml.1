Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbYG2Aha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbYG2Aha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYG2AhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:37:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:35396 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYG2AhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:37:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jk3djaYBDLiLCDj/Y6TnT2DfR24Q7USu7VO3iDdyN7iXUZpX413LIU9AoNCh8gffqo
         WZ33AzpgmnU8cMD6RLo/itKkgGFSXNLn+JHPSpMhj8GfsIFLRByk5EUtjNWP02AeMRN4
         G9ZM06Qej5xcS2q968m2D+usS1nElNsToNi7w=
Subject: [PATCH] omfs: fix sparse signedness warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 17:37:08 -0700
Message-Id: <1217291828.23389.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/omfs/bitmap.c:74:18: warning: incorrect type in argument 2 (different signedness)
fs/omfs/bitmap.c:74:18:    expected unsigned long volatile *addr
fs/omfs/bitmap.c:74:18:    got long *<noident>
fs/omfs/bitmap.c:77:20: warning: incorrect type in argument 2 (different signedness)
fs/omfs/bitmap.c:77:20:    expected unsigned long volatile *addr
fs/omfs/bitmap.c:77:20:    got long *<noident>
fs/omfs/bitmap.c:112:17: warning: incorrect type in argument 2 (different signedness)
fs/omfs/bitmap.c:112:17:    expected unsigned long volatile *addr
fs/omfs/bitmap.c:112:17:    got long *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Sorry, missed these in my other sparse warning fixes, feel free to fold it
with the other one.

 fs/omfs/bitmap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/omfs/bitmap.c b/fs/omfs/bitmap.c
index dc75f22..697663b 100644
--- a/fs/omfs/bitmap.c
+++ b/fs/omfs/bitmap.c
@@ -71,10 +71,10 @@ static int set_run(struct super_block *sb, int map,
 		}
 		if (set) {
 			set_bit(bit, sbi->s_imap[map]);
-			set_bit(bit, (long *) bh->b_data);
+			set_bit(bit, (unsigned long *)bh->b_data);
 		} else {
 			clear_bit(bit, sbi->s_imap[map]);
-			clear_bit(bit, (long *) bh->b_data);
+			clear_bit(bit, (unsigned long *)bh->b_data);
 		}
 	}
 	mark_buffer_dirty(bh);
@@ -109,7 +109,7 @@ int omfs_allocate_block(struct super_block *sb, u64 block)
 		if (!bh)
 			goto out;
 
-		set_bit(bit, (long *) bh->b_data);
+		set_bit(bit, (unsigned long *)bh->b_data);
 		mark_buffer_dirty(bh);
 		brelse(bh);
 	}
-- 
1.6.0.rc1.154.ge3fc



