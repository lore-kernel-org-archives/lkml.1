Return-Path: <linux-kernel-owner+w=401wt.eu-S965345AbXBTQNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345AbXBTQNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965347AbXBTQNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:13:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965345AbXBTQNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:13:08 -0500
Date: Tue, 20 Feb 2007 11:13:07 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@pol.net
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070220161306.23688.53776.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: change rivafb_remove to __devexit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmitting with wider audience (akpm & lkml).

Change rivafb_remove to __deviexit to fix MODPOST warnings:

WARNING: drivers/video/riva/rivafb.o - Section mismatch: reference to
.exit.text:rivafb_remove from .data.rel.local after 'rivafb_driver' (at offset 0x28)

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

--- linux-2.6.19.ia64.orig/drivers/video/riva/fbdev.c	2007-02-07 09:56:37.000000000 -0500
+++ linux-2.6.19.ia64/drivers/video/riva/fbdev.c	2007-02-08 11:39:35.000000000 -0500
@@ -2154,7 +2154,7 @@ err_ret:
 	return ret;
 }
 
-static void __exit rivafb_remove(struct pci_dev *pd)
+static void __devexit rivafb_remove(struct pci_dev *pd)
 {
 	struct fb_info *info = pci_get_drvdata(pd);
 	struct riva_par *par = info->par;
@@ -2232,7 +2232,7 @@ static struct pci_driver rivafb_driver =
 	.name		= "rivafb",
 	.id_table	= rivafb_pci_tbl,
 	.probe		= rivafb_probe,
-	.remove		= __exit_p(rivafb_remove),
+	.remove		= __devexit_p(rivafb_remove),
 };
 
 
