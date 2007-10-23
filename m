Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbXJWPlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbXJWPlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbXJWPlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:41:11 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:40236 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbXJWPlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:41:10 -0400
Date: Tue, 23 Oct 2007 16:41:06 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Fix breakage after SG cleanups
Message-ID: <20071023154106.GA29757@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patches

   58b053e4ce9d2fc3023645c1b96e537c72aa8d9a
   45711f1af6eff1a6d010703b4862e0d2b9afd056
   fa05f1286be25a8ce915c5dd492aea61126b3f33

convert many files to use the scatter gather helpers without ensuring
that the necessary headerfile <linux/scatterlist> is included.  This
happened to work for ia64, powerpc, sparc64 and x86 because they happened
to drag in that file via their <asm/dma-mapping.h>.  On most of the others
this probably broke.

Instead of increasing the header file spider web I choose to include
<linux/scatterlist.h> directly into the affectes files.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---

 drivers/block/DAC960.c                 |    1 +
 drivers/block/cpqarray.c               |    1 +
 drivers/block/sx8.c                    |    1 +
 drivers/ide/ide-probe.c                |    1 +
 drivers/ieee1394/dma.c                 |    2 +-
 drivers/media/video/ivtv/ivtv-driver.h |    1 +
 drivers/media/video/videobuf-dma-sg.c  |    1 +
 drivers/mmc/host/sdhci.c               |    1 +
 drivers/usb/core/message.c             |    2 +-
 include/media/saa7146.h                |    1 +
 net/ieee80211/ieee80211_crypt_tkip.c   |    1 +
 net/ieee80211/ieee80211_crypt_wep.c    |    1 +
 net/mac80211/wep.c                     |    2 +-
 net/sctp/sm_make_chunk.c               |    2 +-
 net/xfrm/xfrm_algo.c                   |    2 +-
 15 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 5350542..9030c37 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -44,6 +44,7 @@
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/random.h>
+#include <linux/scatterlist.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include "DAC960.h"
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index efab27f..c8132d9 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -37,6 +37,7 @@
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
+#include <linux/scatterlist.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 282a695..52dc5e1 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -27,6 +27,7 @@
 #include <linux/hdreg.h>
 #include <linux/dma-mapping.h>
 #include <linux/completion.h>
+#include <linux/scatterlist.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index ec55a17..6a6f2e0 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -47,6 +47,7 @@
 #include <linux/spinlock.h>
 #include <linux/kmod.h>
 #include <linux/pci.h>
+#include <linux/scatterlist.h>
 
 #include <asm/byteorder.h>
 #include <asm/irq.h>
diff --git a/drivers/ieee1394/dma.c b/drivers/ieee1394/dma.c
index 25e113b..3051e31 100644
--- a/drivers/ieee1394/dma.c
+++ b/drivers/ieee1394/dma.c
@@ -12,7 +12,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 
 #include "dma.h"
 
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index 3bda1df..49ce14d 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -51,6 +51,7 @@
 #include <linux/unistd.h>
 #include <linux/byteorder/swab.h>
 #include <linux/pagemap.h>
+#include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 0a18286..9ab94a7 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -27,6 +27,7 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
+#include <linux/scatterlist.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 0db837e..d7c5b94 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -13,6 +13,7 @@
 #include <linux/highmem.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
 
 #include <linux/mmc/host.h>
 
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 90d64a8..8bdaa15 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -11,9 +11,9 @@
 #include <linux/timer.h>
 #include <linux/ctype.h>
 #include <linux/device.h>
+#include <linux/scatterlist.h>
 #include <linux/usb/quirks.h>
 #include <asm/byteorder.h>
-#include <asm/scatterlist.h>
 
 #include "hcd.h"	/* for usbcore internals */
 #include "usb.h"
diff --git a/include/media/saa7146.h b/include/media/saa7146.h
index cd3ff2c..88b2b5a 100644
--- a/include/media/saa7146.h
+++ b/include/media/saa7146.h
@@ -12,6 +12,7 @@
 #include <asm/io.h>		/* for accessing devices */
 #include <linux/stringify.h>
 #include <linux/mutex.h>
+#include <linux/scatterlist.h>
 
 #include <linux/vmalloc.h>	/* for vmalloc() */
 #include <linux/mm.h>		/* for vmalloc_to_page() */
diff --git a/net/ieee80211/ieee80211_crypt_tkip.c b/net/ieee80211/ieee80211_crypt_tkip.c
index c796661..8117776 100644
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/random.h>
+#include <linux/scatterlist.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/mm.h>
diff --git a/net/ieee80211/ieee80211_crypt_wep.c b/net/ieee80211/ieee80211_crypt_wep.c
index 0af6103..9693429 100644
--- a/net/ieee80211/ieee80211_crypt_wep.c
+++ b/net/ieee80211/ieee80211_crypt_wep.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/random.h>
+#include <linux/scatterlist.h>
 #include <linux/skbuff.h>
 #include <linux/mm.h>
 #include <asm/string.h>
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index cc806d6..a84a233 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -16,7 +16,7 @@
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/mm.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index d5a9785..658476c 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -56,7 +56,7 @@
 #include <linux/ipv6.h>
 #include <linux/net.h>
 #include <linux/inet.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <linux/crypto.h>
 #include <net/sock.h>
 
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index fb2220a..f2e4c53 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/pfkeyv2.h>
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include <net/xfrm.h>
 #if defined(CONFIG_INET_AH) || defined(CONFIG_INET_AH_MODULE) || defined(CONFIG_INET6_AH) || defined(CONFIG_INET6_AH_MODULE)
 #include <net/ah.h>
@@ -20,7 +21,6 @@
 #if defined(CONFIG_INET_ESP) || defined(CONFIG_INET_ESP_MODULE) || defined(CONFIG_INET6_ESP) || defined(CONFIG_INET6_ESP_MODULE)
 #include <net/esp.h>
 #endif
-#include <asm/scatterlist.h>
 
 /*
  * Algorithms supported by IPsec.  These entries contain properties which
