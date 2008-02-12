Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbYBLXHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbYBLXHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbYBLXHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:07:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:4852 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbYBLXHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:07:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=h9w3LnRxHYpZ9D1gMyrZ19bAvd54IYPoA/0sgjBvsL6ex0pCEJd7mWEbARvO7qsvO1ml/cnKMv0A27bYVKMy/nsLb4dBeJdjEeOmXi89mPtQB5iS9Vg+c8dP1ukj8Qk9S1m3IKKDpW7zcRfIltxfmKEHNINVnxTLRRJKZawcwow=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Ben Collins <ben.collins@ubuntu.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee 1394: be*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:07 +0100
Message-Id: <1202857582-15450-3-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
big_endian_variable = cpu_to_beX(beX_to_cpu(big_endian_variable) +
					expression_in_cpu_byteorder);
with:
	beX_add_cpu(&big_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Collins <ben.collins@ubuntu.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/csr.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ieee1394/csr.c b/drivers/ieee1394/csr.c
index 52ac83e..c90be40 100644
--- a/drivers/ieee1394/csr.c
+++ b/drivers/ieee1394/csr.c
@@ -133,8 +133,7 @@ static void host_reset(struct hpsb_host *host)
                 host->csr.state &= ~0x100;
         }
 
-        host->csr.topology_map[1] =
-                cpu_to_be32(be32_to_cpu(host->csr.topology_map[1]) + 1);
+	be32_add_cpu(&host->csr.topology_map[1], 1);
         host->csr.topology_map[2] = cpu_to_be32(host->node_count << 16
                                                 | host->selfid_count);
         host->csr.topology_map[0] =
@@ -142,8 +141,7 @@ static void host_reset(struct hpsb_host *host)
                             | csr_crc16(host->csr.topology_map + 1,
                                         host->selfid_count + 2));
 
-        host->csr.speed_map[1] =
-                cpu_to_be32(be32_to_cpu(host->csr.speed_map[1]) + 1);
+	be32_add_cpu(&host->csr.speed_map[1], 1);
         host->csr.speed_map[0] = cpu_to_be32(0x3f1 << 16
                                              | csr_crc16(host->csr.speed_map+1,
                                                          0x3f1));
-- 
1.5.3.7

