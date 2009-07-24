Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbZGXPBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbZGXPBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZGXPBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:01:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:58130 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbZGXPBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:01:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=f+5I1U+iOzbV1lzKe7Ykhk9alU2wxlU+dHPFC9j2cyBFTXwMDOaYMItmB0yDWm1FcN
         798DYWpORiyrufeP2TfrgF00ZGwpCbqOe4NtAXPXLSvJZ61qMqF+fJydZicKjpO9tJJr
         RWcuLtgbW5axhmKduAIGQ62wdLhvSC1i8oUlY=
Message-ID: <4A69CCB3.5050901@gmail.com>
Date: Fri, 24 Jul 2009 23:01:07 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>, Russell King <linux@arm.linux.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: [PATCH] Add watchdog resource support for w90p910
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

This is a watchdog resource define patch, for my w90p910 platform.



Add watchdog resource define for w90p910 wdt driver.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
---
 arch/arm/mach-w90x900/mach-w90p910evb.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-w90x900/mach-w90p910evb.c b/arch/arm/mach-w90x900/mach-w90p910evb.c
index 3e3a267..117578a 100644
--- a/arch/arm/mach-w90x900/mach-w90p910evb.c
+++ b/arch/arm/mach-w90x900/mach-w90p910evb.c
@@ -340,6 +340,28 @@ static struct spi_board_info w90p910_spi_board_info[] __initdata = {
 	},
 };
 
+/* WDT Device */
+
+static struct resource w90p910_wdt_resource[] = {
+	[0] = {
+		.start = W90X900_PA_TIMER,
+		.end   = W90X900_PA_TIMER + W90X900_SZ_TIMER - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_WDT,
+		.end   = IRQ_WDT,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device w90p910_device_wdt = {
+	.name		= "w90p910-wdt",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(w90p910_wdt_resource),
+	.resource	= w90p910_wdt_resource,
+};
+
 static struct map_desc w90p910_iodesc[] __initdata = {
 };
 
@@ -357,6 +379,7 @@ static struct platform_device *w90p910evb_dev[] __initdata = {
 	&w90p910_device_fmi,
 	&w90p910_device_emc,
 	&w90p910_device_spi,
+	&w90p910_device_wdt,
 };
 
 static void __init w90p910evb_map_io(void)
-- 
1.5.6.3
