Return-Path: <linux-kernel-owner+w=401wt.eu-S1161175AbXAZS4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161175AbXAZS4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161177AbXAZS4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:56:53 -0500
Received: from agminet02.oracle.com ([141.146.126.229]:47689 "EHLO
	agminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161175AbXAZS4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:56:51 -0500
Date: Fri, 26 Jan 2007 10:46:59 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - build failure
Message-ID: <20070126184659.GA8176@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <45B89008.9000809@eyal.emu.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B89008.9000809@eyal.emu.id.au>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 10:10:00PM +1100, Eyal Lebedinsky wrote:
> WARNING: "__udivdi3" [fs/ocfs2/ocfs2.ko] undefined!

Doh! This one is almost definitely my fault. Does the attached patch get rid
of that warning for you?


From: Mark Fasheh <mark.fasheh@oracle.com>
ocfs2: fix thinko in ocfs2_backup_super_blkno()

Fix a bug which was introduced when I synced up ocfs2_fs.h with ocfs2-tools.
We can't do u64/u32 in kernel.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index c99e905..e61e218 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -587,7 +587,7 @@ static inline u64 ocfs2_backup_super_blkno(struct super_block *sb, int index)
 
 	if (index >= 0 && index < OCFS2_MAX_BACKUP_SUPERBLOCKS) {
 		offset <<= (2 * index);
-		offset /= sb->s_blocksize;
+		offset >>= sb->s_blocksize_bits;
 		return offset;
 	}
 
-- 
1.4.4.2

