Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbYCKUTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbYCKUTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYCKUTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:19:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:39983 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbYCKUTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:19:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Y5FUpvty6jEw1hHf2ve/6kp9HamDCBTU5NcIv/ywQPVwKzEtiQ2gWv6mWWqHW8hlcGplNFRfoNctlVEWFxFnvIAS4eMPtwpdRY54GYhZ53QvwLDRiVZ0Ta37iZPFvaO1hsNlgcVH9kggd+21LHwQWt6SS1mQlyPvaV2fxVH1n5I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: mark "hdx=remap" and "hdx=remap63" kernel parameters as obsoleted
Date: Tue, 11 Mar 2008 21:32:50 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803112132.50440.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark "hdx=remap" and "hdx=remap63" kernel parameters as obsoleted
(they are layering violation and should be dealt with in the same
 way as done by libata - device-mapper should be used instead).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/ide.txt |    5 -----
 drivers/ide/ide.c         |    4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -203,11 +203,6 @@ Summary of ide driver parameters for ker
 
  "hdx=cyl,head,sect"	: disk drive is present, with specified geometry
 
- "hdx=remap"		: remap access of sector 0 to sector 1 (for EZDrive)
-
- "hdx=remap63"		: remap the drive: add 63 to all sector numbers
-			  (for DM OnTrack)
-
  "idex=noautotune"	: driver will NOT attempt to tune interface speed
 
  "hdx=autotune"		: driver will attempt to tune interface speed
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -946,10 +946,10 @@ static int __init ide_setup(char *s)
 				goto done;
 			case -12: /* "remap" */
 				drive->remap_0_to_1 = 1;
-				goto done;
+				goto obsolete_option;
 			case -13: /* "remap63" */
 				drive->sect0 = 63;
-				goto done;
+				goto obsolete_option;
 			case -14: /* "scsi" */
 				drive->scsi = 1;
 				goto obsolete_option;
