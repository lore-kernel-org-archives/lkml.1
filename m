Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbZHQUdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbZHQUdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZHQUdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:33:54 -0400
Received: from xenotime.net ([72.52.64.118]:48314 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753865AbZHQUdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:33:53 -0400
Message-ID: <4A89BF12.6020908@xenotime.net>
Date: Mon, 17 Aug 2009 13:35:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>
CC: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] staging/sep: fix build error & warning & kconfig
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sep_driver build when CONFIG_PCI=n:

drivers/staging/sep/sep_driver.c:2548: error: implicit declaration of function 'pci_dev_get'

and printk format warning:

drivers/staging/sep/sep_driver.c:290:
warning: format '%d' expects type 'int', but argument 2 has type 'long unsigned
 int'

Also, the default kconfig value should not be 'y'.

And something should be done about this warning (but I didn't fix it):
drivers/staging/sep/sep_driver.c:1780: warning: 'error' may be used uninitialized in this function

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/sep/Kconfig      |    3 +--
 drivers/staging/sep/sep_driver.c |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- linux-next-20090817.orig/drivers/staging/sep/Kconfig
+++ linux-next-20090817/drivers/staging/sep/Kconfig
@@ -1,8 +1,7 @@
 config DX_SEP
 	tristate "Discretix SEP driver"
 #	depends on MRST
-	depends on RAR_REGISTER
-	default y
+	depends on RAR_REGISTER && PCI
 	help
 	  Discretix SEP driver
 
--- linux-next-20090817.orig/drivers/staging/sep/sep_driver.c
+++ linux-next-20090817/drivers/staging/sep/sep_driver.c
@@ -287,7 +287,7 @@ static int sep_map_and_alloc_shared_area
 	sep->shared_area = sep->shared_addr;
 	/* set the physical address of the shared area */
 	sep->shared_area_bus = sep->shared_bus;
-	edbg("sep: shared_area %d bytes @%p (bus %08llx)\n",
+	edbg("sep: shared_area %lu bytes @%p (bus %08llx)\n",
 		size, sep->shared_addr, (unsigned long long)sep->shared_bus);
 	return 0;
 }



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
