Return-Path: <linux-kernel-owner+w=401wt.eu-S933266AbZHVSvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbZHVSvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 14:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933170AbZHVSvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 14:51:41 -0400
Received: from server1.wserver.cz ([82.113.45.157]:37419 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134AbZHVSvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 14:51:40 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/1] MD: dm-log, fix cn_ulog_callback declaration
Date: Sat, 22 Aug 2009 20:51:41 +0200
Message-Id: <1250967101-29728-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The third parameter of cn_add_callback accepts functions with
void *()(struct cn_msg *)
prototype. Change cn_ulog_callback to match it by removing void *
and adding struct cn_msg * directly.

It's introduced by commit:
connector: make callback argument type explicit

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/md/dm-log-userspace-transfer.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 8ce74d9..d945388 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -129,9 +129,8 @@ static int fill_pkg(struct cn_msg *msg, struct dm_ulog_request *tfr)
  * This is the connector callback that delivers data
  * that was sent from userspace.
  */
-static void cn_ulog_callback(void *data)
+static void cn_ulog_callback(struct cn_msg *msg)
 {
-	struct cn_msg *msg = (struct cn_msg *)data;
 	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
 
 	spin_lock(&receiving_list_lock);
-- 
1.6.3.3

