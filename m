Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbYBWS6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbYBWS6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759796AbYBWS60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:58:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:7943 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314AbYBWS6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:58:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=vtNS3cL9g2s5cE2cqwL05fF6Yq8sMWyjwdJGBUkYTFK4KXfhpykg7j0MNsqDJLHvxVloq+S+/TP118CrV90o9QLwOxzRxYmAAEUyK3jc4Aat5Sjg/ffKMih7bapCKRvT0jaXpy0lpvVzqiZ+oXgT/M40X7gP33ZfOkgD88+9UqU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] qd65xx: fix setup of QD6580 Control register
Date: Sat, 23 Feb 2008 16:03:34 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802231603.34732.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Control register of QD6580 should be setup before probing for devices.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
goes after "ide: skip probing port if "hdx=noprobe" was used for both
devices on it" patch in the IDE quilt tree

 drivers/ide/legacy/qd65xx.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -444,6 +444,8 @@ static int __init qd_probe(int base)
 		printk(KERN_DEBUG "qd6580: config=%#x, control=%#x, ID3=%u\n",
 			config, control, QD_ID3);
 
+		outb(QD_DEF_CONTR, QD_CONTROL_PORT);
+
 		if (control & QD_CONTR_SEC_DISABLED) {
 			/* secondary disabled */
 
@@ -460,8 +462,6 @@ static int __init qd_probe(int base)
 
 			ide_device_add(idx, &qd65xx_port_info);
 
-			outb(QD_DEF_CONTR, QD_CONTROL_PORT);
-
 			return 1;
 		} else {
 			ide_hwif_t *mate;
@@ -487,8 +487,6 @@ static int __init qd_probe(int base)
 
 			ide_device_add(idx, &qd65xx_port_info);
 
-			outb(QD_DEF_CONTR, QD_CONTROL_PORT);
-
 			return 0; /* no other qd65xx possible */
 		}
 	}
