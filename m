Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbZBKV3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbZBKV3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758073AbZBKV1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:27:00 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:28289 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031AbZBKV07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:26:59 -0500
Date: Wed, 11 Feb 2009 13:20:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Subject: [PATCH 7/9 replacement] staging/rtl8187se: fix Kconfig dependencies
Message-Id: <20090211132044.9e6e04d9.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4993429C.0265:SCFSTAT928724,ss=1,fgs=0
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
cc: Greg KH <gregkh@suse.de>
---
 drivers/staging/rtl8187se/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2009-0210-1635.orig/drivers/staging/rtl8187se/Kconfig
+++ mmotm-2009-0210-1635/drivers/staging/rtl8187se/Kconfig
@@ -1,5 +1,6 @@
 config RTL8187SE
 	tristate "RealTek RTL8187SE Wireless LAN NIC driver"
 	depends on PCI
+	depends on WIRELESS_EXT && COMPAT_NET_DEV_OPS
 	default N
 	---help---
