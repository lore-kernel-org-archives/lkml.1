Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZJUKjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZJUKjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 06:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZJUKjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 06:39:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:38914 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbZJUKjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 06:39:20 -0400
Subject: [PATCH 2.4] R8169: Fix compilation error when RTL8169_DEBUG is
 defined
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Edward Hsu <edward_hsu@realtek.com.tw>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 16:07:58 +0530
Message-Id: <1256121478.2681.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixed following compilations error :
r8169.c: In function `rtl8169_print_mac_version':
r8169.c:458: parse error before '}' token
r8169.c:462: parse error before '}' token
r8169.c: In function `rtl8169_print_phy_version':
r8169.c:501: parse error before '}' token
r8169.c:505: parse error before '}' token
r8169.c: In function `rtl8169_hw_phy_config':
r8169.c:552: parse error before '}' token
r8169.c:553: parse error before '}' token
r8169.c: In function `rtl8169_init_one':
r8169.c:880: parse error before '}' token
r8169.c:884: parse error before '}' token
r8169.c:889: parse error before '}' token
r8169.c:891: parse error before '}' token
r8169.c: In function `rtl8169_hw_start':
r8169.c:1136: parse error before '}' token
make[2]: *** [r8169.o] Error 1

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/net/r8169.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 8c7c202..5b00173 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -63,7 +63,8 @@ VERSION 1.2	<2002/11/30>
 	        printk( "Assertion failed! %s,%s,%s,line=%d\n",	\
         	#expr,__FILE__,__FUNCTION__,__LINE__);		\
         }
-#define dprintk(fmt, args...)	do { printk(PFX fmt, ## args) } while (0)
+#define dprintk(fmt, args...) \
+	do { printk(KERN_DEBUG PFX fmt, ## args); } while (0)
 #else
 #define assert(expr) do {} while (0)
 #define dprintk(fmt, args...)	do {} while (0)
@@ -1131,7 +1132,7 @@ rtl8169_hw_start(struct net_device *dev)
 	RTL_W16(CPlusCmd, tp->cp_cmd);
 
 	if (tp->mac_version == RTL_GIGA_MAC_VER_D) {
-		dprintk(KERN_INFO PFX "Set MAC Reg C+CR Offset 0xE0: bit-3 and bit-14 MUST be 1\n");
+		dprintk("Set MAC Reg C+CR Offset 0xE0: bit-3 and bit-14 MUST be 1\n");
 		tp->cp_cmd |= (1 << 14) | PCIMulRW;
 		RTL_W16(CPlusCmd, tp->cp_cmd);
 	}
-- 
1.6.1.GIT


