Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbYCDCF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbYCDCF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbYCDCBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:01:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:10568 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbYCDCBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:01:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CRH2oxFw4C2JcuJ+SoraTUzNwkSMrhMGvJutne34waemt8BBBIijXxTxmIRmlpXcMFPDa9O1aede9pcaTefpc5Ro9PDYh0Z2dUNNJWezth2hdotrpeXvPnfPnlagMd1dTRlllDOm7gCdnydslNE1/BtiHBGnfYHiDgrniWpWg8E=
Subject: [PATCH 12/13] afs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
References: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 18:01:07 -0800
Message-Id: <1204596067.22933.64.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/afs/dir.c      |    4 ++--
 fs/afs/internal.h |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index b58af8f..dfda03d 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -140,7 +140,7 @@ static inline void afs_dir_check_page(struct inode *dir, struct page *page)
 
 	if (page->index == 0 && qty != ntohs(dbuf->blocks[0].pagehdr.npages)) {
 		printk("kAFS: %s(%lu): wrong number of dir blocks %d!=%hu\n",
-		       __FUNCTION__, dir->i_ino, qty,
+		       __func__, dir->i_ino, qty,
 		       ntohs(dbuf->blocks[0].pagehdr.npages));
 		goto error;
 	}
@@ -159,7 +159,7 @@ static inline void afs_dir_check_page(struct inode *dir, struct page *page)
 	for (tmp = 0; tmp < qty; tmp++) {
 		if (dbuf->blocks[tmp].pagehdr.magic != AFS_DIR_MAGIC) {
 			printk("kAFS: %s(%lu): bad magic %d/%d is %04hx\n",
-			       __FUNCTION__, dir->i_ino, tmp, qty,
+			       __func__, dir->i_ino, tmp, qty,
 			       ntohs(dbuf->blocks[tmp].pagehdr.magic));
 			goto error;
 		}
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 5ca3625..637b465 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -758,8 +758,8 @@ void _dbprintk(const char *fmt, ...)
 {
 }
 
-#define kenter(FMT,...)	dbgprintk("==> %s("FMT")",__FUNCTION__ ,##__VA_ARGS__)
-#define kleave(FMT,...)	dbgprintk("<== %s()"FMT"",__FUNCTION__ ,##__VA_ARGS__)
+#define kenter(FMT,...)	dbgprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
+#define kleave(FMT,...)	dbgprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define kdebug(FMT,...)	dbgprintk("    "FMT ,##__VA_ARGS__)
 

@@ -792,8 +792,8 @@ do {							\
 } while (0)
 
 #else
-#define _enter(FMT,...)	_dbprintk("==> %s("FMT")",__FUNCTION__ ,##__VA_ARGS__)
-#define _leave(FMT,...)	_dbprintk("<== %s()"FMT"",__FUNCTION__ ,##__VA_ARGS__)
+#define _enter(FMT,...)	_dbprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
+#define _leave(FMT,...)	_dbprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define _debug(FMT,...)	_dbprintk("    "FMT ,##__VA_ARGS__)
 #endif
 
-- 
1.5.4.3.500.g83a2c


