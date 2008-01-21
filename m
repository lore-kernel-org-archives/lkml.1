Return-Path: <linux-kernel-owner+w=401wt.eu-S1761855AbYAUXWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761855AbYAUXWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbYAUXSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:18:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:43432 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760691AbYAUXSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:18:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=UA2YUyS8KYzHWK3P6saZrJ3zLc70PJ0X+ujKdrt1DzYIO6Crwxuv05ClpcRi3Zl876vcxfrZzkB+UtAmh2nop1Ti31fQEeApj3p2guLe71eDf88gGAsaC16SvllKrA6hGMss0x1a4TUgV5AoXko0Y4bKkK+2c4h6EvmBP/7+29I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:31:44 +0100
Message-Id: <20080121233144.30311.5346.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/16] ide: use __ide_set_handler() in ide_execute_command()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Use __ide_set_handler() in ide_execute_command().

While at it:

* Fix whitespace damage in ide_execute_command().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -882,22 +882,17 @@ void ide_execute_command(ide_drive_t *dr
 	unsigned long flags;
 	ide_hwgroup_t *hwgroup = HWGROUP(drive);
 	ide_hwif_t *hwif = HWIF(drive);
-	
+
 	spin_lock_irqsave(&ide_lock, flags);
-	
 	BUG_ON(hwgroup->handler);
-	hwgroup->handler	= handler;
-	hwgroup->expiry		= expiry;
-	hwgroup->timer.expires	= jiffies + timeout;
-	hwgroup->req_gen_timer = hwgroup->req_gen;
-	add_timer(&hwgroup->timer);
+	__ide_set_handler(drive, handler, timeout, expiry);
 	hwif->OUTBSYNC(drive, cmd, IDE_COMMAND_REG);
-	/* Drive takes 400nS to respond, we must avoid the IRQ being
-	   serviced before that. 
-	   
-	   FIXME: we could skip this delay with care on non shared
-	   devices 
-	*/
+	/*
+	 * Drive takes 400nS to respond, we must avoid the IRQ being
+	 * serviced before that.
+	 *
+	 * FIXME: we could skip this delay with care on non shared devices
+	 */
 	ndelay(400);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
