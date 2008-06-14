Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYFNSoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYFNSoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 14:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYFNSoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 14:44:22 -0400
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:58247 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYFNSoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 14:44:18 -0400
Message-ID: <48541173.7040905@freemail.hu>
Date: Sat, 14 Jun 2008 20:44:03 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: netdev@vger.kernel.org, Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] 8139too: different style cleanups
References: <4853BB7B.4030905@freemail.hu>
In-Reply-To: <4853BB7B.4030905@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC--Metrics: mail01d.mail.t-online.hu 0; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Clean up the following errors and warnings reported by checkpatch.pl:
 - Use #include <linux/io.h> instead of <asm/io.h>
 - Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
 - __func__ should be used instead of gcc specific __FUNCTION__
 - Macros with complex values should be enclosed in parenthesis
 - do not add new typedefs
 - trailing statements should be on next line
 - braces {} are not necessary for single statement blocks
 - plain inline is preferred over __inline__

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- b/drivers/net/8139too.c	2008-06-14 20:32:45.000000000 +0200
+++ c/drivers/net/8139too.c	2008-06-14 20:38:24.000000000 +0200
@@ -107,8 +107,8 @@
 #include <linux/mii.h>
 #include <linux/completion.h>
 #include <linux/crc32.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/irq.h>

 #define RTL8139_DRIVER_NAME   DRV_NAME " Fast Ethernet driver " DRV_VERSION
@@ -135,7 +135,7 @@
 #if RTL8139_DEBUG
 /* note: prints function name for you */
 #  define DPRINTK(fmt, args...) \
-	printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+	printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
 #else
 #  define DPRINTK(fmt, args...)
 #endif
@@ -146,7 +146,7 @@
 #  define assert(expr) \
 	if (unlikely(!(expr))) {					\
 		printk(KERN_ERR "Assertion failed! %s,%s,%s,line=%d\n",	\
-		       #expr, __FILE__, __FUNCTION__, __LINE__);	\
+		       #expr, __FILE__, __func__, __LINE__);	\
 	}
 #endif

@@ -222,9 +222,9 @@ enum {
 #define RTL8139B_IO_SIZE 256

 #define RTL8129_CAPS	HAS_MII_XCVR
-#define RTL8139_CAPS	HAS_CHIP_XCVR|HAS_LNK_CHNG
+#define RTL8139_CAPS	(HAS_CHIP_XCVR|HAS_LNK_CHNG)

-typedef enum {
+enum {
 	RTL8139 = 0,
 	RTL8129,
 } board_t;
@@ -1035,7 +1035,8 @@ static int __devinit rtl8139_init_one(st
 	/* dev is fully set up and ready to use now */
 	DPRINTK("about to register device named %s (%p)...\n", dev->name, dev);
 	i = register_netdev(dev);
-	if (i) goto err_out;
+	if (i)
+		goto err_out;

 	pci_set_drvdata(pdev, dev);

@@ -1380,9 +1381,9 @@ static void rtl_check_media(struct net_d
 {
 	struct rtl8139_private *tp = netdev_priv(dev);

-	if (tp->phys[0] >= 0) {
+	if (tp->phys[0] >= 0)
 		mii_check_media(&tp->mii, netif_msg_link(tp), init_media);
-	}
+
 }

 /* Start the hardware at open or resume. */
@@ -1923,7 +1924,7 @@ static void rtl8139_rx_err(u32 rx_status
 }

 #if RX_BUF_IDX == 3
-static __inline__ void wrap_copy(struct sk_buff *skb, const unsigned char *ring,
+static inline void wrap_copy(struct sk_buff *skb, const unsigned char *ring,
 				 u32 offset, unsigned int size)
 {
 	u32 left = RX_BUF_LEN - offset;
