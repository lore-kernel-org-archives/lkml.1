Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYCOPB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYCOPB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 11:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYCOPBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 11:01:20 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:49138 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbYCOPBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 11:01:19 -0400
Date: Sat, 15 Mar 2008 16:00:38 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
       Roel Kluin <12o3l@tiscali.nl>
Subject: [PATCH] tifm_sd: DATA_CARRY is not boolean in
 tifm_sd_transfer_data()
Message-ID: <20080315160038.2c93c9b5@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <12o3l@tiscali.nl>

DATA_CARRY is not boolean

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
---
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 20d5c7b..1c14a18 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -180,7 +180,7 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
 			host->sg_pos++;
 			if (host->sg_pos == host->sg_len) {
 				if ((r_data->flags & MMC_DATA_WRITE)
-				    && DATA_CARRY)
+				    && (host->cmd_flags & DATA_CARRY))
 					writel(host->bounce_buf_data[0],
 					       host->dev->addr
 					       + SOCK_MMCSD_DATA);


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
