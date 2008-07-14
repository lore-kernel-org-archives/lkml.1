Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbYGNMYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbYGNMYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 08:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYGNMYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 08:24:36 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51108 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYGNMYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 08:24:35 -0400
Date: Mon, 14 Jul 2008 21:23:18 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jeff Garzik <jgarzik@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [mmotm] ahci: fix incompatible type warnings
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080714212159.F6E4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patch title: fix-ahci-flags-incompatible-type.patch
Against: mmotm Jul 14
Applies after: linux-next.patch


spin_lock_irqsave() require unsined long.

  drivers/ata/ahci.c: In function 'ahci_transmit_led_message':
  drivers/ata/ahci.c:1287: warning: comparison of distinct pointer types lacks a cast
  drivers/ata/ahci.c:1295: warning: comparison of distinct pointer types lacks a cast
  drivers/ata/ahci.c:1320: warning: comparison of distinct pointer types lacks a cast


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
CC:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: Jeff Garzik <jgarzik@redhat.com>

---
 drivers/ata/ahci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/ahci.c
===================================================================
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1270,7 +1270,7 @@ static ssize_t ahci_transmit_led_message
 	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
 	u32 em_ctl;
 	u32 message[] = {0, 0};
-	unsigned int flags;
+	unsigned long flags;
 	int pmp;
 	struct ahci_em_priv *emp;
 



