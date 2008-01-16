Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYAPXNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYAPXNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYAPXN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:13:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:10937 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYAPXNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=aNx9VQoaTz8Q8bxaMMbOsuc7OF7ZUWpsNejanPk9xF+5PwnRueHY9CxffsBTXMAvjB8Qneifa7sHqVrkfN10o2bJEm4Ud53IbsTo7tOyEE5oeFFYVa05w5+uDUK7iF7Tre3nKijO/K+u0ReDF5WsR7+y/yO9xmfjX6140WIq09E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:26:03 +0100
Message-Id: <20080116232603.9166.96455.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/22] ide: remove redundant hwif->present check from ide_register_hw()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We check earlier for hwif->present and call ide_unregister() if necessary
(after ide_unregister() hwif->present will be always cleared).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -720,8 +720,6 @@ found:
 		ide_init_port_data(hwif, index);
 		init_hwif_default(hwif, index);
 	}
-	if (hwif->present)
-		return -1;
 
 	ide_init_port_hw(hwif, hw);
 	hwif->quirkproc = quirkproc;
