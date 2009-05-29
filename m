Return-Path: <linux-kernel-owner+w=401wt.eu-S1762322AbZE2QGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762322AbZE2QGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762571AbZE2QGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:06:23 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:47798 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762327AbZE2QGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:06:22 -0400
Message-ID: <4A20089F.9050409@oracle.com>
Date: Fri, 29 May 2009 09:09:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Eric Piel <eric.piel@tremplin-utc.net>
Subject: [PATCH -mmotm] lis3: uses input polldev functions
References: <200905290052.n4T0q4Eo005253@imap1.linux-foundation.org>
In-Reply-To: <200905290052.n4T0q4Eo005253@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.4A2007F2.0041:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

This driver uses input-polldev (library) functions, so it needs
to select that kconfig symbol so that it builds without errors.

drivers/built-in.o: In function `lis3lv02d_joystick_disable':
(.text+0x19d9d0): undefined reference to `input_unregister_polled_device'
drivers/built-in.o: In function `lis3lv02d_joystick_enable':
(.text+0x19d9fc): undefined reference to `input_allocate_polled_device'
drivers/built-in.o: In function `lis3lv02d_joystick_enable':
(.text+0x19daaf): undefined reference to `input_register_polled_device'
drivers/built-in.o: In function `lis3lv02d_joystick_enable':
(.text+0x19dabf): undefined reference to `input_free_polled_device'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2009-0528-1748.orig/drivers/hwmon/Kconfig
+++ mmotm-2009-0528-1748/drivers/hwmon/Kconfig
@@ -950,6 +950,7 @@ config SENSORS_HDAPS
 config SENSORS_LIS3LV02D
 	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer"
 	depends on ACPI && INPUT
+	select INPUT_POLLDEV
 	select NEW_LEDS
 	select LEDS_CLASS
 	default n


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
