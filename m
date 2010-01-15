Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240Ab0AOAxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0AOAxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166Ab0AOAxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:53:32 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:50863 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0AOAxb (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 14 Jan 2010 19:53:31 -0500
From: Konrad Rzeszutek Wilk <ketuzsezr@darnok.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, michaelc@cs.wisc.edu,
       pjones@redhat.com, James.Bottomley@HansenPartnership.com,
       akpm@linux-foundation.org, Konrad Rzeszutek Wilk <ketuzsezr@darnok.org>
Subject: [PATCH] drivers/firmware/iscsi_ibft.c: remove NIPQUAD_FMT, use %pI4
Date: Thu, 14 Jan 2010 19:47:30 -0500
Message-Id: <1263516450-18720-2-git-send-email-ketuzsezr@darnok.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1263516450-18720-1-git-send-email-ketuzsezr@darnok.org>
References: <1263516450-18720-1-git-send-email-ketuzsezr@darnok.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B4FBC38.008D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Convert netmask to __be32 and format it with %pI4

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Peter Jones <pjones@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Konrad Rzeszutek Wilk <ketuzsezr@darnok.org>
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
1.6.2.5

