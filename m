Return-Path: <linux-kernel-owner+w=401wt.eu-S1764951AbYA3UFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764951AbYA3UFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757413AbYA3UBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:01:48 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51721 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999AbYA3UBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:01:41 -0500
Date: Wed, 30 Jan 2008 22:02:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: gregkh@suse.de
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [2.6 patch] pci_scan_device() mustn't be __devinit
Message-ID: <20080130200216.GO29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
WARNING: drivers/pci/built-in.o(.text+0x150f): Section mismatch in reference from the function pci_scan_single_device() to the function .devinit.text:pci_scan_device()
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d5abdec38c49b44c9ba37c97f2f31f2c2fd19037 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 0ed050a..2533b69 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -873,8 +873,7 @@ EXPORT_SYMBOL(alloc_pci_dev);
  * Read the config data for a PCI device, sanity-check it
  * and fill in the dev structure...
  */
-static struct pci_dev * __devinit
-pci_scan_device(struct pci_bus *bus, int devfn)
+static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_dev *dev;
 	u32 l;

