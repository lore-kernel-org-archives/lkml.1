Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbYFBKB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbYFBKB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYFBJ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:59:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32976 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYFBJ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:59:05 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] cifs endianness fixes
Cc: sfrench@samba.org, linux-kernel@vger.kernel.org
Message-Id: <E1K36og-0007Z3-Hm@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 02 Jun 2008 10:59:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__le16 fields used as host-endian.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 9b8b4cf..fb655b4 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3927,9 +3927,9 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 	}
 
 	ref = (struct dfs_referral_level_3 *) &(pSMBr->referrals);
-	if (ref->VersionNumber != 3) {
+	if (ref->VersionNumber != cpu_to_le16(3)) {
 		cERROR(1, ("Referrals of V%d version are not supported,"
-			"should be V3", ref->VersionNumber));
+			"should be V3", le16_to_cpu(ref->VersionNumber)));
 		rc = -EINVAL;
 		goto parse_DFS_referrals_exit;
 	}
@@ -3977,7 +3977,7 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 		if (rc)
 			goto parse_DFS_referrals_exit;
 
-		ref += ref->Size;
+		ref += le16_to_cpu(ref->Size);
 	}
 
 parse_DFS_referrals_exit:
