Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbYBBAhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbYBBAhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762889AbYBBAg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:36:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:55444 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760870AbYBBAgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:36:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=s3FfhKrF5Byt2TlwWnPpw496LBJPSb5MctqFVpk7g9ElztEUayNBKjn5yE1ig83QkPPbV8UaDtjOFYkGM28i4uFLmR642XaQ6ZL/39VjsfOvYcotL4YQoMAfBATPJ4xRGGLfLc9jBYWnn6UjmB+VaFLd3NVfcdD3UzJI8ZeeKO4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/5] ide: remove redundant BUG_ON() from [atapi_]reset_pollfunc()
Date: Sat, 2 Feb 2008 01:46:30 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802020146.30385.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Same BUG_ON() is present inside ide_set_handler().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -860,7 +860,6 @@ static ide_startstop_t atapi_reset_pollf
 		printk("%s: ATAPI reset complete\n", drive->name);
 	} else {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
-			BUG_ON(HWGROUP(drive)->handler != NULL);
 			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
 			/* continue polling */
 			return ide_started;
@@ -900,7 +899,6 @@ static ide_startstop_t reset_pollfunc (i
 
 	if (!OK_STAT(tmp = hwif->INB(IDE_STATUS_REG), 0, BUSY_STAT)) {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
-			BUG_ON(HWGROUP(drive)->handler != NULL);
 			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
 			/* continue polling */
 			return ide_started;
