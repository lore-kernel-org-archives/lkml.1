Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbYHNQbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbYHNQbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYHNQbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:31:37 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:39854 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYHNQbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:31:36 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, R.E.Wolff@BitWizard.nl
Subject: [PATCH 2/3] Char: sx, fix io unmapping
Date: Thu, 14 Aug 2008 18:25:53 +0200
Message-Id: <1218731154-32692-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1218731154-32692-1-git-send-email-jirislaby@gmail.com>
References: <1218731154-32692-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

board->base is increased for CF cards after mapping. Use board->base2
for unmapping the region, since it holds the original/correct address.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: R.E.Wolff@BitWizard.nl
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
-- 
1.5.6.5

