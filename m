Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbYHHUh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbYHHUh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYHHUhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:37:18 -0400
Received: from mx03.syneticon.net ([87.79.32.166]:3376 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbYHHUhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:37:17 -0400
Message-ID: <489CAE72.1030900@wpkg.org>
Date: Fri, 08 Aug 2008 22:37:06 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: nslu2-developers@yahoogroups.com, Rod Whitby <rod@whitby.id.au>,
       linux@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk
Subject: [PATCH] fsg-setup.c should use new style i2c model
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RTC drivers were updated to the new style i2c model.

fsg-setup.c for Freecom FSG-3 was to date not updated to use it.
Because of this, it is not possible to use the RTC.

This tiny patch updates arch/arm/mach-ixp4xx/fsg-setup.c to use the correct device.

It also removes an unused variable which was issuing a compilation warning.


Tested-by: Tomasz Chmielewski <mangoo@wpkg.org>
Signed-off-by: Tomasz Chmielewski <mangoo@wpkg.org>

diff --git a/arch/arm/mach-ixp4xx/fsg-setup.c b/arch/arm/mach-ixp4xx/fsg-setup.c
index 0db3a90..0e0a234 100644
--- a/arch/arm/mach-ixp4xx/fsg-setup.c
+++ b/arch/arm/mach-ixp4xx/fsg-setup.c
@@ -64,7 +64,7 @@ static struct platform_device fsg_i2c_gpio = {
 
 static struct i2c_board_info __initdata fsg_i2c_board_info [] = {
 	{
-		I2C_BOARD_INFO("rtc-isl1208", 0x6f),
+		I2C_BOARD_INFO("isl1208", 0x6f),
 	},
 };
 
@@ -179,7 +179,6 @@ static void __init fsg_init(void)
 {
 	DECLARE_MAC_BUF(mac_buf);
 	uint8_t __iomem *f;
-	int i;
 
 	ixp4xx_sys_init();
 
