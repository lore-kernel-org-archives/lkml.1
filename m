Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbXGOUh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbXGOUh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXGOUhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:37:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55020 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbXGOUhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:37:17 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] make i2c-acorn tristate
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Message-Id: <E1IAAqC-0005Zz-Kd@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 21:37:16 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It depends on tristate I2C and it's trivial to make modular.  The
current Kconfig allows I2C=m, I2C_ACORN=y, which doesn't work at
all; alternatives are dependency on I2C=y and making I2C_ACORN
itself a tristate.  The latter is the right thing to do...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/i2c/busses/Kconfig     |    2 +-
 drivers/i2c/busses/i2c-acorn.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index fcde9ba..1c77e14 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -560,7 +560,7 @@ config I2C_VERSATILE
 	  will be called i2c-versatile.
 
 config I2C_ACORN
-	bool "Acorn IOC/IOMD I2C bus support"
+	tristate "Acorn IOC/IOMD I2C bus support"
 	depends on ARCH_ACORN
 	default y
 	select I2C_ALGOBIT
diff --git a/drivers/i2c/busses/i2c-acorn.c b/drivers/i2c/busses/i2c-acorn.c
index 09bd7f4..7c2be35 100644
--- a/drivers/i2c/busses/i2c-acorn.c
+++ b/drivers/i2c/busses/i2c-acorn.c
@@ -94,4 +94,4 @@ static int __init i2c_ioc_init(void)
 	return i2c_bit_add_bus(&ioc_ops);
 }
 
-__initcall(i2c_ioc_init);
+module_init(i2c_ioc_init);
-- 
1.5.3.GIT

