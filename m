Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbZGaGZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbZGaGZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 02:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZGaGZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 02:25:57 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:41021 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZGaGZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 02:25:56 -0400
Message-ID: <4A728E74.1070805@oss.ntt.co.jp>
Date: Fri, 31 Jul 2009 15:25:56 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: rusty@rustcorp.com.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add virtio IDs file
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virtio IDs are spread all over the tree which makes assigning new IDs
bothersome. Putting them together should make the process less error-prone.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.31-rc4-orig/Documentation/lguest/lguest.c linux-2.6.31-rc4/Documentation/lguest/lguest.c
--- linux-2.6.31-rc4-orig/Documentation/lguest/lguest.c	2009-07-29 17:13:14.416245339 +0900
+++ linux-2.6.31-rc4/Documentation/lguest/lguest.c	2009-07-31 13:40:56.315410807 +0900
@@ -40,6 +40,7 @@
  #include <signal.h>
  #include "linux/lguest_launcher.h"
  #include "linux/virtio_config.h"
+#include <linux/virtio_ids.h>
  #include "linux/virtio_net.h"
  #include "linux/virtio_blk.h"
  #include "linux/virtio_console.h"
diff -urNp linux-2.6.31-rc4-orig/drivers/block/virtio_blk.c linux-2.6.31-rc4/drivers/block/virtio_blk.c
--- linux-2.6.31-rc4-orig/drivers/block/virtio_blk.c	2009-07-29 17:14:42.447244755 +0900
+++ linux-2.6.31-rc4/drivers/block/virtio_blk.c	2009-07-31 13:41:32.679092389 +0900
@@ -3,6 +3,7 @@
  #include <linux/blkdev.h>
  #include <linux/hdreg.h>
  #include <linux/virtio.h>
+#include <linux/virtio_ids.h>
  #include <linux/virtio_blk.h>
  #include <linux/scatterlist.h>

diff -urNp linux-2.6.31-rc4-orig/drivers/char/hw_random/virtio-rng.c linux-2.6.31-rc4/drivers/char/hw_random/virtio-rng.c
--- linux-2.6.31-rc4-orig/drivers/char/hw_random/virtio-rng.c	2009-07-29 17:14:45.415742419 +0900
+++ linux-2.6.31-rc4/drivers/char/hw_random/virtio-rng.c	2009-07-31 13:43:03.476180870 +0900
@@ -21,6 +21,7 @@
  #include <linux/scatterlist.h>
  #include <linux/spinlock.h>
  #include <linux/virtio.h>
+#include <linux/virtio_ids.h>
  #include <linux/virtio_rng.h>

  /* The host will fill any buffer we give it with sweet, sweet randomness.  We
diff -urNp linux-2.6.31-rc4-orig/drivers/char/virtio_console.c linux-2.6.31-rc4/drivers/char/virtio_console.c
--- linux-2.6.31-rc4-orig/drivers/char/virtio_console.c	2009-07-29 17:14:49.507745715 +0900
+++ linux-2.6.31-rc4/drivers/char/virtio_console.c	2009-07-31 13:45:23.170519870 +0900
@@ -31,6 +31,7 @@
  #include <linux/err.h>
  #include <linux/init.h>
  #include <linux/virtio.h>
+#include <linux/virtio_ids.h>
  #include <linux/virtio_console.h>
  #include "hvc_console.h"

diff -urNp linux-2.6.31-rc4-orig/drivers/net/virtio_net.c linux-2.6.31-rc4/drivers/net/virtio_net.c
--- linux-2.6.31-rc4-orig/drivers/net/virtio_net.c	2009-07-29 17:15:48.727745405 +0900
+++ linux-2.6.31-rc4/drivers/net/virtio_net.c	2009-07-31 13:46:13.937912171 +0900
@@ -22,6 +22,7 @@
  #include <linux/ethtool.h>
  #include <linux/module.h>
  #include <linux/virtio.h>
+#include <linux/virtio_ids.h>
  #include <linux/virtio_net.h>
  #include <linux/scatterlist.h>
  #include <linux/if_vlan.h>
diff -urNp linux-2.6.31-rc4-orig/drivers/virtio/virtio_balloon.c linux-2.6.31-rc4/drivers/virtio/virtio_balloon.c
--- linux-2.6.31-rc4-orig/drivers/virtio/virtio_balloon.c	2009-07-29 17:16:29.155745508 +0900
+++ linux-2.6.31-rc4/drivers/virtio/virtio_balloon.c	2009-07-31 13:47:18.547759028 +0900
@@ -19,6 +19,7 @@
   */
  //#define DEBUG
  #include <linux/virtio.h>
+#include <linux/virtio_ids.h>
  #include <linux/virtio_balloon.h>
  #include <linux/swap.h>
  #include <linux/kthread.h>
diff -urNp linux-2.6.31-rc4-orig/include/linux/virtio_9p.h linux-2.6.31-rc4/include/linux/virtio_9p.h
--- linux-2.6.31-rc4-orig/include/linux/virtio_9p.h	2009-06-10 12:05:27.000000000 +0900
+++ linux-2.6.31-rc4/include/linux/virtio_9p.h	2009-07-31 13:51:35.907410676 +0900
@@ -4,8 +4,6 @@
   * compatible drivers/servers. */
  #include <linux/virtio_config.h>

-/* The ID for virtio console */
-#define VIRTIO_ID_9P	9
  /* Maximum number of virtio channels per partition (1 for now) */
  #define MAX_9P_CHAN	1

diff -urNp linux-2.6.31-rc4-orig/include/linux/virtio_balloon.h linux-2.6.31-rc4/include/linux/virtio_balloon.h
--- linux-2.6.31-rc4-orig/include/linux/virtio_balloon.h	2009-06-10 12:05:27.000000000 +0900
+++ linux-2.6.31-rc4/include/linux/virtio_balloon.h	2009-07-31 13:53:30.395410975 +0900
@@ -4,9 +4,6 @@
   * compatible drivers/servers. */
  #include <linux/virtio_config.h>

-/* The ID for virtio_balloon */
-#define VIRTIO_ID_BALLOON	5
-
  /* The feature bitmap for virtio balloon */
  #define VIRTIO_BALLOON_F_MUST_TELL_HOST	0 /* Tell before reclaiming pages */

diff -urNp linux-2.6.31-rc4-orig/include/linux/virtio_blk.h linux-2.6.31-rc4/include/linux/virtio_blk.h
--- linux-2.6.31-rc4-orig/include/linux/virtio_blk.h	2009-07-29 17:17:36.274541593 +0900
+++ linux-2.6.31-rc4/include/linux/virtio_blk.h	2009-07-31 14:00:29.715412122 +0900
@@ -5,9 +5,6 @@
  #include <linux/types.h>
  #include <linux/virtio_config.h>

-/* The ID for virtio_block */
-#define VIRTIO_ID_BLOCK	2
-
  /* Feature bits */
  #define VIRTIO_BLK_F_BARRIER	0	/* Does host support barriers? */
  #define VIRTIO_BLK_F_SIZE_MAX	1	/* Indicates maximum segment size */
diff -urNp linux-2.6.31-rc4-orig/include/linux/virtio_console.h linux-2.6.31-rc4/include/linux/virtio_console.h
--- linux-2.6.31-rc4-orig/include/linux/virtio_console.h	2009-06-10 12:05:27.000000000 +0900
+++ linux-2.6.31-rc4/include/linux/virtio_console.h	2009-07-31 13:56:07.087410608 +0900
@@ -5,9 +5,6 @@
  /* This header, excluding the #ifdef __KERNEL__ part, is BSD licensed so
   * anyone can use the definitions to implement compatible drivers/servers. */

-/* The ID for virtio console */
-#define VIRTIO_ID_CONSOLE	3
-
  /* Feature bits */
  #define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */

diff -urNp linux-2.6.31-rc4-orig/include/linux/virtio_ids.h linux-2.6.31-rc4/include/linux/virtio_ids.h
--- linux-2.6.31-rc4-orig/include/linux/virtio_ids.h	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.31-rc4/include/linux/virtio_ids.h	2009-07-31 14:01:08.738140436 +0900
@@ -0,0 +1,13 @@
+/*
+ * Virtio IDs
+ *
+ * This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ */
+
+#define VIRTIO_ID_NET		1 /* virtio net */
+#define VIRTIO_ID_BLOCK		2 /* virtio block */
+#define VIRTIO_ID_CONSOLE	3 /* virtio console */
+#define VIRTIO_ID_RNG		4 /* virtio ring */
+#define VIRTIO_ID_BALLOON	5 /* virtio balloon */
+#define VIRTIO_ID_9P		9 /* 9p virtio console */
diff -urNp linux-2.6.31-rc4-orig/include/linux/virtio_net.h linux-2.6.31-rc4/include/linux/virtio_net.h
--- linux-2.6.31-rc4-orig/include/linux/virtio_net.h	2009-07-29 17:17:36.475242342 +0900
+++ linux-2.6.31-rc4/include/linux/virtio_net.h	2009-07-31 14:02:02.259866229 +0900
@@ -6,9 +6,6 @@
  #include <linux/virtio_config.h>
  #include <linux/if_ether.h>

-/* The ID for virtio_net */
-#define VIRTIO_ID_NET	1
-
  /* The feature bitmap for virtio net */
  #define VIRTIO_NET_F_CSUM	0	/* Host handles pkts w/ partial csum */
  #define VIRTIO_NET_F_GUEST_CSUM	1	/* Guest handles pkts w/ partial csum */
diff -urNp linux-2.6.31-rc4-orig/include/linux/virtio_rng.h linux-2.6.31-rc4/include/linux/virtio_rng.h
--- linux-2.6.31-rc4-orig/include/linux/virtio_rng.h	2009-06-10 12:05:27.000000000 +0900
+++ linux-2.6.31-rc4/include/linux/virtio_rng.h	2009-07-31 13:59:35.223412171 +0900
@@ -4,7 +4,4 @@
   * compatible drivers/servers. */
  #include <linux/virtio_config.h>

-/* The ID for virtio_rng */
-#define VIRTIO_ID_RNG	4
-
  #endif /* _LINUX_VIRTIO_RNG_H */
diff -urNp linux-2.6.31-rc4-orig/net/9p/trans_virtio.c linux-2.6.31-rc4/net/9p/trans_virtio.c
--- linux-2.6.31-rc4-orig/net/9p/trans_virtio.c	2009-07-31 12:15:04.537910882 +0900
+++ linux-2.6.31-rc4/net/9p/trans_virtio.c	2009-07-31 14:03:15.287410913 +0900
@@ -43,6 +43,7 @@
  #include <net/9p/transport.h>
  #include <linux/scatterlist.h>
  #include <linux/virtio.h>
+#include <linux/virtio_ids.h>
  #include <linux/virtio_9p.h>

  #define VIRTQUEUE_NUM	128
