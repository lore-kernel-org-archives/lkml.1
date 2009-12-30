Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbZL3Ttn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbZL3Ttn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZL3Ttm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:49:42 -0500
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:60801 "HELO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753173AbZL3Ttl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:49:41 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/firmware/iscsi_ibft.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 14:49:41 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F669@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/firmware/iscsi_ibft.c: use %pM to show MAC address
Thread-Index: AcqJiTqVQpvS3vMMRXqimQvTLzOhiA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <pjones@redhat.com>
X-OriginalArrivalTime: 30 Dec 2009 19:49:40.0308 (UTC) FILETIME=[39952140:01CA8989]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Also, remove the 'mac' variable and use nic->mac directly.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Peter Jones <pjones@redhat.com>

---

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
