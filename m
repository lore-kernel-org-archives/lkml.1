Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYDJUMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYDJUMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758750AbYDJUMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:12:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:16468 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919AbYDJUMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=OSp+wl+H1MHANP6fhZzggm2pp7m6nHh/49lX8kwSc2OYUOuvCx5sNWKVWlMsgrXNTHqtJe13BJQn2eOxOUkFjr8uoVyfii2O+5DHtSjjqY+NkeYeeDVtZVlnH7r/Qjv7lzq5klKnxu1QfydJ7h+UvI/1ZWW5CP6Fl6V3Ho9YdVo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide-{floppy,tape,scsi}: 400ns delay is required after executing the command
Date: Thu, 10 Apr 2008 22:26:48 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804102226.48763.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |    1 +
 drivers/ide/ide-tape.c   |    1 +
 drivers/scsi/ide-scsi.c  |    1 +
 3 files changed, 3 insertions(+)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -698,6 +698,7 @@ static ide_startstop_t idefloppy_issue_p
 		/* Issue the packet command */
 		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
 			       hwif->io_ports.command_addr);
+		ndelay(400);
 		return (*pkt_xfer_routine) (drive);
 	}
 }
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1058,6 +1058,7 @@ static ide_startstop_t idetape_issue_pc(
 	} else {
 		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
 			       hwif->io_ports.command_addr);
+		ndelay(400);
 		return idetape_transfer_pc(drive);
 	}
 }
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -576,6 +576,7 @@ static ide_startstop_t idescsi_issue_pc(
 		/* Issue the packet command */
 		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
 			       hwif->io_ports.command_addr);
+		ndelay(400);
 		return idescsi_transfer_pc(drive);
 	}
 }
