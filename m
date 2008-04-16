Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbYDPXYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbYDPXYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 19:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbYDPXYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 19:24:19 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:6647 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbYDPXYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 19:24:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mKMzNYGQtfBJ5Hnt+ALB/Zumm6aU03R7Q3LDnaJ5j1Jk1g2BL1xdPCmqw1YW+HwBJE3pMvOviXJxb2iOMG9FjTgLwv7Gxzv89afTe6Gw3mIsU7Z1fwuRlFCtbJPSZ1Ed3qxFlnawPiTGhvZch+Z9oyCPmpZ6VihkI9p7nfAb1y4=
Subject: [PATCH-mm 1/5] mac80211: add const where possible in michael.[ch]
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Benc <jbenc@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 16:24:24 -0700
Message-Id: <1208388264.11920.124.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, 5 more cleanup patches for -mm on top of the 3 sent earlier
today.  Setting the stage for a bit more to come later.

 net/mac80211/michael.c |    4 ++--
 net/mac80211/michael.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index a9f5323..30b542e 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -27,7 +27,7 @@ static void michael_block(u32 val, struct michael_mic_ctx *mctx)
 }
 
 void michael_mic_init(struct michael_mic_ctx *mctx,
-		      u8 *key, u8 *da, u8 *sa, u8 priority)
+		      const u8 *key, const u8 *da, const u8 *sa, u8 priority)
 {
 	mctx->l = get_unaligned_le32(key);
 	mctx->r = get_unaligned_le32(key + 4);
@@ -40,7 +40,7 @@ void michael_mic_init(struct michael_mic_ctx *mctx,
 	michael_block(priority, mctx);
 }
 
-void michael_mic(struct michael_mic_ctx *mctx, u8 *data, size_t data_len)
+void michael_mic(struct michael_mic_ctx *mctx, const u8 *data, size_t data_len)
 {
 	u32 val;
 	size_t block, blocks, left;
diff --git a/net/mac80211/michael.h b/net/mac80211/michael.h
index 5976550..c1a0fc6 100644
--- a/net/mac80211/michael.h
+++ b/net/mac80211/michael.h
@@ -19,9 +19,9 @@ struct michael_mic_ctx {
 };
 
 extern void michael_mic_init(struct michael_mic_ctx *mctx,
-		 u8 *key, u8 *da, u8 *sa, u8 priority);
+		 const u8 *key, const u8 *da, const u8 *sa, u8 priority);
 
 extern void michael_mic(struct michael_mic_ctx *mctx,
-		 u8 *data, size_t data_len);
+		 const u8 *data, size_t data_len);
 
 #endif /* MICHAEL_H */
-- 
1.5.5.144.g3e42


