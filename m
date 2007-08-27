Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbXH0VoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbXH0VoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932880AbXH0Vab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:30:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58895 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932758AbXH0VaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:30:05 -0400
Date: Mon, 27 Aug 2007 23:30:05 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/scsi/imm.c: fix check-after-use
Message-ID: <20070827213005.GM26410@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that we have already oops'ed if "cmd"
was NULL.

Since "cmd" being NULL doesn't seem to be possible at this point this 
patch removes the NULL check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 31 Jul 2007

--- linux-2.6.23-rc1-mm1/drivers/scsi/imm.c.old	2007-07-30 13:58:00.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/scsi/imm.c	2007-07-30 13:58:24.000000000 +0200
@@ -740,10 +740,6 @@ static void imm_interrupt(struct work_st
 	struct Scsi_Host *host = cmd->device->host;
 	unsigned long flags;
 
-	if (!cmd) {
-		printk("IMM: bug in imm_interrupt\n");
-		return;
-	}
 	if (imm_engine(dev, cmd)) {
 		schedule_delayed_work(&dev->imm_tq, 1);
 		return;
