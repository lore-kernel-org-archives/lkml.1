Return-Path: <linux-kernel-owner+w=401wt.eu-S1760522AbZKFWez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522AbZKFWez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760508AbZKFWex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:34:53 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:39618 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760500AbZKFWet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:34:49 -0500
Message-ID: <4AF4B2B3.8020109@oracle.com>
Date: Fri, 06 Nov 2009 15:35:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH -next] staging/wireless: don't build when NET etc. are not
 enabled
References: <20091106181330.80bca052.sfr@canb.auug.org.au>
In-Reply-To: <20091106181330.80bca052.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AF4A486.0098:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

These wireless drivers in staging could be built when
CONFIG_NET=n, CONFIG_NETDEVICES=n, causing this build error:

net/wireless/wext-priv.c: In function 'ioctl_private_call':
net/wireless/wext-priv.c:206: error: implicit declaration of function 'call_commit_handler'

due to faulty selects.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/arlan/Kconfig   |    2 +-
 drivers/staging/netwave/Kconfig |    2 +-
 drivers/staging/wavelan/Kconfig |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20091106.orig/drivers/staging/arlan/Kconfig
+++ linux-next-20091106/drivers/staging/arlan/Kconfig
@@ -1,6 +1,6 @@
 config ARLAN
 	tristate "Aironet Arlan 655 & IC2200 DS support"
-	depends on ISA && !64BIT
+	depends on ISA && !64BIT && WLAN
 	select WIRELESS_EXT
 	---help---
 	  Aironet makes Arlan, a class of wireless LAN adapters. These use the
--- linux-next-20091106.orig/drivers/staging/netwave/Kconfig
+++ linux-next-20091106/drivers/staging/netwave/Kconfig
@@ -1,6 +1,6 @@
 config PCMCIA_NETWAVE
 	tristate "Xircom Netwave AirSurfer Pcmcia wireless support"
-	depends on PCMCIA
+	depends on PCMCIA && WLAN
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	help
--- linux-next-20091106.orig/drivers/staging/wavelan/Kconfig
+++ linux-next-20091106/drivers/staging/wavelan/Kconfig
@@ -1,6 +1,6 @@
 config WAVELAN
 	tristate "AT&T/Lucent old WaveLAN & DEC RoamAbout DS ISA support"
-	depends on ISA
+	depends on ISA && WLAN
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
@@ -25,7 +25,7 @@ config WAVELAN
 
 config PCMCIA_WAVELAN
 	tristate "AT&T/Lucent old WaveLAN Pcmcia wireless support"
-	depends on PCMCIA
+	depends on PCMCIA && WLAN
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
