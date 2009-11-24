Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbZKXKsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbZKXKsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932728AbZKXKsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:48:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39207 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932720AbZKXKsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:48:50 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Force I2C to be built in when building WM831x
Date: Tue, 24 Nov 2009 10:48:56 +0000
Message-Id: <1259059736-23651-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This works around issues with allmodconfig where it won't propagate the
dependency from the WM831x core back to the I2C and MFD cores.  When
doing allmodconfig this causes WM831x to be omitted and ensures that in
normal builds the dependencies get shaken out.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 434bc2f..c33a526 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -183,7 +183,7 @@ config MFD_WM8400
 config MFD_WM831X
 	bool "Support Wolfson Microelectronics WM831x/2x PMICs"
 	select MFD_CORE
-	depends on I2C
+	depends on I2C=y
 	help
 	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs.
 	  This driver provides common support for accessing the device,
-- 
1.6.3.3

