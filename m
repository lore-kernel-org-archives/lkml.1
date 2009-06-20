Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZFTKb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZFTKb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 06:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZFTKbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 06:31:18 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:48817 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZFTKbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 06:31:17 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] Wireless: nl80211, fix lock imbalance
Date: Sat, 20 Jun 2009 12:31:11 +0200
Message-Id: <1245493871-28817-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't forget to unlock cfg80211_mutex in one fail path of
nl80211_set_wiphy.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 net/wireless/nl80211.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2416856..a62a190 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -447,6 +447,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 
 	rdev = __cfg80211_drv_from_info(info);
 	if (IS_ERR(rdev)) {
+		mutex_unlock(&cfg80211_mutex);
 		result = PTR_ERR(rdev);
 		goto unlock;
 	}
-- 
1.6.3.2

