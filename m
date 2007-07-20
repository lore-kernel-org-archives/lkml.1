Return-Path: <linux-kernel-owner+w=401wt.eu-S1762994AbXGTDwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994AbXGTDwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXGTDwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:52:06 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:46123 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbXGTDwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:subject;
        b=nlwWfqFnb8voNmU7zgWjVK3x5DLXYXV2FaQoj0JpGP1ZnMj9XKW/ZSlg6h/52ZDIKp54lKefLX0/N9BC4M+qGxpY5lsD/7yVF9T8i6dVTJ2jxXt2A1FVotuk2hn9ih0/awohBNjOqL7JkM+GGzBCSMxU/4vh3gGo82+Q5hRy4Wc=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Jul 2007 12:50:58 +0900
Message-Id: <20070720035058.25300.28389.sendpatchset@clockwork.opensource.se>
Subject: pata_platform: Fix NULL pointer dereference
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pata_platform: Fix NULL pointer dereference

pata_platform currently dereferences a NULL pointer in pata_platform_probe()
if pdev->dev.platform_data is set to NULL. This breakage was most likely
introduced by commit 5f45bc50976ee1f408f7171af155aec646655a37.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Tested on a Solution Engline 7722 board, fixes NULL dereference problem.
 Applies to linux-2.6 git 9a79b2274186fade17134929d4f85b70d59a3840
 Could someone please make sure this gets included in rc1?

 drivers/ata/pata_platform.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- 0001/drivers/ata/pata_platform.c
+++ work/drivers/ata/pata_platform.c	2007-07-20 12:09:04.000000000 +0900
@@ -213,8 +213,9 @@ static int __devinit pata_platform_probe
 	pata_platform_setup_port(&ap->ioaddr, pp_info);
 
 	/* activate */
-	return ata_host_activate(host, platform_get_irq(pdev, 0), ata_interrupt,
-				 pp_info->irq_flags, &pata_platform_sht);
+	return ata_host_activate(host, platform_get_irq(pdev, 0),
+				 ata_interrupt, pp_info ? pp_info->irq_flags
+				 : 0, &pata_platform_sht);
 }
 
 /**
