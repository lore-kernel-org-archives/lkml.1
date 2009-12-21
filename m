Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbZLUEHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbZLUEHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 23:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZLUEHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 23:07:13 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:46389 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZLUEHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 23:07:12 -0500
Date: Mon, 21 Dec 2009 15:07:10 +1100
From: Simon Horman <horms@verge.net.au>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch] rtl8192su: Build should select WIRELESS_EXT
Message-ID: <20091221040710.GA22636@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prevailing idiom is to select WIRELESS_EXT not depend on it.

Depending leaves this driver in a situation where it can only
be built if another driver that selects WIRELESS_EXT has been enabled.

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: net-next-2.6/drivers/staging/rtl8192su/Kconfig
===================================================================
--- net-next-2.6.orig/drivers/staging/rtl8192su/Kconfig	2009-12-21 11:59:46.000000000 +1100
+++ net-next-2.6/drivers/staging/rtl8192su/Kconfig	2009-12-21 12:02:35.000000000 +1100
@@ -1,6 +1,7 @@
 config RTL8192SU
 	tristate "RealTek RTL8192SU Wireless LAN NIC driver"
 	depends on PCI && WLAN && USB
-	depends on WIRELESS_EXT
+	select WIRELESS_EXT
+	select WEXT_PRIV
 	default N
 	---help---
