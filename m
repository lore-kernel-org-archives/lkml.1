Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbZFHU43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbZFHU43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZFHU4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:56:22 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:61511 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776AbZFHU4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:56:21 -0400
X-Trace: 208174068/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.76.204/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.76.204
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0GAPsXLUpPRUzM/2dsb2JhbACBT4xtAcBBhAoF
X-IronPort-AV: E=Sophos;i="4.41,326,1241391600"; 
   d="scan'208";a="208174068"
Date: Mon, 8 Jun 2009 21:45:28 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Joao Ramos <joao.ramos@inov.pt>,
       Sergei Shtylyov <sshtylyov@ru.montavista.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: [PATCH next] ide: fix PowerMac bootup oops
Message-ID: <Pine.LNX.4.64.0906082137120.22183@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PowerMac bootup with CONFIG_IDE=y oopses in ide_pio_cycle_time():
because "ide: try to use PIO Mode 0 during probe if possible" causes
pmac_ide_set_pio_mode() now to be called before drive->id has been set.
It does the right thing if id is not set, so long as we check for that.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 drivers/ide/ide-timings.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnext/drivers/ide/ide-timings.c	2009-04-08 18:25:55.000000000 +0100
+++ linux/drivers/ide/ide-timings.c	2009-06-03 19:45:58.000000000 +0100
@@ -84,7 +84,7 @@ u16 ide_pio_cycle_time(ide_drive_t *driv
 	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 	u16 cycle = 0;
 
-	if (id[ATA_ID_FIELD_VALID] & 2) {
+	if (id && (id[ATA_ID_FIELD_VALID] & 2)) {
 		if (ata_id_has_iordy(drive->id))
 			cycle = id[ATA_ID_EIDE_PIO_IORDY];
 		else
