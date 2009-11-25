Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbZKYRIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbZKYRIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932528AbZKYRIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:08:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:24999 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbZKYRIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:08:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=TRPOcQkEqeM828sLPjFT5jnzmPO/cEHQJ4yln/bYQfgI8AnLg6nNE5nRXormO++4l/
         j7bhtC7eCgCzyZja+BomnLitQb6NCnh/+5mQ4ZbQ9x3aF8irq6hDRSUv602VlKRkf+3Y
         PHjPH2Ite1OeGFmWe4BD/gsaY6+EVXivQA/wU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:07:40 +0100
Message-Id: <20091125170740.5446.67217.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 45/86] pata_legacy: do not probe extra ports automatically if PCI is not present
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_legacy: do not probe extra ports automatically if PCI is not present

It can be problematic if there are other ISA/VLB devices using
those ports.

This is a forward port of bugfix from IDE ide-generic host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_legacy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_legacy.c
===================================================================
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -1241,7 +1241,7 @@ static __init int legacy_init(void)
 	if (secondary == 0 || all)
 		legacy_probe_add(0x170, 15, UNKNOWN, 0);
 
-	if (probe_all || !pci_present) {
+	if (probe_all) {
 		/* ISA/VLB extra ports */
 		legacy_probe_add(0x1E8, 11, UNKNOWN, 0);
 		legacy_probe_add(0x168, 10, UNKNOWN, 0);
