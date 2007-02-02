Return-Path: <linux-kernel-owner+w=401wt.eu-S1422724AbXBBKRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422724AbXBBKRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 05:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422735AbXBBKRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 05:17:39 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:60500 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422724AbXBBKRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 05:17:39 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 2 Feb 2007 05:16:05 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Greg KH <greg@kroah.com>,
       linville@tuxdriver.com
Subject: [PATCH] Replace incorrect macro name "WIRELESS_EXT" with
 "CONFIG_WIRELESS_EXT".
Message-ID: <Pine.LNX.4.64.0702020510560.16122@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Rename the (apparently) incorrect macro name WIRELESS_EXT to
CONFIG_WIRELESS_EXT.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  this one i'm not sure about since there really is a WIRELESS_EXT
macro defined in the header file:

  include/linux/wireless.h:#define WIRELESS_EXT 21

but since it exists unconditionally, it wouldn't make much sense to be
testing if it's defined.

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index f47f319..44e69a2 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -329,7 +329,7 @@ static struct attribute_group netstat_group = {
 	.attrs  = netstat_attrs,
 };

-#ifdef WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT
 /* helper function that does all the locking etc for wireless stats */
 static ssize_t wireless_show(struct class_device *cd, char *buf,
 			     ssize_t (*format)(const struct iw_statistics *,
@@ -462,7 +462,7 @@ int netdev_register_sysfs(struct net_device *net)
 	if (net->get_stats)
 		*groups++ = &netstat_group;

-#ifdef WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT
 	if (net->wireless_handlers && net->wireless_handlers->get_wireless_stats)
 		*groups++ = &wireless_group;
 #endif

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
