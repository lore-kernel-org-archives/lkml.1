Return-Path: <linux-kernel-owner+w=401wt.eu-S932533AbYBHAbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbYBHAbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762446AbYBHAap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:30:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:3979 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbYBHAaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:30:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=q1qBsToZ/tkdavcHaFCNJ3YzeGr4dFq3jR9Oay5wOpu6h/QFhw8tSFzQx0N4LcmtKaFLzJTXc3aBwRDoSBsF/sgb/TUKYUqvlNVAAHeC9CYj4UYHZLLcgrqrMPG+pntwosv/mEIneMiAKh6ObdpraBsQRpe3AklA2xl9gEzKwd4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:44:27 +0100
Message-Id: <20080208004427.17746.14159.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/18] ide-generic: set hwif->chipset
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This hwif->chipset fixup is already present in ide_device_add_all()
but for warm-plug support we also need to reserve not currently present
interfaces.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-generic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -23,7 +23,9 @@ static int __init ide_generic_init(void)
 	for (i = 0; i < MAX_HWIFS; i++) {
 		ide_hwif_t *hwif = &ide_hwifs[i];
 
-		if (hwif->io_ports[IDE_DATA_OFFSET] && !hwif->present)
+		if (hwif->io_ports[IDE_DATA_OFFSET] &&
+		    (hwif->chipset == ide_unknown ||
+		     hwif->chipset == ide_forced))
 			idx[i] = i;
 		else
 			idx[i] = 0xff;
