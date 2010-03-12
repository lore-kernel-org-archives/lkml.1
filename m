Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0CLHF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 02:05:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60527 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab0CLHFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 02:05:53 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       "Eric W. Biederman" <ebiederm@xmission.com>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Date: Fri, 12 Mar 2010 08:03:51 +0100
Message-Id: <1268377431-11671-4-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1268377431-11671-1-git-send-email-w.sang@pengutronix.de>
References: <1268377431-11671-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 3/3] drivers/rtc: init dynamic bin_attribute structures
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6992f5334995af474c2b58d010d08bc597f0f2fe introduced this requirement.
Found with coccinelle, but fixed manually. Compile tested on X86 where
possible.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/rtc/rtc-ds1742.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index a127336..cad9ceb 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -184,6 +184,7 @@ static int __devinit ds1742_rtc_probe(struct platform_device *pdev)
 	pdata->size_nvram = pdata->size - RTC_SIZE;
 	pdata->ioaddr_rtc = ioaddr + pdata->size_nvram;
 
+	sysfs_bin_attr_init(&pdata->nvram_attr);
 	pdata->nvram_attr.attr.name = "nvram";
 	pdata->nvram_attr.attr.mode = S_IRUGO | S_IWUSR;
 	pdata->nvram_attr.read = ds1742_nvram_read;
-- 
1.7.0

