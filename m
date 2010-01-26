Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061Ab0AZX4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0AZX4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458Ab0AZXzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:55:51 -0500
Received: from kroah.org ([198.145.64.141]:35356 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab0AZXnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:28 2010
Message-Id: <20100126233927.978120025@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ron Mercer <ron.mercer@qlogic.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [54/98] qlge: Remove explicit setting of PCI Dev CTL reg.
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ron Mercer <ron.mercer@qlogic.com>

commit 1d1023d039d8295070b8dbb92c4d972237235304 upstream.

Remove explicit setting of error reporting bits.

Signed-off-by: Ron Mercer <ron.mercer@qlogic.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/qlge/qlge_main.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -3868,8 +3868,7 @@ static int __devinit ql_init_device(stru
 				    struct net_device *ndev, int cards_found)
 {
 	struct ql_adapter *qdev = netdev_priv(ndev);
-	int pos, err = 0;
-	u16 val16;
+	int err = 0;
 
 	memset((void *)qdev, 0, sizeof(*qdev));
 	err = pci_enable_device(pdev);
@@ -3881,19 +3880,6 @@ static int __devinit ql_init_device(stru
 	qdev->ndev = ndev;
 	qdev->pdev = pdev;
 	pci_set_drvdata(pdev, ndev);
-	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
-	if (pos <= 0) {
-		dev_err(&pdev->dev, PFX "Cannot find PCI Express capability, "
-			"aborting.\n");
-		return pos;
-	} else {
-		pci_read_config_word(pdev, pos + PCI_EXP_DEVCTL, &val16);
-		val16 &= ~PCI_EXP_DEVCTL_NOSNOOP_EN;
-		val16 |= (PCI_EXP_DEVCTL_CERE |
-			  PCI_EXP_DEVCTL_NFERE |
-			  PCI_EXP_DEVCTL_FERE | PCI_EXP_DEVCTL_URRE);
-		pci_write_config_word(pdev, pos + PCI_EXP_DEVCTL, val16);
-	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {


