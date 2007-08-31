Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbXHaP6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbXHaP6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbXHaP6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:58:39 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:32908 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708AbXHaP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:58:38 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 31 Aug 2007 11:47:14 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFC] Starting point for deprecating "ether=" boot time
 option.
Message-ID: <Pine.LNX.4.64.0708311145150.13259@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  i just need a tentative removal date and i can add the appropriate
entry to the feature removal file.  and i can update some of the
appropriate source elsewhere in the tree as well.

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 12c7657..e4c3b26 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -31,6 +31,8 @@
  *				  older network drivers and IFF_ALLMULTI.
  *	Christer Weinigel	: Better rebuild header message.
  *             Andrew Morton    : 26Feb01: kill ether_setup() - use netdev_boot_setup().
+ *             Robert P. J. Day : Add ether_boot_setup() to allow deprecation warning
+				  for "ether=" boot-time option.
  *
  *		This program is free software; you can redistribute it and/or
  *		modify it under the terms of the GNU General Public License
@@ -60,7 +62,17 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>

-__setup("ether=", netdev_boot_setup);
+static int __init
+ether_boot_setup(char *str)
+{
+	printk(KERN_NOTICE "The 'ether' option is deprecated and "
+		"is scheduled for removal shortly after "
+		"Satan begins ice skating to work\n");
+	printk(KERN_NOTICE "Use 'netdev=<value>' instead\n");
+	return netdev_boot_setup(str);
+}
+
+__setup("ether=", ether_boot_setup);

 /**
  * eth_header - create the Ethernet header

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
