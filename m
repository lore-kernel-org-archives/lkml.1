Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbYKLPQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbYKLPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYKLPQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:16:19 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45703 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbYKLPQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:16:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: add explicit padding in struct ieee80211_tx_info
Date: Wed, 12 Nov 2008 10:05:37 -0500
Message-Id: <1226502337-11085-1-git-send-email-linville@tuxdriver.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <Pine.LNX.4.64.0811120854290.13217@anakin>
References: <Pine.LNX.4.64.0811120854290.13217@anakin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, the BUILD_BUG_ON calls in ieee80211_tx_info_clear_status can
fail on some architectures.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Why do we have those BUILD_BUG_ON calls anyway?  Hmmm...

 include/net/mac80211.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index feb52cc..38302d6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -333,6 +333,7 @@ struct ieee80211_tx_info {
 	u8 antenna_sel_tx;
 
 	/* 2 byte hole */
+	u8 pad[2];
 
 	union {
 		struct {
-- 
1.5.4.3

