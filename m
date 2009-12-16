Return-Path: <linux-kernel-owner+w=401wt.eu-S934758AbZLPINZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758AbZLPINZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934754AbZLPIM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:12:58 -0500
Received: from mail.perches.com ([173.55.12.10]:1203 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761747AbZLPIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:16 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] drivers/firmware/iscsi_ibft.c: Use %pI4 to print netmask
Date: Wed, 16 Dec 2009 00:09:05 -0800
Message-Id: <1bf6ccc9bbdff4243bc117d12091d6c4a208f71c.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/firmware/iscsi_ibft.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 051d1eb..f82bcda 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -381,7 +381,7 @@ static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
 	void *ibft_loc = entry->header;
 	char *str = buf;
 	char *mac;
-	int val;
+	__be32 val;
 
 	if (!nic)
 		return 0;
@@ -397,10 +397,8 @@ static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
 		str += sprintf_ipaddr(str, nic->ip_addr);
 		break;
 	case ibft_eth_subnet_mask:
-		val = ~((1 << (32-nic->subnet_mask_prefix))-1);
-		str += sprintf(str, NIPQUAD_FMT,
-			       (u8)(val >> 24), (u8)(val >> 16),
-			       (u8)(val >> 8), (u8)(val));
+		val = cpu_to_be32(~((1 << (32-nic->subnet_mask_prefix))-1));
+		str += sprintf(str, "%pI4", &val);
 		break;
 	case ibft_eth_origin:
 		str += sprintf(str, "%d\n", nic->origin);
-- 
1.6.6.rc0.57.gad7a

