Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYCKUTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYCKUTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYCKUTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:19:12 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:11680 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbYCKUTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=R496/uOqs2HbegNYD46wd7Z1tjVu0AXB1QlnT0OZ6qut9qmzx8vtuhsvh8pod+zQDP5hWgjnfit/N+x4ofopoSuxl3PokmznxrQ++UMJdvA2Q7GKuc6bHxcL1tFwfxzCUCn9lV72angZeJHxbUElEPQQH+2fzjoDyeVpzYPp0s8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide: mark "hdx=[driver_name]" and "hdx=scsi" kernel parameters as obsoleted
Date: Tue, 11 Mar 2008 21:32:00 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112132.00122.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark "hdx=[driver_name]" and "hdx=scsi" kernel parameters as obsoleted
(nowadays device-driver binding can be changed at runtime through sysfs
 and it can also be dealt with using per device driver parameters).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/ide.txt |    4 ----
 drivers/ide/ide.c         |    4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -219,10 +219,6 @@ Summary of ide driver parameters for ker
 
  "hdx=nodma"		: disallow DMA
 
- "hdx=scsi"		: the return of the ide-scsi flag, this is useful for
- 			  allowing ide-floppy, ide-tape, and ide-cdrom|writers
- 			  to use ide-scsi emulation on a device specific option.
-
  "idebus=xx"		: inform IDE driver of VESA/PCI bus speed in MHz,
 			  where "xx" is between 20 and 66 inclusive,
 			  used when tuning chipset PIO modes.
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -919,7 +919,7 @@ static int __init ide_setup(char *s)
 		drive = &hwif->drives[unit];
 		if (strncmp(s + 4, "ide-", 4) == 0) {
 			strlcpy(drive->driver_req, s + 4, sizeof(drive->driver_req));
-			goto done;
+			goto obsolete_option;
 		}
 		switch (match_parm(&s[3], hd_words, vals, 3)) {
 			case -1: /* "none" */
@@ -952,7 +952,7 @@ static int __init ide_setup(char *s)
 				goto done;
 			case -14: /* "scsi" */
 				drive->scsi = 1;
-				goto done;
+				goto obsolete_option;
 			case 3: /* cyl,head,sect */
 				drive->media	= ide_disk;
 				drive->ready_stat = READY_STAT;
