Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbYBSArk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbYBSArk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYBSAra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:47:30 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:40493 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYBSAr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:47:29 -0500
Message-ID: <47BA271D.9000806@tiscali.nl>
Date: Tue, 19 Feb 2008 01:47:25 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] wireless: Convert to list_for_each_entry_rcu()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please verify, this patch was not yet tested.
---
Convert list_for_each_rcu() to list_for_each_entry_rcu()

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/strip.c b/drivers/net/wireless/strip.c
index 88efe1b..c5aaab8 100644
--- a/drivers/net/wireless/strip.c
+++ b/drivers/net/wireless/strip.c
@@ -963,11 +963,12 @@ static char *time_delta(char buffer[], long time)
 static struct strip *strip_get_idx(loff_t pos) 
 {
 	struct list_head *l;
+	struct strip *str;
 	int i = 0;
 
-	list_for_each_rcu(l, &strip_list) {
+	list_for_each_entry_rcu(str, l, &strip_list, list) {
 		if (pos == i)
-			return list_entry(l, struct strip, list);
+			return str;
 		++i;
 	}
 	return NULL;
