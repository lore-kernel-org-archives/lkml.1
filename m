Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbXLTBet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbXLTBet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbXLTBeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11752 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbXLTBeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Pq/aEBHcKkhCuk+/3WfFmhG6cx6WVNUaUNwLrNTSEJaekkissAQDImWIGM4L+GwgBzuUMIT06fobjYtrm94jINdE13vXir0eMjT74Del3R1ORsRGK8ruXtlCOvilHWIcy6RV1clcQLgYWONxss5evu55FV4ypuKZIryFJMPGbg8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 02/63] ide-cd: fix ACER/AOpen 24X CDROM speed reporting on big-endian machines
Date: Thu, 20 Dec 2007 01:51:39 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200151.39973.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fix ACER/AOpen 24X CDROM speed reporting on big-endian machines
  by adding missing le16_to_cpu() calls.

While at it:
* Replace ntohs() by be16_to_cpu().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -2682,14 +2682,14 @@ void ide_cdrom_update_speed (ide_drive_t
 	if (!drive->id->model[0] &&
 	    !strncmp(drive->id->fw_rev, "241N", 4)) {
 		CDROM_STATE_FLAGS(drive)->current_speed  =
-			(((unsigned int)cap->curspeed) + (176/2)) / 176;
+			(le16_to_cpu(cap->curspeed) + (176/2)) / 176;
 		CDROM_CONFIG_FLAGS(drive)->max_speed =
-			(((unsigned int)cap->maxspeed) + (176/2)) / 176;
+			(le16_to_cpu(cap->maxspeed) + (176/2)) / 176;
 	} else {
 		CDROM_STATE_FLAGS(drive)->current_speed  =
-			(ntohs(cap->curspeed) + (176/2)) / 176;
+			(be16_to_cpu(cap->curspeed) + (176/2)) / 176;
 		CDROM_CONFIG_FLAGS(drive)->max_speed =
-			(ntohs(cap->maxspeed) + (176/2)) / 176;
+			(be16_to_cpu(cap->maxspeed) + (176/2)) / 176;
 	}
 }
 
