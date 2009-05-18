Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZERHro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZERHro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbZERHrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:47:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:36963 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989AbZERHrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:47:31 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH] istallion: add missing __devexit marking
Date: Mon, 18 May 2009 03:47:30 -0400
Message-Id: <1242632850-16268-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove member of the pci_driver stli_pcidriver uses __devexit_p(),
so the remove function itself should be marked with __devexit.  Even
more so considering the probe function is marked with __devinit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Greg Ungerer <gerg@uclinux.org>
---
 drivers/char/istallion.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index fff19f7..e8392c2 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -3785,7 +3785,7 @@ err:
 	return retval;
 }
 
-static void stli_pciremove(struct pci_dev *pdev)
+static void __devexit stli_pciremove(struct pci_dev *pdev)
 {
 	struct stlibrd *brdp = pci_get_drvdata(pdev);
 
-- 
1.6.3

