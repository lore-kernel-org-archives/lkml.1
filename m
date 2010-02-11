Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab0BKXb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:31:29 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:28117 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab0BKXbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:31:25 -0500
Message-ID: <4B749306.4050509@oracle.com>
Date: Thu, 11 Feb 2010 15:30:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mocean Laboratories <info@mocean-labs.com>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH -mmotm] timberdale: fix mfd build
References: <201002110043.o1B0hKxW008835@imap1.linux-foundation.org>	<4B736ED5.5060205@oracle.com>	<20100211140117.455dbbff.akpm@linux-foundation.org>	<4B74824C.7050700@oracle.com> <20100211143646.f357c9ee.akpm@linux-foundation.org>
In-Reply-To: <20100211143646.f357c9ee.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B749327.0190:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This?

Nope, still has the same error.
Use this one instead.  It builds now.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mfd/timberdale build error -- add depends GPIOLIB.

include/linux/spi/max7301.h:14: error: field 'chip' has incomplete type
build-r7353.out:make[3]: *** [drivers/mfd/timberdale.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2010-0210-1617.orig/drivers/mfd/Kconfig
+++ mmotm-2010-0210-1617/drivers/mfd/Kconfig
@@ -382,7 +382,7 @@ config AB4500_CORE
 config MFD_TIMBERDALE
 	tristate "Support for the Timberdale FPGA"
 	select MFD_CORE
-	depends on PCI
+	depends on PCI && GPIOLIB
 	---help---
 	This is the core driver for the timberdale FPGA. This device is a
 	multifunction device which exposes numerous platform devices.
