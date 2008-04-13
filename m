Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYDMSSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYDMSSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYDMSQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:16:57 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42221 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbYDMSQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:16:56 -0400
Date: Sun, 13 Apr 2008 21:15:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make mmc_wait_for_app_cmd() static
Message-ID: <20080413181555.GJ2182@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global mmc_wait_for_app_cmd() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/mmc/core/sd_ops.c |    6 ++----
 include/linux/mmc/core.h  |    2 --
 2 files changed, 2 insertions(+), 6 deletions(-)

91b65cb8cda7a2197ebb5c4e4669933a09547057 diff --git a/drivers/mmc/core/sd_ops.c b/drivers/mmc/core/sd_ops.c
index 0d96080..4831a3d 100644
--- a/drivers/mmc/core/sd_ops.c
+++ b/drivers/mmc/core/sd_ops.c
@@ -62,8 +62,8 @@ static int mmc_app_cmd(struct mmc_host *host, struct mmc_card *card)
  *	that occurred while the command was executing.  Do not attempt to
  *	parse the response.
  */
-int mmc_wait_for_app_cmd(struct mmc_host *host, struct mmc_card *card,
-	struct mmc_command *cmd, int retries)
+static int mmc_wait_for_app_cmd(struct mmc_host *host, struct mmc_card *card,
+				struct mmc_command *cmd, int retries)
 {
 	struct mmc_request mrq;
 
@@ -115,8 +115,6 @@ int mmc_wait_for_app_cmd(struct mmc_host *host, struct mmc_card *card,
 	return err;
 }
 
-EXPORT_SYMBOL(mmc_wait_for_app_cmd);
-
 int mmc_app_set_bus_width(struct mmc_card *card, int width)
 {
 	int err;
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index d0c3abe..c8d9a60 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -131,8 +131,6 @@ struct mmc_card;
 
 extern void mmc_wait_for_req(struct mmc_host *, struct mmc_request *);
 extern int mmc_wait_for_cmd(struct mmc_host *, struct mmc_command *, int);
-extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
-	struct mmc_command *, int);
 
 extern void mmc_set_data_timeout(struct mmc_data *, const struct mmc_card *);
 

