Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYLaG0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYLaG0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 01:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYLaG0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 01:26:32 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:28815 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYLaG0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 01:26:32 -0500
Message-ID: <495B1087.3070205@oracle.com>
Date: Tue, 30 Dec 2008 22:26:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Guennadi Liakhovetski <lg@denx.de>
Subject: [PATCH mmotm] leds-dac124s085: use header files for interfaces
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
In-Reply-To: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.495B108A.0129:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors caused by not using #includes for interfaces that are used:

drivers/leds/leds-dac124s085.c: In function 'dac124s085_probe':
drivers/leds/leds-dac124s085.c:70: error: 'GFP_KERNEL' undeclared (first use in this function)
drivers/leds/leds-dac124s085.c:70: warning: assignment makes pointer from integer without a cast
drivers/leds/leds-dac124s085.c: At top level:
drivers/leds/leds-dac124s085.c:127: error: field name not in record or union initializer
drivers/leds/leds-dac124s085.c:127: error: (near initialization for 'dac124s085_driver.driver')
drivers/leds/leds-dac124s085.c:128: error: field name not in record or union initializer
drivers/leds/leds-dac124s085.c:128: error: (near initialization for 'dac124s085_driver.driver')
drivers/leds/leds-dac124s085.c:128: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/leds/leds-dac124s085.c:145: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-dac124s085.c:145: warning: data definition has no type or storage class
drivers/leds/leds-dac124s085.c:145: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/leds/leds-dac124s085.c:145: warning: function declaration isn't a prototype
drivers/leds/leds-dac124s085.c:146: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-dac124s085.c:146: warning: data definition has no type or storage class
drivers/leds/leds-dac124s085.c:146: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/leds/leds-dac124s085.c:146: warning: function declaration isn't a prototype
drivers/leds/leds-dac124s085.c:147: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-dac124s085.c:147: warning: data definition has no type or storage class
drivers/leds/leds-dac124s085.c:147: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/leds/leds-dac124s085.c:147: warning: function declaration isn't a prototype

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Guennadi Liakhovetski <lg@denx.de>
---
 drivers/leds/leds-dac124s085.c |    3 +++
 1 file changed, 3 insertions(+)

--- mmotm-2008-1230-1605.orig/drivers/leds/leds-dac124s085.c
+++ mmotm-2008-1230-1605/drivers/leds/leds-dac124s085.c
@@ -9,8 +9,11 @@
  * LED driver for the DAC124S085 SPI DAC
  */
 
+#include <linux/gfp.h>
 #include <linux/leds.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/spi/spi.h>
