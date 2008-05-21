Return-Path: <linux-kernel-owner+w=401wt.eu-S935511AbYEUOhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511AbYEUOhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763529AbYEUOhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:37:02 -0400
Received: from proxy.ovh.net ([213.186.50.98]:45484 "EHLO proxy.ovh.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759770AbYEUOhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:37:01 -0400
X-Greylist: delayed 1819 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 10:37:00 EDT
Message-ID: <48342CDF.1040304@ovh.net>
Date: Wed, 21 May 2008 16:08:31 +0200
From: Emmanuel Colbus <emmanuel.colbus@ovh.net>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH][TRIVIAL] r8169.c : fix misleading comment
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling "PCI base addr 1" something that can actually lie at 
PCI_BASE_ADDR_2 is misleading. Patch follows.

signed-off-by : emmanuel colbus <emmanuel.colbus@ovh.net>
---


diff -Naur drivers/net/r8169.c.old drivers/net/r8169.c
--- drivers/net/r8169.c.old     2008-05-21 15:20:46.000000000 +0200
+++ drivers/net/r8169.c 2008-05-21 15:22:16.000000000 +0200
@@ -1632,7 +1632,8 @@
        if (rc < 0)
                goto err_out_disable_2;
 
-       /* make sure PCI base addr 1 is MMIO */
+       /* make sure PCI base addr 1 (or 2, or whatever the second nonzero
+        * pci base addr is) is MMIO */
        if (!(pci_resource_flags(pdev, region) & IORESOURCE_MEM)) {
                if (netif_msg_probe(tp)) {
                        dev_err(&pdev->dev,


