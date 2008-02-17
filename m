Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYBQTkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYBQTkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYBQTj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:39:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:16615 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYBQTjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:39:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=V00H1ww2M3vluXqHTTHq4GEE0t9nw3GMWLnG/T8ArjKUdmdDB+mt3nid8oxer0e0wzP57p26LIq44KAGbJeel3vbAts48r9S1d3anAS5FOufjz95LvMe1NkFA6nsZK0DfJn036wD+7PCak3HCgFdcZyi3JFTsUSyQ7sHhg9A+7A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/4] ide: fix sparse warning about shadowing 'flags' symbol
Date: Sun, 17 Feb 2008 20:52:10 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802172052.10691.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ide/ide.c:801:18: warning: symbol 'flags' shadows an earlier one
drivers/ide/ide.c:732:16: originally declared here

Also fix some whitespace damage while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -797,10 +797,9 @@ int generic_ide_ioctl(ide_drive_t *drive
 			drive->nice1 = (arg >> IDE_NICE_1) & 1;
 			return 0;
 		case HDIO_DRIVE_RESET:
-		{
-			unsigned long flags;
-			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
-			
+			if (!capable(CAP_SYS_ADMIN))
+				return -EACCES;
+
 			/*
 			 *	Abort the current command on the
 			 *	group if there is one, taking
@@ -819,17 +818,15 @@ int generic_ide_ioctl(ide_drive_t *drive
 			ide_abort(drive, "drive reset");
 
 			BUG_ON(HWGROUP(drive)->handler);
-				
+
 			/* Ensure nothing gets queued after we
 			   drop the lock. Reset will clear the busy */
-		   
+
 			HWGROUP(drive)->busy = 1;
 			spin_unlock_irqrestore(&ide_lock, flags);
 			(void) ide_do_reset(drive);
 
 			return 0;
-		}
-
 		case HDIO_GET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
