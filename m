Return-Path: <linux-kernel-owner+w=401wt.eu-S932835AbXJMTFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbXJMTFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 15:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762527AbXJMTE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 15:04:58 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39941 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762449AbXJMTE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 15:04:57 -0400
Date: Sat, 13 Oct 2007 15:04:57 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/char/ip2: fix used-uninit'd bug
Message-ID: <20071013190457.GA20095@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix bug flagged by a variable-used-uninitialized warning.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/char/ip2/ip2main.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index bd94d5f..2a566a0 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -619,11 +619,7 @@ ip2_loadmain(int *iop, int *irqp, unsigned char *firmware, int firmsize)
 					ip2config.irq[i] = pci_dev_i->irq;
 				} else {	// ann error
 					ip2config.addr[i] = 0;
-					if (status == PCIBIOS_DEVICE_NOT_FOUND) {
-						printk( KERN_ERR "IP2: PCI board %d not found\n", i );
-					} else {
-						printk( KERN_ERR "IP2: PCI error 0x%x \n", status );
-					}
+					printk( KERN_ERR "IP2: PCI board %d not found\n", i );
 				} 
 			}
 #else
