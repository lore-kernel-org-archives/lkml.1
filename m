Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab0CERpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:45:10 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:50493 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0CERpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:45:06 -0500
Message-ID: <4B9142AA.9040801@oracle.com>
Date: Fri, 05 Mar 2010 09:43:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Denis Turischev <denis@compulab.co.il>
Subject: [PATCH -next] mfd/lpc_sch: fix related depends/selects, fix build
 error
References: <20100305181358.9adfe089.sfr@canb.auug.org.au>
In-Reply-To: <20100305181358.9adfe089.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B914318.012C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

LPC_SCH is selected by GPI_SCH and I2C_ISCH, even when PCI is not
enabled, but LPC_SCH depends on PCI, so make GPI_SCH and I2C_ISCH
also depend on PCI.

Those 2 selects also need to select what LPC_SCH selects,
since kconfig does not follow selects.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Denis Turischev <denis@compulab.co.il>
---
 drivers/gpio/Kconfig       |    3 ++-
 drivers/i2c/busses/Kconfig |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- linux-next-20100305.orig/drivers/gpio/Kconfig
+++ linux-next-20100305/drivers/gpio/Kconfig
@@ -87,7 +87,8 @@ config GPIO_VR41XX
 
 config GPIO_SCH
 	tristate "Intel SCH GPIO"
-	depends on GPIOLIB
+	depends on GPIOLIB && PCI
+	select MFD_CORE
 	select LPC_SCH
 	help
 	  Say yes here to support GPIO interface on Intel Poulsbo SCH.
--- linux-next-20100305.orig/drivers/i2c/busses/Kconfig
+++ linux-next-20100305/drivers/i2c/busses/Kconfig
@@ -105,6 +105,8 @@ config I2C_I801
 
 config I2C_ISCH
 	tristate "Intel SCH SMBus 1.0"
+	depends on PCI
+	select MFD_CORE
 	select LPC_SCH
 	help
 	  Say Y here if you want to use SMBus controller on the Intel SCH

-- 
~Randy
