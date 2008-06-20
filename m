Return-Path: <linux-kernel-owner+w=401wt.eu-S1765695AbYFTUhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765695AbYFTUhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762369AbYFTUXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:23:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58337 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762364AbYFTUXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:23:04 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 56/70] kobil_sct: Fix ioctls
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:05:39 +0100
Message-ID: <20080620200534.1479.52540.stgit@localhost.localdomain>
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

 drivers/usb/serial/kobil_sct.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index f0f8353..deba28e 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -640,9 +640,11 @@ static void kobil_set_termios(struct tty_struct *tty,
 
 	priv = usb_get_serial_port_data(port);
 	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID ||
-			priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID)
+			priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID) {
 		/* This device doesn't support ioctl calls */
+		*tty->termios = *old;
 		return;
+	}
 
 	speed = tty_get_baud_rate(tty);
 	switch (speed) {
@@ -704,7 +706,7 @@ static int kobil_ioctl(struct tty_struct *tty, struct file *file,
 	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID ||
 			priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID)
 		/* This device doesn't support ioctl calls */
-		return 0;
+		return -ENOIOCTLCMD;
 
 	switch (cmd) {
 	case TCFLSH:

