Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbZLZN6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbZLZN6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 08:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbZLZN6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 08:58:43 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58416 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZLZN6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 08:58:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=WQyHPspOQ7fBMEsTbA2uVvoyXC1G70rDm1GSx+MRR61y95IvpxNauZEffZeemALcWV
         hZzWmZgCU2LP6fM3bMfJIk3zUYbgk1tF1PzVPbsrkx6avCKIY5C12/H5Dfygaqqyvccf
         5704mCPP4Vg+K3pHsL3HWpZn0B/oWoRvWiZ5c=
MIME-Version: 1.0
Date: Sat, 26 Dec 2009 16:58:39 +0300
Message-ID: <2a20a1830912260558qe31c445te452d57b77979e87@mail.gmail.com>
Subject: [PATCH] fsb ecc don't work correctly on any intel cpu but the xeon! 
	fixed.
From: Konstantin Olifer <kolifer@gmail.com>
To: mark.gross@intel.com, dougthompson@xmission.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Kernel 2.6.32 e752x_edac suppose that fsb ECC exist, for example, on
Celeron + 3100. That is wrong. ECC FSB supported only on Xeon for our
vision and datasheet from developer intel www. Fixed.

Thank you.

Wish a Happy Christmas and Happy New Year!


Best regards,
Konstantin




--- ./linux-2.6.32/drivers/edac/e752x_edac.c.orig	2009-12-03
06:51:21.000000000 +0300
+++ ./linux-2.6.32/drivers/edac/e752x_edac.c	2009-12-26 16:29:14.000000000 +0300
@@ -1072,11 +1072,8 @@ fail:
 }

 /* Setup system bus parity mask register.
- * Sysbus parity supported on:
- *   e7320/e7520/e7525 + Xeon
- *   i3100 + Xeon/Celeron
- * Sysbus parity not supported on:
- *   i3100 + Pentium M/Celeron M/Core Duo/Core2 Duo
+ * Sysbus parity supported _only on_:
+ * e7320/e7520/e7525 + Xeon
  */
 static void e752x_init_sysbus_parity_mask(struct e752x_pvt *pvt)
 {
@@ -1084,13 +1081,11 @@ static void e752x_init_sysbus_parity_mas
 	struct pci_dev *dev = pvt->dev_d0f1;
 	int enable = 1;

-	/* Allow module parameter override, else see if CPU supports parity */
+	/* Allow module paramter override, else see if CPU supports parity */
 	if (sysbus_parity != -1) {
 		enable = sysbus_parity;
 	} else if (cpu_id[0] &&
-		   ((strstr(cpu_id, "Pentium") && strstr(cpu_id, " M ")) ||
-		    (strstr(cpu_id, "Celeron") && strstr(cpu_id, " M ")) ||
-		    (strstr(cpu_id, "Core") && strstr(cpu_id, "Duo")))) {
+		   !strstr(cpu_id, "Xeon")) {
 		e752x_printk(KERN_INFO, "System Bus Parity not "
 			     "supported by CPU, disabling\n");
 		enable = 0;
