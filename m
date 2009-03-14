Return-Path: <linux-kernel-owner+w=401wt.eu-S1761013AbZCNCA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013AbZCNCA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbZCNBWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:22:00 -0400
Received: from kroah.org ([198.145.64.141]:35832 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754959AbZCNBV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:47 2009
Message-Id: <20090314011046.947001838@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Russell King <rmk+kernel@arm.linux.org.uk>,
       Jean Delvare <khali@linux-fr.org>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: [patch 105/114] ARM: Add i2c_board_info for RiscPC PCF8583
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=arm-add-i2c_board_info-for-riscpc-pcf8583.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 531660ef5604c75de6fdead9da1304051af17c09 upstream

Add the necessary i2c_board_info structure to fix the lack of PCF8583
RTC on RiscPC.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-rpc/riscpc.c     |    6 ++++++
 drivers/i2c/busses/i2c-acorn.c |    3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-rpc/riscpc.c
+++ b/arch/arm/mach-rpc/riscpc.c
@@ -19,6 +19,7 @@
 #include <linux/serial_8250.h>
 #include <linux/ata_platform.h>
 #include <linux/io.h>
+#include <linux/i2c.h>
 
 #include <asm/elf.h>
 #include <asm/mach-types.h>
@@ -201,8 +202,13 @@ static struct platform_device *devs[] __
 	&pata_device,
 };
 
+static struct i2c_board_info i2c_rtc = {
+	I2C_BOARD_INFO("pcf8583", 0x50)
+};
+
 static int __init rpc_init(void)
 {
+	i2c_register_board_info(0, &i2c_rtc, 1);
 	return platform_add_devices(devs, ARRAY_SIZE(devs));
 }
 
--- a/drivers/i2c/busses/i2c-acorn.c
+++ b/drivers/i2c/busses/i2c-acorn.c
@@ -84,6 +84,7 @@ static struct i2c_algo_bit_data ioc_data
 
 static struct i2c_adapter ioc_ops = {
 	.id			= I2C_HW_B_IOC,
+	.nr			= 0,
 	.algo_data		= &ioc_data,
 };
 
@@ -91,7 +92,7 @@ static int __init i2c_ioc_init(void)
 {
 	force_ones = FORCE_ONES | SCL | SDA;
 
-	return i2c_bit_add_bus(&ioc_ops);
+	return i2c_bit_add_numbered_bus(&ioc_ops);
 }
 
 module_init(i2c_ioc_init);


