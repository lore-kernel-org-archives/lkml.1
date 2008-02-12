Return-Path: <linux-kernel-owner+w=401wt.eu-S1762690AbYBLOap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690AbYBLOap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761402AbYBLOaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:30:35 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:31476 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761272AbYBLOae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:30:34 -0500
Message-ID: <47B1ADCE.40202@larces.uece.br>
Date: Tue, 12 Feb 2008 11:31:42 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Achim Leubner" <achim_leubner@adaptec.com>
CC: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] 2.6.25-rc1-git2: GDT SCSI: change drivers/scsi/gdth.c into
 using pci_get device
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compilation warning in drivers/scsi/gdth.c, using deprecated pci_find_device. 
Change it into using pci_get_device instead:
drivers/scsi/gdth.c:645: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:495)

Signed-off-by: Sergio Luis <sergio@larces.uece.br>

gdth.c |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)


diff -urN linux-2.6.25-rc1-git2.orig/drivers/scsi/gdth.c linux-2.6.25-rc1-git2/drivers/scsi/gdth.c
--- linux-2.6.25-rc1-git2.orig/drivers/scsi/gdth.c	2008-02-12 09:26:14.000000000 -0300
+++ linux-2.6.25-rc1-git2/drivers/scsi/gdth.c	2008-02-12 10:33:08.000000000 -0300
@@ -642,7 +642,7 @@
           *cnt, vendor, device));
 
     pdev = NULL;
-    while ((pdev = pci_find_device(vendor, device, pdev)) 
+    while ((pdev = pci_get_device(vendor, device, pdev)) 
            != NULL) {
         if (pci_enable_device(pdev))
             continue;

