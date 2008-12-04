Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbYLDGp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbYLDGp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbYLDGnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:43:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:39460 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbYLDGnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=f13Rd8myRrcciH9OXvbLdwuvE7x2XBye6CmNLjPbRfEPP1YTHepVj5ncCNeVEJYWnl
         4kN90u9m0WCMdZPTwMqR+ut49oGPG2+xTTHP3rZOlNAqThy5OmlQN0W37qDJyToioT0X
         j+FmBPxhikpw3il++8K6KCWJEkJVjPsEtNPiU=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/6] ide-atapi: add a dev_is_idecd-inline
Date: Thu,  4 Dec 2008 07:43:24 +0100
Message-Id: <1228373010-20249-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
References: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 4e58b9e..33a1534 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -14,6 +14,12 @@
 #define debug_log(fmt, args...) do {} while (0)
 #endif
 
+static inline int dev_is_idecd(ide_drive_t *drive)
+{
+	return (drive->media == ide_cdrom || drive->media == ide_optical) &&
+		!(drive->dev_flags & IDE_DFLAG_SCSI);
+}
+
 /*
  * Check whether we can support a device,
  * based on the ATAPI IDENTIFY command results.
@@ -577,7 +583,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 
 	if (scsi)
 		tf_flags = 0;
-	else if (drive->media == ide_cdrom || drive->media == ide_optical)
+	else if (dev_is_idecd(drive))
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
 	else
 		tf_flags = IDE_TFLAG_OUT_DEVICE;
-- 
1.6.0.4

