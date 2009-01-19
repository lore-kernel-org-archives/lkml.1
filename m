Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZASOQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZASOQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZASOOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:14:11 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:39237 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbZASOOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:14:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dT8ix/RdbD1tdfsOmTuJPr+GtgVBzCB/03IAjKSsce++xspBCNtnjztPBzMI89zmc8
         RQfvEOUAdGLNg6zvkaWfDASO4OVvVHqsMi2XCls7MOMIi3Bzc7duACCbbdKenLemMPMP
         bri57UAUhF8Wf9ZSghWInbC+8IFZ3gSgp4Ez8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 15:14:10 +0100
Message-Id: <20090119141410.27613.54355.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
References: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/12] ide: use pci_get_legacy_ide_irq() in ide_pci_init_{one,two}()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use pci_get_legacy_ide_irq() in ide_pci_init_{one,two}()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/setup-pci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -572,8 +572,8 @@ int ide_pci_init_one(struct pci_dev *dev
 
 	if ((ret == 0 && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
 	    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS)) {
-		hw[0].irq = 14;
-		hw[1].irq = 15;
+		hw[0].irq = pci_get_legacy_ide_irq(dev, 0);
+		hw[1].irq = pci_get_legacy_ide_irq(dev, 1);
 	}
 
 	ret = ide_host_register(host, d, hws);
@@ -629,8 +629,8 @@ int ide_pci_init_two(struct pci_dev *dev
 
 		if ((ret == 0 && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
 		    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS)) {
-			hw[i*2].irq = 14;
-			hw[i*2 + 1].irq = 15;
+			hw[i*2].irq = pci_get_legacy_ide_irq(pdev[i], 0);
+			hw[i*2 + 1].irq = pci_get_legacy_ide_irq(pdev[i], 1);
 		}
 	}
 
