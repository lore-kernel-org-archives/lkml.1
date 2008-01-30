Return-Path: <linux-kernel-owner+w=401wt.eu-S1765063AbYA3UFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765063AbYA3UFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbYA3UBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:01:49 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37558 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875AbYA3UBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:01:39 -0500
Date: Wed, 30 Jan 2008 22:02:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: gregkh@suse.de
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [2.6 patch] pci_alloc_child_bus() mustn't be __devinit
Message-ID: <20080130200214.GN29368@does.not.exist>
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
WARNING: drivers/pci/built-in.o(.text+0xc4c): Section mismatch in reference from the function pci_add_new_bus() to the function .devinit.text:pci_alloc_child_bus()
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
0f6b627d31aca67630305b4f8079a6b627fc4ae3 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5fd5852..0ed050a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -387,8 +387,8 @@ static struct pci_bus * pci_alloc_bus(void)
 	return b;
 }
 
-static struct pci_bus * __devinit
-pci_alloc_child_bus(struct pci_bus *parent, struct pci_dev *bridge, int busnr)
+static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
+					   struct pci_dev *bridge, int busnr)
 {
 	struct pci_bus *child;
 	int i;

