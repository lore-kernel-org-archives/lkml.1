Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbZL3Tak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbZL3Tak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZL3Taj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:30:39 -0500
Received: from exprod6og102.obsmtp.com ([64.18.1.183]:39598 "HELO
	exprod6og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752816AbZL3Tai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:30:38 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] arch/powerpc/boot/devtree.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 14:30:39 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F65E@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] arch/powerpc/boot/devtree.c: use %pM to show MAC address
Thread-Index: AcqJhpFX52mm8R2tQHCy6qV3E2wwNA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
X-OriginalArrivalTime: 30 Dec 2009 19:30:37.0339 (UTC) FILETIME=[9051E6B0:01CA8986]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/arch/powerpc/boot/devtree.c b/arch/powerpc/boot/devtree.c
index a7e21a3..a2f07a5 100644
--- a/arch/powerpc/boot/devtree.c
+++ b/arch/powerpc/boot/devtree.c
@@ -93,10 +93,7 @@ void dt_fixup_mac_address_by_alias(const char *alias, const u8 *addr)
 	void *devp = find_node_by_alias(alias);
 
 	if (devp) {
-		printf("%s: local-mac-address <-"
-		       " %02x:%02x:%02x:%02x:%02x:%02x\n\r", alias,
-		       addr[0], addr[1], addr[2],
-		       addr[3], addr[4], addr[5]);
+		printf("%s: local-mac-address <- %pM\n\r", alias, addr);
 
 		setprop(devp, "local-mac-address", addr, 6);
 	}
@@ -108,10 +105,7 @@ void dt_fixup_mac_address(u32 index, const u8 *addr)
 	                                     (void*)&index, sizeof(index));
 
 	if (devp) {
-		printf("ENET%d: local-mac-address <-"
-		       " %02x:%02x:%02x:%02x:%02x:%02x\n\r", index,
-		       addr[0], addr[1], addr[2],
-		       addr[3], addr[4], addr[5]);
+		printf("ENET%d: local-mac-address <- %pM\n\r", index, addr);
 
 		setprop(devp, "local-mac-address", addr, 6);
 	} 
