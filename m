Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbYAXWeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbYAXWeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbYAXWcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:32:24 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:52041 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133AbYAXWcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:32:22 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: [PATCH 6/9] bfs: coding style cleanup in fs/bfs/file.c
Date: Fri, 25 Jan 2008 01:32:05 +0300
Message-Id: <1201213928-18183-7-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up errors found by checkpatch.pl.

Before the patch:

$ ./scripts/checkpatch.pl --file  fs/bfs/file.c | grep total
total: 6 errors, 0 warnings, 191 lines checked

After the patch:

$ ./scripts/checkpatch.pl --file  fs/bfs/file.c | grep total
total: 0 errors, 0 warnings, 191 lines checked

No functional changes introduced.

This patch was compile-tested by building the BFS driver both
as a module and as a part of the kernel proper.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 fs/bfs/file.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/bfs/file.c b/fs/bfs/file.c
index b11e63e..f32b2a2 100644
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -55,7 +55,7 @@ static int bfs_move_blocks(struct super_block *sb, unsigned long start,
 
 	dprintf("%08lx-%08lx->%08lx\n", start, end, where);
 	for (i = start; i <= end; i++)
-		if(bfs_move_block(i, where + i, sb)) {
+		if (bfs_move_block(i, where + i, sb)) {
 			dprintf("failed to move block %08lx -> %08lx\n", i,
 								where + i);
 			return -EIO;
@@ -77,7 +77,7 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 	if (!create) {
 		if (phys <= bi->i_eblock) {
 			dprintf("c=%d, b=%08lx, phys=%09lx (granted)\n",
-                                create, (unsigned long)block, phys);
+					create, (unsigned long)block, phys);
 			map_bh(bh_result, sb, phys);
 		}
 		return 0;
@@ -88,7 +88,7 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 	 * range of blocks allocated for this file, we can grant it.
 	 */
 	if (bi->i_sblock && (phys <= bi->i_eblock)) {
-		dprintf("c=%d, b=%08lx, phys=%08lx (interim block granted)\n", 
+		dprintf("c=%d, b=%08lx, phys=%08lx (interim block granted)\n",
 				create, (unsigned long)block, phys);
 		map_bh(bh_result, sb, phys);
 		return 0;
@@ -107,7 +107,7 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 	 * anywhere.
 	 */
 	if (bi->i_eblock == info->si_lf_eblk) {
-		dprintf("c=%d, b=%08lx, phys=%08lx (simple extension)\n", 
+		dprintf("c=%d, b=%08lx, phys=%08lx (simple extension)\n",
 				create, (unsigned long)block, phys);
 		map_bh(bh_result, sb, phys);
 		info->si_freeb -= phys - bi->i_eblock;
@@ -126,7 +126,7 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 	}
 
 	if (bi->i_sblock) {
-		err = bfs_move_blocks(inode->i_sb, bi->i_sblock, 
+		err = bfs_move_blocks(inode->i_sb, bi->i_sblock,
 						bi->i_eblock, phys);
 		if (err) {
 			dprintf("failed to move ino=%08lx -> fs corruption\n",
@@ -137,7 +137,7 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 		err = 0;
 
 	dprintf("c=%d, b=%08lx, phys=%08lx (moved)\n",
-                create, (unsigned long)block, phys);
+			create, (unsigned long)block, phys);
 	bi->i_sblock = phys;
 	phys += block;
 	info->si_lf_eblk = bi->i_eblock = phys;
-- 
1.5.3

