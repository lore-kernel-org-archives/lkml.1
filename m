Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966200Ab0BZVb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:31:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:52710 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966162Ab0BZVb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:31:57 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: greg@kroah.com, michaelc@cs.wisc.edu, pjones@redhat.com,
       Joe Perches <joe@perches.com>, Konrad Rzeszutek <ketuzsezr@darnok.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH 1/2] drivers/firmware/iscsi_ibft.c: remove NIPQUAD_FMT, use %pI4
Date: Fri, 26 Feb 2010 21:27:08 +0000
Message-Id: <1267219629-31536-2-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267219629-31536-1-git-send-email-konrad@kernel.org>
References: <1267219629-31536-1-git-send-email-konrad@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 21:30:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Convert netmask to __be32 and format it with %pI4

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Konrad Rzeszutek <ketuzsezr@darnok.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Peter Jones <pjones@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
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
1.7.0

