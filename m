Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYJ1TWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYJ1TWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYJ1TWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:22:12 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:35558 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201AbYJ1TWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:22:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8EADkDB0lR9R1W/2dsb2JhbACBdslqg1A
Date: Tue, 28 Oct 2008 20:22:03 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [WATCHDOG] v2.6.28-rc3 patches
Message-ID: <20081028192203.GA2690@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/acquirewdt.c     |    6 +++---
 drivers/watchdog/advantechwdt.c   |    6 +++---
 drivers/watchdog/bfin_wdt.c       |    2 +-
 drivers/watchdog/eurotechwdt.c    |    4 ++--
 drivers/watchdog/i6300esb.c       |    3 +--
 drivers/watchdog/ib700wdt.c       |    6 +++---
 drivers/watchdog/indydog.c        |    2 +-
 drivers/watchdog/mpcore_wdt.c     |    4 ++--
 drivers/watchdog/omap_wdt.c       |    2 +-
 drivers/watchdog/pcwd_pci.c       |    2 +-
 drivers/watchdog/pcwd_usb.c       |    2 +-
 drivers/watchdog/rc32434_wdt.c    |    3 ++-
 drivers/watchdog/s3c2410_wdt.c    |    2 +-
 drivers/watchdog/sa1100_wdt.c     |    2 +-
 drivers/watchdog/sb_wdog.c        |    4 ++--
 drivers/watchdog/sbc8360.c        |    6 +++---
 drivers/watchdog/sbc_epx_c3.c     |    2 +-
 drivers/watchdog/smsc37b787_wdt.c |    2 +-
 drivers/watchdog/softdog.c        |    3 +--
 drivers/watchdog/w83627hf_wdt.c   |    6 +++---
 drivers/watchdog/w83697hf_wdt.c   |    4 ++--
 drivers/watchdog/wafer5823wdt.c   |    4 ++--
 drivers/watchdog/wdt.c            |    4 ++--
 drivers/watchdog/wdt285.c         |    3 ++-
 drivers/watchdog/wdt_pci.c        |    4 ++--
 25 files changed, 44 insertions(+), 44 deletions(-)

with these Changes:

Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Mon Oct 27 15:17:56 2008 +0000

    [PATCH] Switch all my contributions stuff to a single common address
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Sun Sep 28 16:21:43 2008 -0700

    [WATCHDOG] pci: use pci_ioremap_bar() in drivers/watchdog
    
    Use the newly introduced pci_ioremap_bar() function in drivers/watchdog.
    pci_ioremap_bar() just takes a pci device and a bar number, with the goal
    of making it really hard to get wrong, while also having a central place
    to stick sanity checks.
    
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 6e46a55..3e57aa4 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -3,8 +3,8 @@
  *
  *      Based on wdt.c. Original copyright messages:
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -15,7 +15,7 @@
  *	warranty for any of this software. This material is provided
  *	"AS-IS" and at no charge.
  *
- *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
+ *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *      14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
  *          Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index a5110f9..a1d7856 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -6,8 +6,8 @@
  *	Based on acquirewdt.c which is based on wdt.c.
  *	Original copyright messages:
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -18,7 +18,7 @@
  *	warranty for any of this software. This material is provided
  *	"AS-IS" and at no charge.
  *
- *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
+ *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
  *	    Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 31b4225..067a57c 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -5,7 +5,7 @@
  * Originally based on softdog.c
  * Copyright 2006-2007 Analog Devices Inc.
  * Copyright 2006-2007 Michele d'Amico
- * Copyright 1996 Alan Cox <alan@redhat.com>
+ * Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Enter bugs at http://blackfin.uclinux.org/
  *
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index bbd14e3..a171fc6 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -8,8 +8,8 @@
  *	Based on wdt.c.
  *	Original copyright messages:
  *
- *      (c) Copyright 1996-1997 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *                              http://www.redhat.com
+ *      (c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *      This program is free software; you can redistribute it and/or
  *      modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index c13383f..74f951c 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -394,8 +394,7 @@ static unsigned char __init esb_getdevice(void)
 			goto err_disable;
 		}
 
-		BASEADDR = ioremap(pci_resource_start(esb_pci, 0),
-				   pci_resource_len(esb_pci, 0));
+		BASEADDR = pci_ioremap_bar(esb_pci, 0);
 		if (BASEADDR == NULL) {
 			/* Something's wrong here, BASEADDR has to be set */
 			printk(KERN_ERR PFX "failed to get BASEADDR\n");
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 8782ec1..317ef2b 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -11,8 +11,8 @@
  *	Based on acquirewdt.c which is based on wdt.c.
  *	Original copyright messages:
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -23,7 +23,7 @@
  *	warranty for any of this software. This material is provided
  *	"AS-IS" and at no charge.
  *
- *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
+ *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
  *	     Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index 73c9e79..0f761db 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -9,7 +9,7 @@
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
  *
- *	based on softdog.c by Alan Cox <alan@redhat.com>
+ *	based on softdog.c by Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/module.h>
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 2a9bfa8..1130ad6 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -4,8 +4,8 @@
  *	(c) Copyright 2004 ARM Limited
  *
  *	Based on the SoftDog driver:
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ * 						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 7bcbb7f..2f2ce74 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -16,7 +16,7 @@
  * 20030527: George G. Davis <gdavis@mvista.com>
  *	Initially based on linux-2.4.19-rmk7-pxa1/drivers/char/sa1100_wdt.c
  *	(c) Copyright 2000 Oleg Drokin <green@crimea.edu>
- *	Based on SoftDog driver by Alan Cox <alan@redhat.com>
+ *	Based on SoftDog driver by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Copyright (c) 2004 Texas Instruments.
  *	1. Modified to support OMAP1610 32-KHz watchdog timer
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index 90eb1d4..5d76422 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -6,7 +6,7 @@
  *	Based on source code of the following authors:
  *	  Ken Hollis <kenji@bitgate.com>,
  *	  Lindsay Harris <lindsay@bluegum.com>,
- *	  Alan Cox <alan@redhat.com>,
+ *	  Alan Cox <alan@lxorguk.ukuu.org.uk>,
  *	  Matt Domsch <Matt_Domsch@dell.com>,
  *	  Rob Radez <rob@osinvestor.com>
  *
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index c1685c9..afb0896 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -5,7 +5,7 @@
  *
  *	Based on source code of the following authors:
  *	  Ken Hollis <kenji@bitgate.com>,
- *	  Alan Cox <alan@redhat.com>,
+ *	  Alan Cox <alan@lxorguk.ukuu.org.uk>,
  *	  Matt Domsch <Matt_Domsch@dell.com>,
  *	  Rob Radez <rob@osinvestor.com>,
  *	  Greg Kroah-Hartman <greg@kroah.com>
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index c9c73b6..57027f4 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -7,7 +7,8 @@
  *  based on
  *  SoftDog 0.05:	A Software Watchdog Device
  *
- *  (c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
+ *  (c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *					All Rights Reserved.
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 86d4280..f7f6ce8 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -6,7 +6,7 @@
  * S3C2410 Watchdog Timer Support
  *
  * Based on, softdog.c by Alan Cox,
- *     (c) Copyright 1996 Alan Cox <alan@redhat.com>
+ *     (c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index 31a4843..ed01e4c 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -2,7 +2,7 @@
  *	Watchdog driver for the SA11x0/PXA2xx
  *
  *      (c) Copyright 2000 Oleg Drokin <green@crimea.edu>
- *          Based on SoftDog driver by Alan Cox <alan@redhat.com>
+ *          Based on SoftDog driver by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index 27e526a..38f5831 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -35,8 +35,8 @@
  * Based on various other watchdog drivers, which are probably all
  * loosely based on something Alan Cox wrote years ago.
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index fd83dd0..ae74f6b 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -16,8 +16,8 @@
  *	Based on acquirewdt.c which is based on wdt.c.
  *	Original copyright messages:
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -28,7 +28,7 @@
  *	warranty for any of this software. This material is provided
  *	"AS-IS" and at no charge.
  *
- *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
+ *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *      14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
  *           Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index e5e470c..06553de 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -10,7 +10,7 @@
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
  *
- *	based on softdog.c by Alan Cox <alan@redhat.com>
+ *	based on softdog.c by Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/module.h>
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 988ff1d..2e56cad 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -1,7 +1,7 @@
 /*
  *	SMsC 37B787 Watchdog Timer driver for Linux 2.6.x.x
  *
- *      Based on acquirewdt.c by Alan Cox <alan@redhat.com>
+ *	Based on acquirewdt.c by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *       and some other existing drivers
  *
  *	This program is free software; you can redistribute it and/or
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index c650464..7204f96 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -1,8 +1,7 @@
 /*
  *	SoftDog	0.07:	A Software Watchdog Device
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>, All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 69396ad..916890a 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -11,8 +11,8 @@
  *
  *	(c) Copyright 2000-2001 Marek Michalkiewicz <marekm@linux.org.pl>
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -23,7 +23,7 @@
  *	warranty for any of this software. This material is provided
  *	"AS-IS" and at no charge.
  *
- *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
+ *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/module.h>
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index 445d30a..3c7aa41 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -12,8 +12,8 @@
  *
  *	(c) Copyright 2000-2001 Marek Michalkiewicz <marekm@linux.org.pl>
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
index 68377ae..42e940c 100644
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -10,8 +10,8 @@
  *	Based on advantechwdt.c which is based on wdt.c.
  *	Original copyright messages:
  *
- *	(c) Copyright 1996-1997 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index deeebb2..eddb918 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -1,8 +1,8 @@
 /*
  *	Industrial Computer Source WDT500/501 driver
  *
- *	(c) Copyright 1996-1997 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index 191ea63..f551356 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -6,7 +6,8 @@
  *
  *	SoftDog	0.05:	A Software Watchdog Device
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index ed02bdb..c45839a 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -1,8 +1,8 @@
 /*
  *	Industrial Computer Source PCI-WDT500/501 driver
  *
- *	(c) Copyright 1996-1997 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						 All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
