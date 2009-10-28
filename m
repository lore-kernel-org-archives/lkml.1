Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZJ1XN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZJ1XN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 19:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZJ1XNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 19:13:54 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:61789 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZJ1XNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 19:13:53 -0400
Date: Wed, 28 Oct 2009 16:08:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linville@tuxdriver.com
Subject: [PATCH -next] wireless: airo_cs needs WEXT_SPY
Message-Id: <20091028160832.411ff31d.randy.dunlap@oracle.com>
In-Reply-To: <20091028190643.627f10aa.sfr@canb.auug.org.au>
References: <20091028190643.627f10aa.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AE8D026.0188:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

airo_cs uses spy interfaces so it needs to select WEXT_SPY.

ERROR: "iw_handler_set_thrspy" [drivers/net/wireless/airo.ko] undefined!
ERROR: "wireless_spy_update" [drivers/net/wireless/airo.ko] undefined!
ERROR: "iw_handler_get_spy" [drivers/net/wireless/airo.ko] undefined!
ERROR: "iw_handler_get_thrspy" [drivers/net/wireless/airo.ko] undefined!
ERROR: "iw_handler_set_spy" [drivers/net/wireless/airo.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20091028.orig/drivers/net/wireless/Kconfig
+++ linux-next-20091028/drivers/net/wireless/Kconfig
@@ -111,6 +111,7 @@ config AIRO_CS
 	tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
 	depends on PCMCIA && (BROKEN || !M32R)
 	select WIRELESS_EXT
+	select WEXT_SPY
 	select CRYPTO
 	select CRYPTO_AES
 	---help---
