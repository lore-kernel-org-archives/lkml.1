Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778Ab0BQAfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:35:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:35768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933626Ab0BQAfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:35:08 -0500
From: Konrad Rzeszutek Wilk <kliw@darnok.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
       Konrad Rzeszutek <ketuzsezr@darnok.org>,
       Peter Jones <pjones@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Konrad Rzeszutek Wilk <kliw@darnok.org>
Subject: [PATCH] drivers/firmware/iscsi_ibft.c: remove NIPQUAD_FMT, use %pI4
Date: Wed, 17 Feb 2010 00:33:03 +0000
Message-Id: <1266366783-851-2-git-send-email-kliw@darnok.org>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1266366783-851-1-git-send-email-kliw@darnok.org>
References: <1266366783-851-1-git-send-email-kliw@darnok.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Feb 2010 00:33:12 +0000 (UTC)
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
Signed-off-by: Konrad Rzeszutek Wilk <kliw@darnok.org>
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

