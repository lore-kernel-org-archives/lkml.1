Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbYFHSJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbYFHSJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 14:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYFHSJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 14:09:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:19296 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbYFHSJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 14:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=PkLSVxorpW0TtKBNA/d0QTEwtVqb/ttkgoVi23q1YvSrOpeSWBOqqE2yOcvRo4cYon
         zU/iMOBwBSKGe2IS92TakiExIPs7ADn3PN5qksb/0K3HEw1ZWCMapTxrqtJtQepw4yal
         IVsgc+BFTb12iwqrVY8OTWam0JyD7NhmbQURg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] palm_bk3710: add warm-plug support
Date: Sun, 8 Jun 2008 20:09:41 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806082009.41844.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't fail the probe if there are no devices attached to the controller.

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/palm_bk3710.c |    3 ---
 1 file changed, 3 deletions(-)

Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -405,9 +405,6 @@ static int __devinit palm_bk3710_probe(s
 
 	ide_device_add(idx, &palm_bk3710_port_info);
 
-	if (!hwif->present)
-		goto out;
-
 	return 0;
 out:
 	printk(KERN_WARNING "Palm Chip BK3710 IDE Register Fail\n");
