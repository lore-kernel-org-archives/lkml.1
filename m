Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbZI3JSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbZI3JSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 05:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbZI3JSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 05:18:07 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:48483 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZI3JSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 05:18:05 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] virtio_ids: let virtio header files include virtio_ids.h and export it
Date: Wed, 30 Sep 2009 11:17:21 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-release; KDE/4.3.1; i686; ; )
Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909301117.21964.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] virtio_ids: let header files include virtio_ids.h

Rusty,

commit 3ca4f5ca73057a617f9444a91022d7127041970a
    virtio: add virtio IDs file
moved all device IDs into a single file. While the change itself is 
a very good one, it can break userspace applications. For example
if a userspace tool wanted to get the ID of virtio_net it used to 
include virtio_net.h. This does no longer work, since virtio_net.h
does not include virtio_ids.h.
This patch moves all "#include <linux/virtio_ids.h>" from the C
files into the header files, making the header files compatible with
the old ones.

In addition, this patch exports virtio_ids.h to userspace.

CCed: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 Documentation/lguest/lguest.c       |    1 -
 drivers/block/virtio_blk.c          |    1 -
 drivers/char/hw_random/virtio-rng.c |    1 -
 drivers/char/virtio_console.c       |    1 -
 drivers/net/virtio_net.c            |    1 -
 drivers/virtio/virtio_balloon.c     |    1 -
 include/linux/Kbuild                |    1 +
 include/linux/virtio_9p.h           |    1 +
 include/linux/virtio_balloon.h      |    1 +
 include/linux/virtio_blk.h          |    1 +
 include/linux/virtio_console.h      |    1 +
 include/linux/virtio_net.h          |    1 +
 include/linux/virtio_rng.h          |    1 +
 net/9p/trans_virtio.c               |    1 -
 14 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/Documentation/lguest/lguest.c
===================================================================
--- linux-2.6.orig/Documentation/lguest/lguest.c
+++ linux-2.6/Documentation/lguest/lguest.c
@@ -42,7 +42,6 @@
 #include <signal.h>
 #include "linux/lguest_launcher.h"
 #include "linux/virtio_config.h"
-#include <linux/virtio_ids.h>
 #include "linux/virtio_net.h"
 #include "linux/virtio_blk.h"
 #include "linux/virtio_console.h"
Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c
+++ linux-2.6/drivers/block/virtio_blk.c
@@ -3,7 +3,6 @@
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/virtio.h>
-#include <linux/virtio_ids.h>
 #include <linux/virtio_blk.h>
 #include <linux/scatterlist.h>
 
Index: linux-2.6/drivers/char/hw_random/virtio-rng.c
===================================================================
--- linux-2.6.orig/drivers/char/hw_random/virtio-rng.c
+++ linux-2.6/drivers/char/hw_random/virtio-rng.c
@@ -21,7 +21,6 @@
 #include <linux/scatterlist.h>
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
-#include <linux/virtio_ids.h>
 #include <linux/virtio_rng.h>
 
 /* The host will fill any buffer we give it with sweet, sweet randomness.  We
Index: linux-2.6/drivers/char/virtio_console.c
===================================================================
--- linux-2.6.orig/drivers/char/virtio_console.c
+++ linux-2.6/drivers/char/virtio_console.c
@@ -31,7 +31,6 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/virtio.h>
-#include <linux/virtio_ids.h>
 #include <linux/virtio_console.h>
 #include "hvc_console.h"
 
Index: linux-2.6/drivers/net/virtio_net.c
===================================================================
--- linux-2.6.orig/drivers/net/virtio_net.c
+++ linux-2.6/drivers/net/virtio_net.c
@@ -22,7 +22,6 @@
 #include <linux/ethtool.h>
 #include <linux/module.h>
 #include <linux/virtio.h>
-#include <linux/virtio_ids.h>
 #include <linux/virtio_net.h>
 #include <linux/scatterlist.h>
 #include <linux/if_vlan.h>
Index: linux-2.6/drivers/virtio/virtio_balloon.c
===================================================================
--- linux-2.6.orig/drivers/virtio/virtio_balloon.c
+++ linux-2.6/drivers/virtio/virtio_balloon.c
@@ -19,7 +19,6 @@
  */
 //#define DEBUG
 #include <linux/virtio.h>
-#include <linux/virtio_ids.h>
 #include <linux/virtio_balloon.h>
 #include <linux/swap.h>
 #include <linux/kthread.h>
Index: linux-2.6/include/linux/Kbuild
===================================================================
--- linux-2.6.orig/include/linux/Kbuild
+++ linux-2.6/include/linux/Kbuild
@@ -363,6 +363,7 @@ unifdef-y += utsname.h
 unifdef-y += videodev2.h
 unifdef-y += videodev.h
 unifdef-y += virtio_config.h
+unifdef-y += virtio_ids.h
 unifdef-y += virtio_blk.h
 unifdef-y += virtio_net.h
 unifdef-y += virtio_9p.h
Index: linux-2.6/include/linux/virtio_9p.h
===================================================================
--- linux-2.6.orig/include/linux/virtio_9p.h
+++ linux-2.6/include/linux/virtio_9p.h
@@ -2,6 +2,7 @@
 #define _LINUX_VIRTIO_9P_H
 /* This header is BSD licensed so anyone can use the definitions to implement
  * compatible drivers/servers. */
+#include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
 /* Maximum number of virtio channels per partition (1 for now) */
Index: linux-2.6/include/linux/virtio_balloon.h
===================================================================
--- linux-2.6.orig/include/linux/virtio_balloon.h
+++ linux-2.6/include/linux/virtio_balloon.h
@@ -2,6 +2,7 @@
 #define _LINUX_VIRTIO_BALLOON_H
 /* This header is BSD licensed so anyone can use the definitions to implement
  * compatible drivers/servers. */
+#include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
 /* The feature bitmap for virtio balloon */
Index: linux-2.6/include/linux/virtio_blk.h
===================================================================
--- linux-2.6.orig/include/linux/virtio_blk.h
+++ linux-2.6/include/linux/virtio_blk.h
@@ -3,6 +3,7 @@
 /* This header is BSD licensed so anyone can use the definitions to implement
  * compatible drivers/servers. */
 #include <linux/types.h>
+#include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
 /* Feature bits */
Index: linux-2.6/include/linux/virtio_console.h
===================================================================
--- linux-2.6.orig/include/linux/virtio_console.h
+++ linux-2.6/include/linux/virtio_console.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_VIRTIO_CONSOLE_H
 #define _LINUX_VIRTIO_CONSOLE_H
 #include <linux/types.h>
+#include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 /* This header, excluding the #ifdef __KERNEL__ part, is BSD licensed so
  * anyone can use the definitions to implement compatible drivers/servers. */
Index: linux-2.6/include/linux/virtio_net.h
===================================================================
--- linux-2.6.orig/include/linux/virtio_net.h
+++ linux-2.6/include/linux/virtio_net.h
@@ -3,6 +3,7 @@
 /* This header is BSD licensed so anyone can use the definitions to implement
  * compatible drivers/servers. */
 #include <linux/types.h>
+#include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 #include <linux/if_ether.h>
 
Index: linux-2.6/include/linux/virtio_rng.h
===================================================================
--- linux-2.6.orig/include/linux/virtio_rng.h
+++ linux-2.6/include/linux/virtio_rng.h
@@ -2,6 +2,7 @@
 #define _LINUX_VIRTIO_RNG_H
 /* This header is BSD licensed so anyone can use the definitions to implement
  * compatible drivers/servers. */
+#include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
 #endif /* _LINUX_VIRTIO_RNG_H */
Index: linux-2.6/net/9p/trans_virtio.c
===================================================================
--- linux-2.6.orig/net/9p/trans_virtio.c
+++ linux-2.6/net/9p/trans_virtio.c
@@ -43,7 +43,6 @@
 #include <net/9p/transport.h>
 #include <linux/scatterlist.h>
 #include <linux/virtio.h>
-#include <linux/virtio_ids.h>
 #include <linux/virtio_9p.h>
 
 #define VIRTQUEUE_NUM	128
