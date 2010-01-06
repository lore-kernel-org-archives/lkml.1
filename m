Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502Ab0AFBUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0AFBUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 20:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108Ab0AFBUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 20:20:44 -0500
Received: from mail.perches.com ([173.55.12.10]:1531 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab0AFBU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 20:20:27 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] drivers/firmware/iscsi_ibft.c: Remove NIPQUAD_FMT, use %pI4
Date: Tue,  5 Jan 2010 17:20:20 -0800
Message-Id: <766ed51e51647b8f8e08a020d62346657a37b9df.1262726222.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1262726222.git.joe@perches.com>
References: <cover.1262726222.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert netmask to __be32 and format it with %pI4

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

