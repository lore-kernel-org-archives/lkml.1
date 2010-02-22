Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab0BVKP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:15:56 -0500
Received: from mail-ew0-f226.google.com ([209.85.219.226]:65452 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab0BVKPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:15:55 -0500
Date: Mon, 22 Feb 2010 14:15:50 +0400
From: Constantin Baranov <const@mimas.ru>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] virtio_console: register hvc0 as console
Message-Id: <20100222141550.67fa46f7.const@mimas.ru>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call hvc_instantiate() when probing virtio device.
A console should be registered much earlier but we
cannot ensure hvc0 existence until PCI and virtio
subsystems initialized. After all, console=hvc0 may
be useful even with this limitation.

Signed-off-by: Constantin Baranov <const@mimas.ru>
---
 drivers/char/virtio_console.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index a035ae3..cf9cb80 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -219,6 +219,9 @@ static int __devinit virtcons_probe(struct virtio_device *dev)
 	virtio_cons.notifier_del = notifier_del_vio;
 	virtio_cons.notifier_hangup = notifier_del_vio;
 
+	/* Attempt to register hvc0 console. Better late then never. */
+	hvc_instantiate(0, 0, &virtio_cons);
+
 	/* The first argument of hvc_alloc() is the virtual console number, so
 	 * we use zero.  The second argument is the parameter for the
 	 * notification mechanism (like irq number). We currently leave this
-- 
1.7.0

