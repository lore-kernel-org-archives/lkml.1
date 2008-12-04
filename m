Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYLDOwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYLDOwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbYLDOuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:50:13 -0500
Received: from cavolo.yandex.ru ([87.250.244.45]:54004 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481AbYLDOuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:50:12 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [W1] W1 search/alarm search documentation.
Date: Thu,  4 Dec 2008 17:50:10 +0300
Message-Id: <12284022154052-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <1228402214589-git-send-email-zbr@ioremap.net>
References: <12284022104086-git-send-email-zbr@ioremap.net>
 <122840221468-git-send-email-zbr@ioremap.net>
 <12284022143564-git-send-email-zbr@ioremap.net>
 <12284022144105-git-send-email-zbr@ioremap.net>
 <12284022141659-git-send-email-zbr@ioremap.net>
 <1228402214589-git-send-email-zbr@ioremap.net>
X-Antivirus: Dr.Web (R) for Mail Servers on cavolo.yandex.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 Documentation/w1/w1.netlink |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/Documentation/w1/w1.netlink b/Documentation/w1/w1.netlink
index eae5c8b..c98ca30 100644
--- a/Documentation/w1/w1.netlink
+++ b/Documentation/w1/w1.netlink
@@ -74,7 +74,23 @@ format:
 	Each message is at most 4k in size, so if number of master devices
 	exceeds this, it will be split into several messages, cn.seq will be
 	increased for each one.
-	
+
+W1 search and alarm search commands.
+request:
+[cn_msg]
+  [w1_netlink_msg type = W1_MASTER_CMD id is equal to the bus master id to use for searching]
+  [w1_netlink_cmd cmd = W1_CMD_SEARCH or W1_CMD_ALARM_SEARCH]
+
+reply:
+  [cn_msg, ack = 1 and increasing, 0 means the last message, seq is equal to the request seq]
+  [w1_netlink_msg type = W1_MASTER_CMD]
+  [w1_netlink_cmd cmd = W1_CMD_SEARCH or W1_CMD_ALARM_SEARCH
+	len is equal to number of IDs multiplied by 8]
+  [64bit-id0 ... 64bit-idN]
+Length in each header corresponds to the size of the data behind it, so
+w1_netlink_cmd->len = N * 8; where N is number of IDs in this message. Can be zero.
+w1_netlink_msg->len = sizeof(struct w1_netlink_cmd) + N * 8;
+cn_msg->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd) + N*8;
 
 Operation steps in w1 core when new command is received.
 =======================================================
-- 
1.5.2.5

