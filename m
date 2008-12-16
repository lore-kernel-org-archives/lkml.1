Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYLPSJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYLPSJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbYLPSIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:08:39 -0500
Received: from cavolo.yandex.ru ([87.250.244.45]:37187 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429AbYLPSIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:08:37 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [w1] Added w1 reset command.
Date: Tue, 16 Dec 2008 21:08:01 +0300
Message-Id: <1229450882-745-4-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1229450882-745-3-git-send-email-zbr@ioremap.net>
References: <1229450882-745-1-git-send-email-zbr@ioremap.net>
 <1229450882-745-2-git-send-email-zbr@ioremap.net>
 <1229450882-745-3-git-send-email-zbr@ioremap.net>
X-Antivirus: Dr.Web (R) for Mail Servers on cavolo.yandex.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Command which allows to reset the bus.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 Documentation/w1/w1.netlink |    6 ++++++
 drivers/w1/w1_netlink.c     |    3 +++
 drivers/w1/w1_netlink.h     |    1 +
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/w1/w1.netlink b/Documentation/w1/w1.netlink
index 4560180..25721af 100644
--- a/Documentation/w1/w1.netlink
+++ b/Documentation/w1/w1.netlink
@@ -112,6 +112,12 @@ cn_msg->len = sizeof(struct w1_netlink_msg) +
 	      sizeof(struct w1_netlink_cmd) +
 	      N*8;
 
+W1 reset command.
+[cn_msg]
+  [w1_netlink_msg type = W1_MASTER_CMD
+  	id is equal to the bus master id to use for searching]
+  [w1_netlink_cmd cmd = W1_CMD_RESET]
+
 Operation steps in w1 core when new command is received.
 =======================================================
 
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index 0267fe4..e807265 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -197,6 +197,9 @@ static int w1_process_command_master(struct w1_master *dev, struct cn_msg *req_m
 		case W1_CMD_TOUCH:
 			err = w1_process_command_io(dev, msg, hdr, cmd);
 			break;
+		case W1_CMD_RESET:
+			err = w1_reset_bus(dev);
+			break;
 		default:
 			cmd->res = EINVAL;
 			cn_netlink_send(msg, 0, GFP_KERNEL);
diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
index 01d86a7..68a4ff4 100644
--- a/drivers/w1/w1_netlink.h
+++ b/drivers/w1/w1_netlink.h
@@ -58,6 +58,7 @@ enum w1_commands {
 	W1_CMD_SEARCH,
 	W1_CMD_ALARM_SEARCH,
 	W1_CMD_TOUCH,
+	W1_CMD_RESET,
 	W1_CMD_MAX,
 };
 
-- 
1.5.6.3

