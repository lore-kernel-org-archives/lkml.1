Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbZLTTlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbZLTTlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbZLTTlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:41:21 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:40426 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755634AbZLTTlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:41:13 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-scsi@vger.kernel.org
Subject: [PATCH 1/3] g_NCR5380: remove misleading pnp error message
Date: Sun, 20 Dec 2009 20:41:05 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1538
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912202041.06891.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove misleading error message that appears after pnp card has been detected
correctly.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-source-2.6.32-orig/drivers/scsi/g_NCR5380.c	2009-12-03 04:51:21.000000000 +0100
+++ linux-source-2.6.32/drivers/scsi/g_NCR5380.c	2009-12-18 21:03:01.000000000 +0100
@@ -322,10 +322,8 @@ int __init generic_NCR5380_detect(struct
 		while ((dev = pnp_find_dev(NULL, ISAPNP_VENDOR('D', 'T', 'C'), ISAPNP_FUNCTION(0x436e), dev))) {
 			if (count >= NO_OVERRIDES)
 				break;
-			if (pnp_device_attach(dev) < 0) {
-				printk(KERN_ERR "dtc436e probe: attach failed\n");
+			if (pnp_device_attach(dev) < 0)
 				continue;
-			}
 			if (pnp_activate_dev(dev) < 0) {
 				printk(KERN_ERR "dtc436e probe: activate failed\n");
 				pnp_device_detach(dev);


-- 
Ondrej Zary
