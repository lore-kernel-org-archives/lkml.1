Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbYG0Giz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbYG0Giz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758646AbYG0Gim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:38:42 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:29943 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621AbYG0Gil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:38:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=MYKdgfFdE4MdjGluXlHIh4yzgywaWUUnoGHK/UFf003PevCNDLqTh8DbOlIZ0T8I4B
         DAOVOx93+1L4x9ETYIQf88u/fyx2oarjsgScnJAb6VzlDuklU6GaHHOg79g2ThyQylFu
         8b1ss+ajRl5/JIdU+FVu+Xu5KTW4PuM16ZmXc=
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/8] [Blackfin] RTC driver: if we dont define irq_set_freq, the common rtc-dev layer will give us the same behavior of returning ENOTTY
Date: Sun, 27 Jul 2008 14:38:20 +0800
Message-Id: <1217140707-21263-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217140707-21263-1-git-send-email-cooloney@kernel.org>
References: <1217140707-21263-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/rtc/rtc-bfin.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 8624f55..48ada59 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -381,20 +381,6 @@ static int bfin_rtc_proc(struct device *dev, struct seq_file *seq)
 #undef yesno
 }
 
-/**
- *	bfin_irq_set_freq - make sure hardware supports requested freq
- *	@dev: pointer to RTC device structure
- *	@freq: requested frequency rate
- *
- *	The Blackfin RTC can only generate periodic events at 1 per
- *	second (1 Hz), so reject any attempt at changing it.
- */
-static int bfin_irq_set_freq(struct device *dev, int freq)
-{
-	dev_dbg_stamp(dev);
-	return -ENOTTY;
-}
-
 static struct rtc_class_ops bfin_rtc_ops = {
 	.open          = bfin_rtc_open,
 	.release       = bfin_rtc_release,
@@ -404,7 +390,6 @@ static struct rtc_class_ops bfin_rtc_ops = {
 	.read_alarm    = bfin_rtc_read_alarm,
 	.set_alarm     = bfin_rtc_set_alarm,
 	.proc          = bfin_rtc_proc,
-	.irq_set_freq  = bfin_irq_set_freq,
 };
 
 static int __devinit bfin_rtc_probe(struct platform_device *pdev)
-- 
1.5.6

