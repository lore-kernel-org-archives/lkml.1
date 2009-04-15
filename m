Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbZDOGsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbZDOGsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZDOGsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:48:09 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43806 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZDOGsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:48:08 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/3] Char: cyclades, don't kill FW
Date: Wed, 15 Apr 2009 08:47:13 +0200
Message-Id: <1239778034-18099-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1239778034-18099-1-git-send-email-jirislaby@gmail.com>
References: <1239778034-18099-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't reset the PLX chip after FW load, which effectively kills
the FW, so that user had to boot manually.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index bde2458..6d52439 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4932,8 +4932,6 @@ static int __devinit cyz_load_fw(struct pci_dev *pdev, void __iomem *base_addr,
 	cy_writel(&ctl_addr->intr_ctrl_stat, readl(&ctl_addr->intr_ctrl_stat) |
 			0x00030800UL);
 
-	plx_init(pdev, irq, ctl_addr);
-
 	return 0;
 err_rel:
 	release_firmware(fw);
-- 
1.6.2

