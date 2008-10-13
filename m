Return-Path: <linux-kernel-owner+w=401wt.eu-S1759929AbYJMJha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbYJMJha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbYJMJeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:34:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56142 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758385AbYJMJeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:34:21 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 15/80] Char: sx, fix io unmapping
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:34:18 +0100
Message-ID: <20081013093414.21645.5870.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

board->base is increased for CF cards after mapping. Use board->base2
for unmapping the region, since it holds the original/correct address.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/sx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index c385206..5b8d7a1 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -2504,7 +2504,7 @@ static void __devexit sx_remove_card(struct sx_board *board,
 		del_timer(&board->timer);
 		if (pdev) {
 #ifdef CONFIG_PCI
-			pci_iounmap(pdev, board->base);
+			pci_iounmap(pdev, board->base2);
 			pci_release_region(pdev, IS_CF_BOARD(board) ? 3 : 2);
 #endif
 		} else {
@@ -2703,7 +2703,7 @@ static int __devinit sx_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 err_unmap:
-	pci_iounmap(pdev, board->base);
+	pci_iounmap(pdev, board->base2);
 err_reg:
 	pci_release_region(pdev, reg);
 err_flag:

