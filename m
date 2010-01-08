Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948Ab0AHKop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab0AHKop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 05:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261Ab0AHKoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 05:44:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:58115 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752214Ab0AHKoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 05:44:44 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+zIDxDwSizNCDh+y40hlBMeSqT7807e5I0XoXCwL
	LvJtvvxsZc2m2Q
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 2/3 v3] staging/rtl8192u: Add select WEXT_PRIV to Kconfig to prevent build failure
Date: Fri, 8 Jan 2010 11:44:38 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: devel@driverdev.osuosl.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201001072133.20487.PeterHuewe@gmx.de> <201001080914.39084.PeterHuewe@gmx.de> <20100108101822.GA27997@verge.net.au>
In-Reply-To: <20100108101822.GA27997@verge.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001081144.39138.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Fri, 8 Jan 2010 09:10:13 +0100

Without WEXT_PRIV set the driver fails to build due to unknown fields in
the iw_handler_def struct.
Those fields are enclosed in WEXT_PRIV conditionals in the prototype
of iw_handler_def in include/net/iw_handler.h

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Acked-by: Simon Horman <horms@verge.net.au>
---
 drivers/staging/rtl8192u/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8192u/Kconfig b/drivers/staging/rtl8192u/Kconfig
index 9913ab8..0439c90 100644
--- a/drivers/staging/rtl8192u/Kconfig
+++ b/drivers/staging/rtl8192u/Kconfig
@@ -1,6 +1,7 @@
 config RTL8192U
 	tristate "RealTek RTL8192U Wireless LAN NIC driver"
 	depends on PCI && WLAN && USB
-	depends on WIRELESS_EXT
+	select WIRELESS_EXT
+	select WEXT_PRIV
 	default N
 	---help---
-- 
1.6.4.4

