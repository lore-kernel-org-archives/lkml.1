Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYC3Pcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYC3Pcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 11:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYC3Pcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 11:32:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:13349 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYC3Pca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 11:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=S/ShvPGLnn6XemCoeUk4OWPwEncqs+2AQklLW2j05cFCK5Q5yCfGJb+RcsUnJWwDXvw0DeEiZwd8ZR98HBmCo4m2ucXM+MTKfz12je1VBIdKxS9k8qu6BvFCx/erofSVztsztvigUP+f3C7mV9nJScyCTEYNCSG42UZ5DaNY2vU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/5] ide-h8300: 32-bit I/O is unsupported
Date: Sun, 30 Mar 2008 17:10:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803301710.45286.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This host driver doesn't support 32-bit I/O (it sets hwif->INSL/OUTSL
to NULL) so IDE_HFLAG_NO_IO_32BIT host flag needs to be set.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/h8300/ide-h8300.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -107,6 +107,7 @@ static int __init h8300_ide_init(void)
 	index = hwif->index;
 	ide_init_port_hw(hwif, &hw);
 	hwif_setup(hwif);
+	hwif->host_flags = IDE_HFLAG_NO_IO_32BIT;
 	printk(KERN_INFO "ide%d: H8/300 generic IDE interface\n", index);
 
 	idx[0] = index;
