Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbYL2TEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbYL2TEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 14:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYL2TEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 14:04:05 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:54079 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbYL2TEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 14:04:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=TtBypPglMHZPsz1s6d/gY7M7JTaJCxq9IejXFgNLOYA10FaL6HzlRJd7zci1iPMU7j
         FB9WkH7gXEJ8dAfOpa/D2Mf/cWZv7ceyIMFdB6bcG7lpwfvTTDfC4i41P2ew+2UKCOIl
         nCJQMH4u9tjLpqIyKTaPJjpuXccQ04k7h0P9U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 29 Dec 2008 20:04:22 +0100
Message-Id: <20081229190422.1020.53832.sendpatchset@localhost.localdomain>
In-Reply-To: <20081229190415.1020.43119.sendpatchset@localhost.localdomain>
References: <20081229190415.1020.43119.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/6] ide: use ide_pci_is_in_compatibility_mode() helper in setup-pci.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use ide_pci_is_in_compatibility_mode() helper in setup-pci.c

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/setup-pci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -519,8 +519,7 @@ static int do_ide_setup_pci_device(struc
 	if (ret < 0)
 		goto out;
 
-	/* Is it an "IDE storage" device in non-PCI mode? */
-	if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE && (dev->class & 5) != 5) {
+	if (ide_pci_is_in_compatibility_mode(dev)) {
 		if (noisy)
 			printk(KERN_INFO "%s %s: not 100%% native mode: will "
 				"probe irqs later\n", d->name, pci_name(dev));
