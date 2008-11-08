Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbYKHSct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbYKHSct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 13:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYKHSck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 13:32:40 -0500
Received: from acsinet14.oracle.com ([141.146.126.236]:29202 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYKHSck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 13:32:40 -0500
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Nov 2008 13:32:39 EST
Date: Sat, 8 Nov 2008 10:22:27 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
       Christian Pellegrin <chripell@evolware.org>
Subject: [PATCH -mmotm] max3100: select SERIAL_CORE
Message-Id: <20081108102227.6ffaf2fb.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet11.oracle.com [141.146.126.233]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4915D958.029D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

max3100 driver need to select SERIAL_CORE like most other serial drivers do.

max3100.c:(.text+0x524c5): undefined reference to `uart_write_wakeup'
max3100.c:(.text+0x526eb): undefined reference to `uart_write_wakeup'
max3100.c:(.text+0x529f7): undefined reference to `uart_update_timeout'
max3100.c:(.text+0x52cfa): undefined reference to `uart_resume_port'
max3100.c:(.text+0x52d6a): undefined reference to `uart_suspend_port'
max3100.c:(.devinit.text+0x23e3): undefined reference to `uart_register_driver'
max3100.c:(.devinit.text+0x265a): undefined reference to `uart_add_one_port'
max3100.c:(.devexit.text+0x1aa): undefined reference to `uart_remove_one_port'
max3100.c:(.devexit.text+0x1e5): undefined reference to `uart_unregister_driver'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Christian Pellegrin <chripell@evolware.org>
---
 drivers/serial/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2008-1106-1344.orig/drivers/serial/Kconfig
+++ mmotm-2008-1106-1344/drivers/serial/Kconfig
@@ -511,6 +511,7 @@ config SERIAL_S3C2440
 config SERIAL_MAX3100
         tristate "MAX3100 support"
         depends on SPI
+	select SERIAL_CORE
         help
           MAX3100 chip support
 
