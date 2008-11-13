Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbYKMBy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbYKMBy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 20:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYKMByM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 20:54:12 -0500
Received: from mail.windriver.com ([147.11.1.11]:37112 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbYKMByL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 20:54:11 -0500
From: Kevin Hao <kexin.hao@windriver.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, Alan Cox <alan@redhat.com>, linux-usb@vger.kernel.org
Subject: [PATCH 2/2] add device function for usb serial console
Date: Thu, 13 Nov 2008 09:53:37 +0800
Message-Id: <2fdffab7c5a36049b81ec63f2ee1fbdd4dd25a8a.1226366228.git.kexin.hao@windriver.com>
X-Mailer: git-send-email 1.6.0.3.640.g6331a
In-Reply-To: <23d0e3c26b7580b20c76900e16a53e42950ffaab.1226366228.git.kexin.hao@windriver.com>
References: <1226541217-32673-1-git-send-email-kexin.hao@windriver.com>
 <23d0e3c26b7580b20c76900e16a53e42950ffaab.1226366228.git.kexin.hao@windriver.com>
In-Reply-To: <23d0e3c26b7580b20c76900e16a53e42950ffaab.1226366228.git.kexin.hao@windriver.com>
References: <23d0e3c26b7580b20c76900e16a53e42950ffaab.1226366228.git.kexin.hao@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device funtion for usb serial console, so we can open /dev/console
when we use a usb serial device as console.

Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
---
 drivers/usb/serial/console.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 5b95009..1dbb203 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -241,12 +241,25 @@ static void usb_console_write(struct console *co,
 	}
 }
 
+static struct tty_driver *usb_console_device(struct console *co, int *index)
+{
+	struct tty_driver **p = (struct tty_driver **)co->data;
+
+	if (!*p)
+		return NULL;
+
+	*index = co->index;
+	return (struct tty_driver *)(*p);
+}
+
 static struct console usbcons = {
 	.name =		"ttyUSB",
 	.write =	usb_console_write,
+	.device =	usb_console_device,
 	.setup =	usb_console_setup,
 	.flags =	CON_PRINTBUFFER,
 	.index =	-1,
+	.data = 	&usb_serial_tty_driver,
 };
 
 void usb_serial_console_disconnect(struct usb_serial *serial)
-- 
1.6.0.3.640.g6331a

