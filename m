Return-Path: <linux-kernel-owner+w=401wt.eu-S933924AbXGLX1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbXGLX1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbXGLX1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:27:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:48718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757441AbXGLX1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:27:38 -0400
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 13 Jul 2007 09:27:47 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18070.47347.482656.200247@notabene.brown>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] BLOCK:  Remove references to dead CONFIG_MM_MAP_MEMORY
	variable.
In-Reply-To: message from Jens Axboe on Thursday July 12
References: <Pine.LNX.4.64.0707120401140.24359@localhost.localdomain>
	<20070712113402.GS4587@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday July 12, jens.axboe@oracle.com wrote:
> On Thu, Jul 12 2007, Robert P. J. Day wrote:
> > 
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> Looks fine to me, I remember this being brought up a long time ago, but
> apparently it never got merged. Neil?

Yes,
  Acked-by: NeilBrown <neilb@suse.de>

It is at best a half-hearted attempt at implementing memory mapping of
the device.
Will pass it on upstream?

While your at it, I'm sure I've sent this patch to Andrew twice, and
it seems to have been silently ignored... Maybe you will have better
luck (if it looks OK to you)??

Thanks,
NeilBrown


---------------------------------
Fix match of pci_ids in umem driver.

the pci device list for umem was not using PCI_DEVICE, so the
subvendor/subdevice fields were not set to ANY, so matching
didn't work properly.

Change to use PCI_DEVICE.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/block/umem.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff .prev/drivers/block/umem.c ./drivers/block/umem.c
--- .prev/drivers/block/umem.c	2007-03-28 11:59:36.000000000 +1000
+++ ./drivers/block/umem.c	2007-03-23 11:15:24.000000000 +1100
@@ -1134,23 +1134,18 @@ static void mm_pci_remove(struct pci_dev
 	blk_cleanup_queue(card->queue);
 }
 
-static const struct pci_device_id mm_pci_ids[] = { {
-	.vendor =	PCI_VENDOR_ID_MICRO_MEMORY,
-	.device =	PCI_DEVICE_ID_MICRO_MEMORY_5415CN,
-	}, {
-	.vendor =	PCI_VENDOR_ID_MICRO_MEMORY,
-	.device =	PCI_DEVICE_ID_MICRO_MEMORY_5425CN,
-	}, {
-	.vendor =	PCI_VENDOR_ID_MICRO_MEMORY,
-	.device =	PCI_DEVICE_ID_MICRO_MEMORY_6155,
-	}, {
+static const struct pci_device_id mm_pci_ids[] = {
+    {PCI_DEVICE(PCI_VENDOR_ID_MICRO_MEMORY,PCI_DEVICE_ID_MICRO_MEMORY_5415CN)},
+    {PCI_DEVICE(PCI_VENDOR_ID_MICRO_MEMORY,PCI_DEVICE_ID_MICRO_MEMORY_5425CN)},
+    {PCI_DEVICE(PCI_VENDOR_ID_MICRO_MEMORY,PCI_DEVICE_ID_MICRO_MEMORY_6155)},
+    {
 	.vendor	=	0x8086,
 	.device	=	0xB555,
 	.subvendor=	0x1332,
 	.subdevice=	0x5460,
 	.class	=	0x050000,
 	.class_mask=	0,
-	}, { /* end: all zeroes */ }
+    }, { /* end: all zeroes */ }
 };
 
 MODULE_DEVICE_TABLE(pci, mm_pci_ids);
