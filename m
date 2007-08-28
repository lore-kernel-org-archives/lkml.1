Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbXH1RVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbXH1RVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbXH1RVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:21:33 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:19323 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752240AbXH1RVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:21:32 -0400
Date: Tue, 28 Aug 2007 11:21:59 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/2] drivers edac fix e752x correct return code
Message-ID: <46d459b7.LLr0reRcUMUTwFxb%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aristeu Rozanski <aris@ruivo.org>

Patch applied to 2.6.23-rc3

This patch changes the error code when dev0:fun1 was hidden by BIOS to one
more appropriate.

Signed-off-by: Aristeu Rozanski <aris@ruivo.org>
Signed-off-by: Mark Gross <mark.gross@intel.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
cc:   Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 e752x_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc3/drivers/edac/e752x_edac.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/edac/e752x_edac.c	2007-08-12 22:25:24.000000000 -0600
+++ linux-2.6.23-rc3/drivers/edac/e752x_edac.c	2007-08-27 22:19:28.000000000 -0600
@@ -967,7 +967,7 @@
 	if (!force_function_unhide && !(stat8 & (1 << 5))) {
 		printk(KERN_INFO "Contact your BIOS vendor to see if the "
 			"E752x error registers can be safely un-hidden\n");
-		return -ENOMEM;
+		return -ENODEV;
 	}
 	stat8 |= (1 << 5);
 	pci_write_config_byte(pdev, E752X_DEVPRES1, stat8);
