Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbZBAKzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbZBAKzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 05:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZBAKzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 05:55:10 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:23442 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZBAKzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 05:55:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=odj67auarUc6CzU/QprgP4sePFANAZTBB3RCdWsoolqhhKhQJkka7kVWugCm6qlAcQ
         9+LCOrq/M3nVzJ9ecI5+VwPswiL6brPW6CBshaD4B6hRn4f0Qcpb/YS+Dh0b1xmFUDKd
         tQW3nCIPgVCemMkhaLED3+lbfOsG531vYM04c=
Message-ID: <49857F7E.9090708@gmail.com>
Date: Sun, 01 Feb 2009 18:54:54 +0800
From: Dave Young <hidave.darkstar@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081010)
MIME-Version: 1.0
To: wgreathouse@smva.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] usb-serial: fix the aircable_init failure path
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The failure path of aircable_init is wrong, fix the order of (goto) labels.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
drivers/usb/serial/aircable.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff -uprN a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
--- a/drivers/usb/serial/aircable.c	2009-02-01 13:12:35.000000000 +0800
+++ b/drivers/usb/serial/aircable.c	2009-02-01 13:26:28.000000000 +0800
@@ -621,9 +621,9 @@ static int __init aircable_init(void)
 		goto failed_usb_register;
 	return 0;
 
-failed_serial_register:
-	usb_serial_deregister(&aircable_device);
 failed_usb_register:
+	usb_serial_deregister(&aircable_device);
+failed_serial_register:
 	return retval;
 }
 
