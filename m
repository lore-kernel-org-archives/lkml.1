Return-Path: <linux-kernel-owner+w=401wt.eu-S965730AbXAYJ1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965730AbXAYJ1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965731AbXAYJ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:27:43 -0500
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:2376 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965730AbXAYJ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:27:42 -0500
Date: Thu, 25 Jan 2007 10:27:41 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: au1xmmc: return errors for unknown response types
Message-ID: <20070125092741.GA8512@roarinelk.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


au1xmmc: return error when encountering unhandled/unknown response type.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>

--- a/drivers/mmc/au1xmmc.c.orig	2007-01-25 09:56:10.851983000 +0100
+++ b/drivers/mmc/au1xmmc.c	2007-01-25 10:13:12.121983000 +0100
@@ -193,6 +194,8 @@ static int au1xmmc_send_command(struct a
 	u32 mmccmd = (cmd->opcode << SD_CMD_CI_SHIFT);
 
 	switch (mmc_resp_type(cmd)) {
+	case MMC_RSP_NONE:
+		break;
 	case MMC_RSP_R1:
 		mmccmd |= SD_CMD_RT_1;
 		break;
@@ -205,6 +208,10 @@ static int au1xmmc_send_command(struct a
 	case MMC_RSP_R3:
 		mmccmd |= SD_CMD_RT_3;
 		break;
+	default:
+		printk(KERN_INFO "au1xmmc: unhandled response type %02x\n",
+			mmc_resp_type(cmd));
+		return MMC_ERR_INVALID;
 	}
 
 	switch(cmd->opcode) {
