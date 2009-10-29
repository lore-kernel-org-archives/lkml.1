Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbZJ2Q46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbZJ2Q46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZJ2Q45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:56:57 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:20485 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZJ2Q44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:56:56 -0400
Date: Thu, 29 Oct 2009 09:52:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: fix wireless drivers depends
Message-Id: <20091029095202.09161c1e.randy.dunlap@oracle.com>
In-Reply-To: <20091029182919.4d6ec52c.sfr@canb.auug.org.au>
References: <20091029182919.4d6ec52c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AE9C952.00B0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

These drivers can (erroneously) be enabled even when
CONFIG_NET=n, CONFIG_NETDEVICES=n, CONFIG_WLAN=n, etc.
Stop this.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/rtl8187se/Kconfig |    2 +-
 drivers/staging/rtl8192e/Kconfig  |    2 +-
 drivers/staging/rtl8192su/Kconfig |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20091029.orig/drivers/staging/rtl8187se/Kconfig
+++ linux-next-20091029/drivers/staging/rtl8187se/Kconfig
@@ -1,6 +1,6 @@
 config RTL8187SE
 	tristate "RealTek RTL8187SE Wireless LAN NIC driver"
-	depends on PCI
+	depends on PCI && WLAN
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	default N
--- linux-next-20091029.orig/drivers/staging/rtl8192e/Kconfig
+++ linux-next-20091029/drivers/staging/rtl8192e/Kconfig
@@ -1,6 +1,6 @@
 config RTL8192E
 	tristate "RealTek RTL8192E Wireless LAN NIC driver"
-	depends on PCI
+	depends on PCI && WLAN
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	default N
--- linux-next-20091029.orig/drivers/staging/rtl8192su/Kconfig
+++ linux-next-20091029/drivers/staging/rtl8192su/Kconfig
@@ -1,6 +1,6 @@
 config RTL8192SU
 	tristate "RealTek RTL8192SU Wireless LAN NIC driver"
-	depends on PCI
+	depends on PCI && WLAN
 	depends on WIRELESS_EXT
 	default N
 	---help---
