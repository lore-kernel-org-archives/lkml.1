Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab0BLRsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:48:06 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:34604 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab0BLRsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=QponKOZ3rWuLDOCZcIOvdy3+jABALxLt6XYdsBu6giV4WKXhrwgPY5P8CRKByoo1Xq
         4nClV+kP2/+lE5mwgmxa1hAcakszJQ7HuGlFPRJig/jdcTYfRt46v5ovUcT9Ddmv7olm
         tKJsLD0vOevVYC/t5QH2Pmv/DBgrZXIyoO39g=
Subject: Subject: [PATCH] w1: mxc_w1: move probe and remove to the dev*
 text area.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 18:47:51 +0100
Message-ID: <1265996871.2484.136.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes the section mismatch warning for mxc_w1_probe()
---
 drivers/w1/masters/mxc_w1.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 65244c0..4926703 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -102,7 +102,7 @@ static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 	return ((__raw_readb(ctrl_addr)) >> 3) & 0x1;
 }
 
-static int __init mxc_w1_probe(struct platform_device *pdev)
+static int __devinit mxc_w1_probe(struct platform_device *pdev)
 {
 	struct mxc_w1_device *mdev;
 	struct resource *res;
@@ -166,7 +166,7 @@ failed_clk:
 /*
  * disassociate the w1 device from the driver
  */
-static int mxc_w1_remove(struct platform_device *pdev)
+static int __devexit mxc_w1_remove(struct platform_device *pdev)
 {
 	struct mxc_w1_device *mdev = platform_get_drvdata(pdev);
 	struct resource *res;
-- 
1.6.3.3


