Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZCIX10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZCIX10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 19:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZCIX07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 19:26:59 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:64714 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbZCIX06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 19:26:58 -0400
Date: Mon, 9 Mar 2009 16:26:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andres Salomon <dilinger@debian.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mmotm] gpio: fix cs553x printk format
Message-Id: <20090309162620.cab7b3bd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49B5A590.014E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/gpio/cs553x-gpio.c:193: warning: format '%x' expects type 'unsigned int', but argument 5 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/gpio/cs553x-gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2009-0306-1659.orig/drivers/gpio/cs553x-gpio.c
+++ mmotm-2009-0306-1659/drivers/gpio/cs553x-gpio.c
@@ -190,8 +190,8 @@ static int __init cs553x_gpio_probe(stru
 	cs553x_gpio_chip.pdev = pdev;
 	spin_lock_init(&cs553x_gpio_chip.lock);
 
-	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%x\n", GPIO_BAR,
-			cs553x_gpio_chip.base);
+	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%llx\n", GPIO_BAR,
+			(unsigned long long)cs553x_gpio_chip.base);
 
 	/* finally, register with the generic GPIO API */
 	err = gpiochip_add(&cs553x_gpio_chip.chip);
