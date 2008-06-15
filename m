Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYFOHwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYFOHwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 03:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbYFOHwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 03:52:34 -0400
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:61470 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYFOHwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 03:52:33 -0400
Message-ID: <4854CA3E.60208@freemail.hu>
Date: Sun, 15 Jun 2008 09:52:30 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       David Newall <davidn@davidnewall.com>
CC: Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] 8139too: some style cleanups
References: <4853BB62.1060109@freemail.hu> <4853C8AD.9020407@s5r6.in-berlin.de> <48541165.7050304@freemail.hu> <485421C1.8010102@s5r6.in-berlin.de> <4854C9BF.8040900@freemail.hu>
In-Reply-To: <4854C9BF.8040900@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-DCC--Metrics: mail02d.mail.t-online.hu 0; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Clean up the following errors and warnings reported by checkpatch.pl:
 + ERROR: Macros with complex values should be enclosed in parenthesis
 + WARNING: __func__ should be used instead of gcc specific __FUNCTION__
 + WARNING: plain inline is preferred over __inline__
 + WARNING: Use #include <linux/io.h> instead of <asm/io.h>
 + WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

The changes were verified with by comparing the "objdump -d 8139too.ko"
output which is exactly the same for the old and new version in case of
config CONFIG_8139TOO=m, CONFIG_8139TOO_PIO=n, CONFIG_8139TOO_TUNE_TWISTER=n,
CONFIG_8139TOO_8129=n, CONFIG_8139_OLD_RX_RESET=n.
Software versions used: gcc 4.2.3, objdump 2.18.0.20080103, on elf32-i386.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- a/drivers/net/8139too.c	2008-06-14 00:20:47.000000000 +0200
+++ b/drivers/net/8139too.c	2008-06-15 09:10:14.000000000 +0200
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
@@ -134,7 +134,7 @@

 #if RTL8139_DEBUG
 /* note: prints function name for you */
-#  define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+#  define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
 #else
 #  define DPRINTK(fmt, args...)
 #endif
@@ -145,7 +145,7 @@
 #  define assert(expr) \
         if(unlikely(!(expr))) {				        \
         printk(KERN_ERR "Assertion failed! %s,%s,%s,line=%d\n",	\
-        #expr,__FILE__,__FUNCTION__,__LINE__);		        \
+	#expr, __FILE__, __func__, __LINE__);			\
         }
 #endif

@@ -219,7 +219,7 @@ enum {
 #define RTL8139B_IO_SIZE 256

 #define RTL8129_CAPS	HAS_MII_XCVR
-#define RTL8139_CAPS	HAS_CHIP_XCVR|HAS_LNK_CHNG
+#define RTL8139_CAPS	(HAS_CHIP_XCVR|HAS_LNK_CHNG)

 typedef enum {
 	RTL8139 = 0,
@@ -1890,7 +1890,7 @@ static void rtl8139_rx_err (u32 rx_statu
 }

 #if RX_BUF_IDX == 3
-static __inline__ void wrap_copy(struct sk_buff *skb, const unsigned char *ring,
+static inline void wrap_copy(struct sk_buff *skb, const unsigned char *ring,
 				 u32 offset, unsigned int size)
 {
 	u32 left = RX_BUF_LEN - offset;
