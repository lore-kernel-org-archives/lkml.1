Return-Path: <linux-kernel-owner+w=401wt.eu-S1763578AbYFTU1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578AbYFTU1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761155AbYFTUTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:19:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35195 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761122AbYFTUTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:19:49 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 33/70] usb-cypress: There is no 0 case to go with CS5/6/7/8 so
	remove the test
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:02:25 +0100
Message-ID: <20080620200224.1479.48967.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/cypress_m8.c |   37 +++++++++++++++++--------------------
 1 files changed, 17 insertions(+), 20 deletions(-)


diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index bb9c7c4..22837a3 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -1093,27 +1093,24 @@ static void cypress_set_termios(struct tty_struct *tty,
 	} else
 		parity_enable = parity_type = 0;
 
-	if (cflag & CSIZE) {
-		switch (cflag & CSIZE) {
-		case CS5:
-			data_bits = 0;
-			break;
-		case CS6:
-			data_bits = 1;
-			break;
-		case CS7:
-			data_bits = 2;
-			break;
-		case CS8:
-			data_bits = 3;
-			break;
-		default:
-			err("%s - CSIZE was set, but not CS5-CS8",
-					__func__);
-			data_bits = 3;
-	} else
+	switch (cflag & CSIZE) {
+	case CS5:
+		data_bits = 0;
+		break;
+	case CS6:
+		data_bits = 1;
+		break;
+	case CS7:
+		data_bits = 2;
+		break;
+	case CS8:
 		data_bits = 3;
-
+		break;
+	default:
+		err("%s - CSIZE was set, but not CS5-CS8",
+				__func__);
+		data_bits = 3;
+	}
 	spin_lock_irqsave(&priv->lock, flags);
 	oldlines = priv->line_control;
 	if ((cflag & CBAUD) == B0) {

