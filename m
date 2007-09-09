Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbXIIUZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbXIIUZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759405AbXIIUYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:24:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60713 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759393AbXIIUYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:24:52 -0400
Date: Sun, 9 Sep 2007 22:24:59 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Shannon Nelson <shannon.nelson@intel.com>, dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] drivers/dma/ioat_dma.c: make 3 functions static
Message-ID: <20070909202459.GN3563@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc3-mm1:
>...
> +i-oat-add-support-for-msi-and-msi-x.patch
>...
>  ioat tree
>...

This patch makes three needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/dma/ioat_dma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

c633b44cd60648f456a11bb38fd9193ce4d6acdc 
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index e4c3afe..66c5bb5 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -47,8 +47,8 @@
 static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
 static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
 
-struct ioat_dma_chan *ioat_lookup_chan_by_index(struct ioatdma_device *device,
-						int index)
+static struct ioat_dma_chan *ioat_lookup_chan_by_index(struct ioatdma_device *device,
+						       int index)
 {
 	return device->idx[index];
 }
@@ -716,7 +716,7 @@ MODULE_PARM_DESC(ioat_interrupt_style,
  * ioat_dma_setup_interrupts - setup interrupt handler
  * @device: ioat device
  */
-int ioat_dma_setup_interrupts(struct ioatdma_device *device)
+static int ioat_dma_setup_interrupts(struct ioatdma_device *device)
 {
 	struct ioat_dma_chan *ioat_chan;
 	int err, i, j, msixcnt;
@@ -826,7 +826,7 @@ err_no_irq:
  * ioat_dma_remove_interrupts - remove whatever interrupts were set
  * @device: ioat device
  */
-void ioat_dma_remove_interrupts(struct ioatdma_device *device)
+static void ioat_dma_remove_interrupts(struct ioatdma_device *device)
 {
 	struct ioat_dma_chan *ioat_chan;
 	int i;

