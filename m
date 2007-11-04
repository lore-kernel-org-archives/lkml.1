Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXKDEz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXKDEz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 00:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbXKDEzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 00:55:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:13705 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbXKDEzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 00:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VBw3exX7JJv5ZNQGHx6uaBBq/jzKdFCIMQTuo76G3CauaR/aqRLHA/ia98Xt8vErACpwEVbGn2zkN9/w8vP9cxWgCDpqhO7jYVhwDJbHHJMzAyzJ7t+Ury31kAlb05BHNQM7R9yLcPQxoDfgbHtkz5cnEaTP22snFD0odv1DsW4=
Message-ID: <9e4733910711032155j1649a3b8u56a59e754d77f61b@mail.gmail.com>
Date: Sun, 4 Nov 2007 00:55:15 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
Subject: [PATCH] Fix i2c module parameter permissions for read/write
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The permissions of i2c module parameters were set to zero making the
parameters invisible and unsettable from the kernel command line. This
patch changes the permissions to the standard 0644 read/write.

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
---

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 8033e6b..395e430 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -588,7 +588,7 @@ union i2c_smbus_data {
 #define I2C_CLIENT_MODULE_PARM(var,desc) \
   static unsigned short var[I2C_CLIENT_MAX_OPTS] = I2C_CLIENT_DEFAULTS; \
   static unsigned int var##_num; \
-  module_param_array(var, short, &var##_num, 0); \
+  module_param_array(var, short, &var##_num, 0644); \
   MODULE_PARM_DESC(var,desc)

 #define I2C_CLIENT_MODULE_PARM_FORCE(name)                             \


-- 
Jon Smirl
jonsmirl@gmail.com
