Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZFEQF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZFEQF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZFEQFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:05:20 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:37433 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZFEQFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:05:19 -0400
Message-ID: <4A2942E6.7050107@oracle.com>
Date: Fri, 05 Jun 2009 09:08:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Eric Piel <eric.piel@tremplin-utc.net>
Subject: [PATCH -mmotm] lis3: fix polldev build error
References: <200906050105.n5515BhY028645@imap1.linux-foundation.org>
In-Reply-To: <200906050105.n5515BhY028645@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A294223.0139:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix lis3 (spi version) Kconfig to prevent build error:

(.text+0x874fb): undefined reference to `input_unregister_polled_device'
(.text+0x87896): undefined reference to `input_allocate_polled_device'
(.text+0x879d3): undefined reference to `input_register_polled_device'
(.text+0x879e9): undefined reference to `input_free_polled_device'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2009-0604-1745.orig/drivers/hwmon/Kconfig
+++ mmotm-2009-0604-1745/drivers/hwmon/Kconfig
@@ -978,6 +978,7 @@ config SENSORS_LIS3LV02D
 config SENSORS_LIS3_SPI
 	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer (SPI)"
 	depends on !ACPI && SPI_MASTER && INPUT
+	select INPUT_POLLDEV
 	default n
 	help
 	  This driver provides support for the LIS3LV02Dx accelerometer connected


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
