Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbXLTBwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbXLTBwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758656AbXLTBg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:36:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:12465 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903AbXLTBeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=pWtZOZQfvmdgZ+WYmXnhSGtwB6M4k2LWWGyNJCEOSyIFYJpWmjPBD3sLG6CWnMqYVnPaQGh6LqLueWHmKMeI6QfLzWVF5UKRgxuqjQR2hs73NGKjGIDguewR6mn8T8du2FBdXvRaSCZESJYRVMObtKqVAtsXMAgKh0dtND9/Xiw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 45/63] ide-cd: remove BUG_ON() from cdrom_newpc_intr()
Date: Thu, 20 Dec 2007 02:27:07 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200227.07552.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is no need for it anylonger and ide_set_handler() complains
if ->handler is not NULL anyway.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1368,8 +1368,6 @@ static ide_startstop_t cdrom_newpc_intr(
 	if (len > 0)
 		ide_cd_pad_transfer(drive, xferfunc, len);
 
-	BUG_ON(HWGROUP(drive)->handler != NULL);
-
 	ide_set_handler(drive, cdrom_newpc_intr, rq->timeout, NULL);
 	return ide_started;
 
