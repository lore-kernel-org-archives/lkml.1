Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbXAWKO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbXAWKO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 05:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932936AbXAWKO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 05:14:58 -0500
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:3293 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934AbXAWKO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 05:14:57 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jan 2007 05:14:57 EST
Date: Tue, 23 Jan 2007 11:08:14 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: drzeus-mmc@drzeus.cx
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MMC: au1xmmc R6 response support
Message-ID: <20070123100814.GA5001@roarinelk.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here's a trivial patch which adds R6 reponse support to the au1xmmc
driver. Fixes SD card detection / operation.

---

Add Response type R6 support to the au1xmmc driver; fixes SD card
detection and operation.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>

--- a/drivers/mmc/au1xmmc.c~	2007-01-23 10:52:33.771983000 +0100
+++ b/drivers/mmc/au1xmmc.c	2007-01-23 10:52:33.771983000 +0100
@@ -205,6 +205,9 @@ static int au1xmmc_send_command(struct a
 	case MMC_RSP_R3:
 		mmccmd |= SD_CMD_RT_3;
 		break;
+	case MMC_RSP_R6:
+		mmccmd |= SD_CMD_RT_6;
+		break;
 	}
 
 	switch(cmd->opcode) {
