Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120Ab0AEQli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0AEQli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436Ab0AEQlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:41:15 -0500
Received: from [206.15.93.42] ([206.15.93.42]:6958 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755012Ab0AEQkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:40:37 -0500
X-Greylist: delayed 1092 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 11:40:34 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/firmware/iscsi_ibft.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:37:43 -0700
Cc: netdev@vger.kernel.org, pjones@redhat.com, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050937.43896.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Also, remove the 'mac' variable and use nic->mac directly.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Peter Jones <pjones@redhat.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 051d1eb..5aeb3b5 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -380,7 +380,6 @@ static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
 	struct ibft_nic *nic = entry->nic;
 	void *ibft_loc = entry->header;
 	char *str = buf;
-	char *mac;
 	int val;
 
 	if (!nic)
@@ -421,10 +420,7 @@ static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
 		str += sprintf(str, "%d\n", nic->vlan);
 		break;
 	case ibft_eth_mac:
-		mac = nic->mac;
-		str += sprintf(str, "%02x:%02x:%02x:%02x:%02x:%02x\n",
-			       (u8)mac[0], (u8)mac[1], (u8)mac[2],
-			       (u8)mac[3], (u8)mac[4], (u8)mac[5]);
+		str += sprintf(str, "%pM\n", nic->mac);
 		break;
 	case ibft_eth_hostname:
 		str += sprintf_string(str, nic->hostname_len,
