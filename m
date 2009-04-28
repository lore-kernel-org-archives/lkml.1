Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZD1TxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZD1TxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZD1TxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:53:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33223 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbZD1TxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=PB8wpjYl2wreej/hiKcAqKfTnWzBDYJUE8MeEGMUGHmXZoVdiOu/PFM12Ni5nfcMdL
         3S28q65XebQt1It5+JFUoj+WQANzPaiIPIUA1gl7Ks4GtaqkZ0t47FYJ20XIVZJhQ5BP
         2sv7NMLcDapbqDvhLXo0Y4x854rV5WUGr0Ixo=
MIME-Version: 1.0
Date: Tue, 28 Apr 2009 15:53:02 -0400
Message-ID: <cb0375e10904281253y67349baaq6588a3933720f89b@mail.gmail.com>
Subject: [PATCH] Fix makefile so that CONFIG_WDM and CONFIG_TMC work.
From: Andrew Lutomirski <amluto@gmail.com>
To: gregkh@suse.de,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <amluto@gmail.com>

If CONFIG_USB_ACM and CONFIG_USB_PRINTER are not set, then
cdc-wdm and usbtmc won't get built.

Signed-off-by: Andy Lutomirski <amluto@gmail.com>

---

I hit this on a custom kernel for an embedded system with a TMC device.

diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index b2ceb4a..09b6783 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -26,6 +26,8 @@ obj-$(CONFIG_USB_WUSB)		+= wusbcore/

 obj-$(CONFIG_USB_ACM)		+= class/
 obj-$(CONFIG_USB_PRINTER)	+= class/
+obj-$(CONFIG_USB_WDM)		+= class/
+obj-$(CONFIG_USB_TMC)		+= class/

 obj-$(CONFIG_USB_STORAGE)	+= storage/
 obj-$(CONFIG_USB)		+= storage/
