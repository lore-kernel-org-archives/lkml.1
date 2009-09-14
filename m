Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZINK1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZINK1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbZINK1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:27:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:35945 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753992AbZINK1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:27:07 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+ZOhkeQK6Zvh1lXrkSGmS1dDabplPk27CfoWu/bZ
	aHBLauQUcpXa3Q
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net,
       Harald Welte <laforge@gnumonks.org>,
       Harald Welte <HaraldWelte@viatech.com>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/4] viafb: pass reference to pci device when calling framebuffer_alloc()
Date: Mon, 14 Sep 2009 10:30:06 +0000
Message-Id: <1252924206-3721-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1252924206-3721-3-git-send-email-FlorianSchandinat@gmx.de>
References: <1252924206-3721-1-git-send-email-FlorianSchandinat@gmx.de>
 <1252924206-3721-2-git-send-email-FlorianSchandinat@gmx.de>
 <1252924206-3721-3-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Welte <laforge@gnumonks.org>

viafb: pass reference to pci device when calling framebuffer_alloc()

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 463d92a..48e663b 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1816,7 +1816,8 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	 * variables
 	*/
 	viafbinfo = framebuffer_alloc(viafb_par_length +
-		ALIGN(sizeof(struct viafb_shared), BITS_PER_LONG/8), NULL);
+		ALIGN(sizeof(struct viafb_shared), BITS_PER_LONG/8),
+		&pdev->dev);
 	if (!viafbinfo) {
 		printk(KERN_ERR"Could not allocate memory for viafb_info.\n");
 		return -ENODEV;
@@ -1941,7 +1942,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	default_var.vsync_len = 4;
 
 	if (viafb_dual_fb) {
-		viafbinfo1 = framebuffer_alloc(viafb_par_length, NULL);
+		viafbinfo1 = framebuffer_alloc(viafb_par_length, &pdev->dev);
 		if (!viafbinfo1) {
 			printk(KERN_ERR
 			"allocate the second framebuffer struct error\n");
-- 
1.6.3.2

