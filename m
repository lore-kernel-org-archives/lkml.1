Return-Path: <linux-kernel-owner+w=401wt.eu-S968986AbXFHLec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968986AbXFHLec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968624AbXFHLeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:34:23 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:60233 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S968434AbXFHLeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:34:21 -0400
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: [PATCH 2/2] rtc-dev: return -ENOTTY in ioctl if irq_set_freq is not implemented by driver
Date: Fri,  8 Jun 2007 13:34:18 +0200
Message-Id: <11813024583427-git-send-email-hcegtvedt@atmel.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11813024582527-git-send-email-hcegtvedt@atmel.com>
References: <11813024582527-git-send-email-hcegtvedt@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
---
 drivers/rtc/rtc-dev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 137330b..7f0e749 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -306,6 +306,8 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 	case RTC_IRQP_READ:
 		if (ops->irq_set_freq)
 			err = put_user(rtc->irq_freq, (unsigned long __user *)uarg);
+		else
+			err = -ENOTTY;
 		break;
 
 	case RTC_IRQP_SET:
-- 
1.4.4.2

