Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYAUXSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYAUXSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYAUXRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:17:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:43625 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbYAUXRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:17:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mwbBadn0Oh8BhvTFtRN7djP2Zu+vMdZaqfjaRdzAmnMVrzp4Hmdf22XNKd4Jshf2Kld+ycNSBXepJZ0SDSjwvI9JZyaUZ1KD9He9l6mLWVv+92V7QwgPrgn6Q5oIEx2q3QSKcCpFt9dbSWqNAWTWJIu0J8RcT3K5zy+uFQf1VI4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:30:43 +0100
Message-Id: <20080121233043.30311.75376.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/16] ide-tape: use ide_execute_command()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2181,8 +2181,8 @@ static ide_startstop_t idetape_issue_pac
 	if (dma_ok)			/* Will begin DMA later */
 		set_bit(PC_DMA_IN_PROGRESS, &pc->flags);
 	if (test_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags)) {
-		ide_set_handler(drive, &idetape_transfer_pc, IDETAPE_WAIT_CMD, NULL);
-		hwif->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
+		ide_execute_command(drive, WIN_PACKETCMD, &idetape_transfer_pc,
+				    IDETAPE_WAIT_CMD, NULL);
 		return ide_started;
 	} else {
 		hwif->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
