Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYETSNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYETSNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932337AbYETSHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:07:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:6983 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765279AbYETSHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:07:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jXOdFH0QUCZcqw6nPxDuJkzNVdtkTT/bUbcvHY341G3ESscbYhR3Ao3V2C3TsFBDAVRMwPRNbePrOx4CddMKfhoGnmzo+r+yo1MNnPQyGE1fYuOpdCfCUD6F4GsIQsoSdF6Ba+0rZ21gnLffBsUa//WkhAWMiNMDP9ejH32vD40=
Subject: [PATCH 12/21] cifs: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:21 -0700
Message-Id: <1211306781.5915.185.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/cifs/inode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index fcbdbb6..6271e9f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -317,8 +317,8 @@ static int decode_sfu_inode(struct inode *inode, __u64 size,
 					/* we have enough to decode dev num */
 					__u64 mjr; /* major */
 					__u64 mnr; /* minor */
-					mjr = le64_to_cpu(*(__le64 *)(pbuf+8));
-					mnr = le64_to_cpu(*(__le64 *)(pbuf+16));
+					mjr = get_le64(pbuf + 8);
+					mnr = get_le64(pbuf + 16);
 					inode->i_rdev = MKDEV(mjr, mnr);
 				}
 			} else if (memcmp("IntxCHR", pbuf, 8) == 0) {
@@ -328,8 +328,8 @@ static int decode_sfu_inode(struct inode *inode, __u64 size,
 					/* we have enough to decode dev num */
 					__u64 mjr; /* major */
 					__u64 mnr; /* minor */
-					mjr = le64_to_cpu(*(__le64 *)(pbuf+8));
-					mnr = le64_to_cpu(*(__le64 *)(pbuf+16));
+					mjr = get_le64(pbuf + 8);
+					mnr = get_le64(pbuf + 16);
 					inode->i_rdev = MKDEV(mjr, mnr);
 				}
 			} else if (memcmp("IntxLNK", pbuf, 7) == 0) {
-- 
1.5.5.1.570.g26b5e


