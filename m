Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbZFXLpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbZFXLpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758177AbZFXLpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:45:34 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:39414 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZFXLpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:45:33 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, gregkh@suse.de, linux-usb@vger.kernel.org,
       oliver@neukum.name,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 3/3] Fix oops when unexisting usb serial device is opened.
Date: Wed, 24 Jun 2009 08:31:17 -0300
Message-Id: <1245843077-4442-3-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1245843077-4442-2-git-send-email-cascardo@holoscopio.com>
References: <1245843077-4442-1-git-send-email-cascardo@holoscopio.com>
 <1245843077-4442-2-git-send-email-cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit 335f8514f200e63d689113d29cb7253a5c282967 has stopped
properly checking if there is any usb serial associated with the tty in
the close function. It happens the close function is called by releasing
the terminal right after opening the device fails.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/usb/serial/usb-serial.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index d595aa5..a842164 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -333,6 +333,9 @@ static void serial_close(struct tty_struct *tty, struct file *filp)
 {
 	struct usb_serial_port *port = tty->driver_data;
 
+	if (!port)
+		return;
+
 	dbg("%s - port %d", __func__, port->number);
 
 
-- 
1.6.3

