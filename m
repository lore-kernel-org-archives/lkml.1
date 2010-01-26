Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074Ab0AZXnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0AZXnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995Ab0AZXnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:01 -0500
Received: from kroah.org ([198.145.64.141]:35080 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab0AZXm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:42:58 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:21 2010
Message-Id: <20100126233921.499771376@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ajit Khaparde <ajitk@serverengines.com>,
       "David S. Miller" <davem@davemloft.net>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [05/98] be2net: Add support for next generation of BladeEngine device.
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ajit Khaparde <ajitk@serverengines.com>

commit 12d7ea2c5a5c87834daf9fcd920aab80ff6248b1 upstream.

Add new PCI ids to support next generation of BladeEngine device.

Signed-off-by: Ajit Khaparde <ajitk@serverengines.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/benet/be.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/net/benet/be.h
+++ b/drivers/net/benet/be.h
@@ -35,20 +35,31 @@
 #define DRV_VER			"2.101.205"
 #define DRV_NAME		"be2net"
 #define BE_NAME			"ServerEngines BladeEngine2 10Gbps NIC"
+#define BE3_NAME		"ServerEngines BladeEngine3 10Gbps NIC"
 #define OC_NAME			"Emulex OneConnect 10Gbps NIC"
+#define OC_NAME1		"Emulex OneConnect 10Gbps NIC (be3)"
 #define DRV_DESC		BE_NAME "Driver"
 
 #define BE_VENDOR_ID 		0x19a2
 #define BE_DEVICE_ID1		0x211
+#define BE_DEVICE_ID2		0x221
 #define OC_DEVICE_ID1		0x700
 #define OC_DEVICE_ID2		0x701
+#define OC_DEVICE_ID3		0x710
 
 static inline char *nic_name(struct pci_dev *pdev)
 {
-	if (pdev->device == OC_DEVICE_ID1 || pdev->device == OC_DEVICE_ID2)
+	switch (pdev->device) {
+	case OC_DEVICE_ID1:
+	case OC_DEVICE_ID2:
 		return OC_NAME;
-	else
+	case OC_DEVICE_ID3:
+		return OC_NAME1;
+	case BE_DEVICE_ID2:
+		return BE3_NAME;
+	default:
 		return BE_NAME;
+	}
 }
 
 /* Number of bytes of an RX frame that are copied to skb->data */


