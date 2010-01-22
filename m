Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917Ab0AVE6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0AVE6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065Ab0AVE5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:57:55 -0500
Received: from mail.perches.com ([173.55.12.10]:1350 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab0AVEw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:52:58 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 05/24] drivers/block/floppy.c: Remove used once CHECK_READY macro
Date: Thu, 21 Jan 2010 20:52:35 -0800
Message-Id: <e271403c6870043f371d260062c10e9166cfe5d9.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index ac5a4cb..f8c69fa 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -575,7 +575,6 @@ static void floppy_release_irq_and_dma(void);
  * reset doesn't need to be tested before sending commands, because
  * output_byte is automatically disabled when reset is set.
  */
-#define CHECK_RESET { if (FDCS->reset){ reset_fdc(); return; } }
 static void reset_fdc(void);
 
 /*
@@ -1958,7 +1957,10 @@ static int start_motor(void (*function)(void))
 
 static void floppy_ready(void)
 {
-	CHECK_RESET;
+	if (FDCS->reset) {
+		reset_fdc();
+		return;
+	}
 	if (start_motor(floppy_ready))
 		return;
 	if (fdc_dtr())
-- 
1.6.6.rc0.57.gad7a

