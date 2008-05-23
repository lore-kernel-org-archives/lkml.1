Return-Path: <linux-kernel-owner+w=401wt.eu-S1763761AbYEWCsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763761AbYEWCsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 22:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762852AbYEWCsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 22:48:31 -0400
Received: from ozlabs.org ([203.10.76.45]:59360 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762543AbYEWCsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 22:48:24 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 22 May 2008 21:48:10 -0500
Subject: [PATCH 2/3] virtio: virtio_pci should not set bus_id.
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       virtualization@lists.linux-foundation.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chris Lalancette <clalance@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805231248.11321.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common virtio code sets the bus_id, overriding anything virtio_pci
sets anyway.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chris Lalancette <clalance@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>
---
 drivers/virtio/virtio_pci.c |    1 -
 1 file changed, 1 deletion(-)

diff -r 2f0d0ce2adbf drivers/virtio/virtio_pci.c
--- a/drivers/virtio/virtio_pci.c	Fri May 23 11:55:02 2008 +1000
+++ b/drivers/virtio/virtio_pci.c	Fri May 23 12:23:39 2008 +1000
@@ -325,7 +322,6 @@ static int __devinit virtio_pci_probe(st
 	if (vp_dev == NULL)
 		return -ENOMEM;
 
-	snprintf(vp_dev->vdev.dev.bus_id, BUS_ID_SIZE, "virtio%d", dev_index);
 	vp_dev->vdev.index = dev_index;
 	dev_index++;
 

