Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbYD3WHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbYD3WHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933090AbYD3WDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:03:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:11309 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbYD3WDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=e40n3t565sEaHII0di4iQwvucr8853x9oM5CfMOSNNdD0tEXEZxu10RtogL8yVuiUW/6tWA1iubWNAMHErCdJiUC8qvnfm321yzNZoaITsxV69FFMIHYp4HozgATv2qqWetVugJk1b4ihusViX4zvvCmKX0UbRzTcoquInWnZ3I=
Subject: [PATCH 10/10] Make one-bit signed bitfields unsigned
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 15:03:45 -0700
Message-Id: <1209593025.24729.120.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise it can only take the values 0/-1 which doesn't seem to
have been intended.

drivers/input/tablet/wacom.h:108:12: error: dubious one-bit signed bitfield
drivers/mmc/host/sdhci.h:190:20: error: dubious one-bit signed bitfield

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/input/tablet/wacom.h |    2 +-
 drivers/mmc/host/sdhci.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
index 706619d..ca62ec6 100644
--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -105,7 +105,7 @@ struct wacom {
 	struct urb *irq;
 	struct wacom_wac * wacom_wac;
 	struct mutex lock;
-	int open:1;
+	unsigned int open:1;
 	char phys[32];
 };
 
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 7fb02e1..299118d 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -187,7 +187,7 @@ struct sdhci_host {
 	struct mmc_request	*mrq;		/* Current request */
 	struct mmc_command	*cmd;		/* Current command */
 	struct mmc_data		*data;		/* Current data request */
-	int			data_early:1;	/* Data finished before cmd */
+	unsigned int		data_early:1;	/* Data finished before cmd */
 
 	struct scatterlist	*cur_sg;	/* We're working on this */
 	int			num_sg;		/* Entries left */
-- 
1.5.5.1.305.g7c84

