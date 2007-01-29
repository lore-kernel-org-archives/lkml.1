Return-Path: <linux-kernel-owner+w=401wt.eu-S1751465AbXA2UFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbXA2UFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbXA2UFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:05:14 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:13462 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbXA2UFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:05:13 -0500
Date: Mon, 29 Jan 2007 12:04:59 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org
Subject: [git patches] ocfs2 fixes
Message-ID: <20070129200459.GD8176@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
	I made a silly error in my last upstream push. This patch makes
ocfs2 build again.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Mark Fasheh:
      ocfs2: fix thinko in ocfs2_backup_super_blkno()

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index c99e905..e61e218 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -587,7 +587,7 @@ static inline u64 ocfs2_backup_super_blk
 
 	if (index >= 0 && index < OCFS2_MAX_BACKUP_SUPERBLOCKS) {
 		offset <<= (2 * index);
-		offset /= sb->s_blocksize;
+		offset >>= sb->s_blocksize_bits;
 		return offset;
 	}
 
