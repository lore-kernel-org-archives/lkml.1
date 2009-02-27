Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbZB0Wva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbZB0Wva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758203AbZB0WvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:51:20 -0500
Received: from kroah.org ([198.145.64.141]:53516 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758159AbZB0WvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:51:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/5] Staging: rtl8187se: fix Kconfig dependencies
Date: Fri, 27 Feb 2009 14:49:18 -0800
Message-Id: <1235774963-19732-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <20090227224555.GB19545@kroah.com>
References: <20090227224555.GB19545@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

rtl8187se uses wireless extensions so it needs to depend on
WIRELESS_EXT (or select it).

rtl8187se uses fields in struct net_device that are only present
if CONFIG_COMPAT_NET_DEV_OPS=y, so it needs to depend on
that symbol also.

drivers/staging/rtl8187se/r8180_core.c:5973: error: 'struct net_device' has no member named 'wireless_handlers'
drivers/staging/rtl8187se/r8180_core.c:5982: error: 'struct net_device' has no member named 'wireless_handlers'

drivers/staging/rtl8187se/r8180_core.c:201: error: 'struct net_device' has no member named 'stop'
drivers/staging/rtl8187se/r8180_core.c:4584: error: 'struct net_device' has no member named 'get_stats'
drivers/staging/rtl8187se/r8180_core.c:5969: error: 'struct net_device' has no member named 'open'
drivers/staging/rtl8187se/r8180_core.c:5970: error: 'struct net_device' has no member named 'stop'
drivers/staging/rtl8187se/r8180_core.c:5972: error: 'struct net_device' has no member named 'tx_timeout'
drivers/staging/rtl8187se/r8180_core.c:5974: error: 'struct net_device' has no member named 'do_ioctl'
drivers/staging/rtl8187se/r8180_core.c:5975: error: 'struct net_device' has no member named 'set_multicast_list'
drivers/staging/rtl8187se/r8180_core.c:5976: error: 'struct net_device' has no member named 'set_mac_address'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/rtl8187se/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rtl8187se/Kconfig b/drivers/staging/rtl8187se/Kconfig
index 79c225a..f636296 100644
--- a/drivers/staging/rtl8187se/Kconfig
+++ b/drivers/staging/rtl8187se/Kconfig
@@ -1,5 +1,6 @@
 config RTL8187SE
 	tristate "RealTek RTL8187SE Wireless LAN NIC driver"
 	depends on PCI
+	depends on WIRELESS_EXT && COMPAT_NET_DEV_OPS
 	default N
 	---help---
-- 
1.6.0.2

