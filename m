Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872Ab0BZBTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 20:19:21 -0500
Received: from smtp-out-185.synserver.de ([212.40.180.185]:1040 "HELO
	smtp-out-185.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934840Ab0BZBTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 20:19:19 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 10864
From: Lars-Peter Clausen <lars@metafoo.de>
To: ben-linux@fluff.org
Cc: akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend] s3cmci: Initialize default platform data no_wprotect and no_detect with 1
Date: Fri, 26 Feb 2010 02:12:07 +0100
Message-Id: <1267146728-8369-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no platform_data was givin to the device it's going to use it's default
platform data struct which has all fields initialized to zero.
As a result the driver is going to try to request gpio0 both as write protect
and card detect pin. Which of course will fail and makes the driver unusable

Previously to the introduction of no_wprotect and no_detect the behavior was
to assume that if no platform data was given there is no write protect or card
detect pin.
This patch restores that behavior.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mmc/host/s3cmci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index d96e1ab..b9c96cc 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1360,6 +1360,8 @@ static struct mmc_host_ops s3cmci_ops = {
 static struct s3c24xx_mci_pdata s3cmci_def_pdata = {
 	/* This is currently here to avoid a number of if (host->pdata)
 	 * checks. Any zero fields to ensure reasonable defaults are picked. */
+	 .no_wprotect = 1,
+	 .no_detect = 1,
 };
 
 #ifdef CONFIG_CPU_FREQ
-- 
1.5.6.5

