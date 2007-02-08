Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbXBHPbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbXBHPbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422670AbXBHPbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:31:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXBHPbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:31:01 -0500
Date: Thu, 8 Feb 2007 10:30:54 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, anemo@mba.ocn.ne.jp
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070208153054.17287.14482.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: change __init to __devinit in 2 rtc drivers
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change __init to __devinit in rtc drivers' probe functions.

Resolves MODPOST warnings:

WARNING: drivers/rtc/rtc-ds1553.o - Section mismatch: reference to
.init.text:ds1553_rtc_probe from .data.rel between 'ds1553_rtc_driver' (at
offset 0x0) and 'ds1553_nvram_attr'
WARNING: drivers/rtc/rtc-ds1742.o - Section mismatch: reference to
.init.text:ds1742_rtc_probe from .data.rel between 'ds1742_rtc_driver' (at
offset 0x0) and 'ds1742_nvram_attr'

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

--- linux-2.6.19.ia64.orig/drivers/rtc/rtc-ds1742.c	2007-02-07 09:56:37.000000000 -0500
+++ linux-2.6.19.ia64/drivers/rtc/rtc-ds1742.c	2007-02-08 10:19:47.000000000 -0500
@@ -165,7 +165,7 @@ static struct bin_attribute ds1742_nvram
 	.write = ds1742_nvram_write,
 };
 
-static int __init ds1742_rtc_probe(struct platform_device *pdev)
+static int __devinit ds1742_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 	struct resource *res;
--- linux-2.6.19.ia64.orig/drivers/rtc/rtc-ds1553.c	2007-02-07 09:56:37.000000000 -0500
+++ linux-2.6.19.ia64/drivers/rtc/rtc-ds1553.c	2007-02-08 10:19:12.000000000 -0500
@@ -297,7 +297,7 @@ static struct bin_attribute ds1553_nvram
 	.write = ds1553_nvram_write,
 };
 
-static int __init ds1553_rtc_probe(struct platform_device *pdev)
+static int __devinit ds1553_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 	struct resource *res;
