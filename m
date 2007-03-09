Return-Path: <linux-kernel-owner+w=401wt.eu-S2993101AbXCIKNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993101AbXCIKNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993102AbXCIKNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:13:01 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:45238 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993101AbXCIKNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:13:00 -0500
X-IronPort-AV: i="4.14,267,1170651600"; 
   d="scan'208"; a="30544491:sNHT21639583"
Subject: [PATCH] i2c-core: i2c bitbang gpio structure
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 09 Mar 2007 18:13:21 +0800
Message-Id: <1173435201.18580.17.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

A new structure is added to i2c-core for GPIO-based I2C interface
adapter. My latest GPIO based I2C adapter driver for Blackfin system
will use this stuff. And also IXP4XX GPIO based I2C driver can also be
moved to this.

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
---
 include/linux/i2c.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: include/linux/i2c.h
===================================================================
--- include/linux/i2c.h	(revision 2813)
+++ include/linux/i2c.h	(working copy)
@@ -201,6 +201,26 @@ struct i2c_algorithm {
 };
 
 /*
+ * Some chips do not have an I2C unit, so GPIO lines are just used to 
+ * Used as platform_data to provide GPIO pin information to this kind GPIO 
+ * based I2C driver.
+ */
+struct i2c_bitbang_gpio {
+	int sda;
+	int scl;
+};
+
+static inline int i2c_bitbang_gpio_sda(struct i2c_bitbang_gpio *gpio)
+{
+	return (gpio->sda);
+}
+
+static inline int i2c_bitbang_gpio_scl(struct i2c_bitbang_gpio *gpio)
+{
+	return (gpio->scl);
+}
+
+/*
  * i2c_adapter is the structure used to identify a physical i2c bus along
  * with the access algorithms necessary to access it.
  */
_

Thanks,
-Bryan Wu



