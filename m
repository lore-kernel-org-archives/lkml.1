Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYJ0Tx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYJ0Tx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYJ0TxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:53:20 -0400
Received: from kroah.org ([198.145.64.141]:39834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752101AbYJ0TxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:53:19 -0400
Subject: patch uio-use-pci_ioremap_bar-in-drivers-uio.patch added to gregkh-2.6 tree
To: arjan@linux.intel.com, arjan@infradead.org, gregkh@suse.de,
       hjk@linutronix.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Mon, 27 Oct 2008 12:44:59 -0700
In-Reply-To: <20081021091750.GA2966@local>
Message-ID: <12251366992113@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: UIO: use pci_ioremap_bar() in drivers/uio

to my gregkh-2.6 tree.  Its filename is

    uio-use-pci_ioremap_bar-in-drivers-uio.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From hjk@linutronix.de  Mon Oct 27 11:23:22 2008
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 21 Oct 2008 11:17:51 +0200
Subject: UIO: use pci_ioremap_bar() in drivers/uio
To: Arjan van de Ven <arjan@infradead.org>
Cc: hjk@linutronix.de, tglx@tglx.de, Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20081021091750.GA2966@local>
Content-Disposition: inline

From: Arjan van de Ven <arjan@linux.intel.com>

Use the newly introduced pci_ioremap_bar() function in drivers/uio.
pci_ioremap_bar() just takes a pci device and a bar number, with the goal
of making it really hard to get wrong, while also having a central place
to stick sanity checks.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/uio/uio_cif.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/uio/uio_cif.c
+++ b/drivers/uio/uio_cif.c
@@ -57,8 +57,7 @@ static int __devinit hilscher_pci_probe(
 	info->mem[0].addr = pci_resource_start(dev, 0);
 	if (!info->mem[0].addr)
 		goto out_release;
-	info->mem[0].internal_addr = ioremap(pci_resource_start(dev, 0),
-					     pci_resource_len(dev, 0));
+	info->mem[0].internal_addr = pci_ioremap_bar(dev, 0);
 	if (!info->mem[0].internal_addr)
 		goto out_release;
 


Patches currently in gregkh-2.6 which might be from arjan@linux.intel.com are

usb/usb-use-pci_ioremap_bar-in-drivers-usb.patch
driver-core/uio-use-pci_ioremap_bar-in-drivers-uio.patch
