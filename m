Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbXJ2SWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbXJ2SWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbXJ2SWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:22:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26958 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759958AbXJ2SWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:22:10 -0400
Date: Mon, 29 Oct 2007 11:20:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rusty@rustcorp.com.au
Subject: [PATCH] virtio/virtcons: fix section mismatch warning
Message-Id: <20071029112016.8df6c518.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make virtcons_probe() __devinit.
Fixes this section warning:

WARNING: vmlinux.o(.text+0x14c10b): Section mismatch: reference to .init.text:hvc_alloc (between 'virtcons_probe' and 'ac_register_board')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/char/virtio_console.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2624-rc1g4-v1.orig/drivers/char/virtio_console.c
+++ linux-2624-rc1g4-v1/drivers/char/virtio_console.c
@@ -141,7 +141,7 @@ int __init virtio_cons_early_init(int (*
  * never remove the console device we never need this pointer again.
  *
  * Finally we put our input buffer in the input queue, ready to receive. */
-static int virtcons_probe(struct virtio_device *dev)
+static int __devinit virtcons_probe(struct virtio_device *dev)
 {
 	int err;
 	struct hvc_struct *hvc;
