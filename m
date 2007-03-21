Return-Path: <linux-kernel-owner+w=401wt.eu-S933876AbXCUWU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876AbXCUWU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXCUWU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:20:58 -0400
Received: from www17.your-server.de ([213.133.104.17]:3576 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933876AbXCUWU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:20:57 -0400
Message-ID: <4601B012.6070802@m3y3r.de>
Date: Wed, 21 Mar 2007 23:22:10 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] Unset msi and msix flags on pci_device_disable
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The commit f5f2b13129a6541debf8851bae843cbbf48298b7 broke suspend/resume
to disk two or more  times in a row. This patches fixes the problem:

This patch should be included in 2.6.21

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d3eab05..d7f8f96 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -886,7 +886,9 @@ pci_disable_device(struct pci_dev *dev)
         pci_write_config_word(dev, PCI_COMMAND, pci_command);
     }
     dev->is_busmaster = 0;
-
+    dev->msi_enabled=0;
+    dev->msix_enabled=0;
+   
     pcibios_disable_device(dev);
 }
 


