Return-Path: <linux-kernel-owner+w=401wt.eu-S1761889AbYEWCsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761889AbYEWCsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 22:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbYEWCsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 22:48:07 -0400
Received: from ozlabs.org ([203.10.76.45]:59344 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757527AbYEWCsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 22:48:04 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 22 May 2008 21:47:50 -0500
Subject: [PATCH 1/3] virtio: bus_id for devices should contain 'virtio'
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
Message-Id: <200805231247.50751.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Lalancette <clalance@redhat.com> points out that virtio.c sets all device
names to '0', '1', etc, which looks silly in /proc/interrupts.  We change this
from '%d' to 'virtio%d'.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chris Lalancette <clalance@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>
---
 drivers/virtio/virtio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -r 2f0d0ce2adbf drivers/virtio/virtio.c
--- a/drivers/virtio/virtio.c	Fri May 23 11:55:02 2008 +1000
+++ b/drivers/virtio/virtio.c	Fri May 23 12:23:39 2008 +1000
@@ -166,7 +169,7 @@ int register_virtio_device(struct virtio
 	int err;
 
 	dev->dev.bus = &virtio_bus;
-	sprintf(dev->dev.bus_id, "%u", dev->index);
+	sprintf(dev->dev.bus_id, "virtio%u", dev->index);
 
 	/* We always start by resetting the device, in case a previous
 	 * driver messed it up.  This also tests that code path a little. */

