Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbYETVQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbYETVQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933221AbYETVQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:16:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:57010 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933033AbYETVQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:16:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,517,1204531200"; 
   d="scan'208";a="283335857"
Subject: [git pull] drivers/dma: fixups for 2.6.26-rc
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: zw@zh-kernel.org, leoli@freescale.com, christophe.jaillet@wanadoo.fr,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 14:16:12 -0700
Message-Id: <1211318172.9442.7.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

to receive:

Christophe Jaillet (1):
      iop-adma: fixup some kzalloc/memset confusions

Zhang Wei (1):
      fsldma: update the fsldma driver MAINTAINERS info

 MAINTAINERS            |    6 ++++--
 drivers/dma/iop-adma.c |    6 ++----
 2 files changed, 6 insertions(+), 6 deletions(-)


Just a maintainer update and some simple cleanups of the iop-adma
driver.

Thanks,
Dan

Full log:
commit eccf2144e1232c33a8235033ffa079b6ebf92faf
Author: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Date:   Tue May 20 16:33:06 2008 -0700

    iop-adma: fixup some kzalloc/memset confusions
    
    1) Remove an explicit memset(.., 0, ...) to a variable allocated with
    kzalloc (i.e. 'dest').
    
    2) Allocate 'src' with kmalloc instead of kzalloc as all elements of the
    'src' buffer are initialized in a 'for(...)' loop just after.
    
    3) remove useless 'sizeof(u8)', which always returns 1, when computing the
    size of the memory to be allocated.
    
    Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 762b729..0ec0f43 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -821,10 +821,10 @@ static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device *device)
 
 	dev_dbg(device->common.dev, "%s\n", __func__);
 
-	src = kzalloc(sizeof(u8) * IOP_ADMA_TEST_SIZE, GFP_KERNEL);
+	src = kmalloc(IOP_ADMA_TEST_SIZE, GFP_KERNEL);
 	if (!src)
 		return -ENOMEM;
-	dest = kzalloc(sizeof(u8) * IOP_ADMA_TEST_SIZE, GFP_KERNEL);
+	dest = kzalloc(IOP_ADMA_TEST_SIZE, GFP_KERNEL);
 	if (!dest) {
 		kfree(src);
 		return -ENOMEM;
@@ -834,8 +834,6 @@ static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device *device)
 	for (i = 0; i < IOP_ADMA_TEST_SIZE; i++)
 		((u8 *) src)[i] = (u8)i;
 
-	memset(dest, 0, IOP_ADMA_TEST_SIZE);
-
 	/* Start copy, using first DMA channel */
 	dma_chan = container_of(device->common.channels.next,
 				struct dma_chan,

commit 76b0c788e6033c514f2a75171b04c73c68d28e8d
Author: Zhang Wei <zw@zh-kernel.org>
Date:   Tue May 13 14:44:59 2008 -0700

    fsldma: update the fsldma driver MAINTAINERS info
    
    Add Li Yang as the new maintainer for fsldma driver and update
    my email address.
    
    Acked-by: Li Yang <leoli@freescale.com>
    Signed-off-by: Zhang Wei <zw@zh-kernel.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index dc94fc5..7fd9c43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1646,8 +1646,10 @@ W:	http://linux-fbdev.sourceforge.net/
 S:	Maintained
 
 FREESCALE DMA DRIVER
-P;	Zhang Wei
-M:	wei.zhang@freescale.com
+P:	Li Yang
+M:	leoli@freescale.com
+P:	Zhang Wei
+M:	zw@zh-kernel.org
 L:	linuxppc-embedded@ozlabs.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained


