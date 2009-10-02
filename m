Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZJBByt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZJBByt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbZJBByr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:54:47 -0400
Received: from kroah.org ([198.145.64.141]:33090 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679AbZJBBdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:03 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:12 2009
Message-Id: <20091002012412.661291010@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oliver@neukum.org>,
       Marcel Holtmann <marcel@holtmann.org>, Paul Martin <pm@debian.org>
Subject: [044/136] USB: fix cdc-acm regression in open
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-fix-cdc-acm-regression-in-open.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Oliver Neukum <oliver@neukum.org>

commit 7af25b4b34a2439020d78da765a3bed0ff73f25c upstream.

cdc-acm needs to set a flag during open to tell the
tty layer that the device is initialized

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Paul Martin <pm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -59,6 +59,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/tty.h>
+#include <linux/serial.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
 #include <linux/module.h>
@@ -609,6 +610,7 @@ static int acm_tty_open(struct tty_struc
 	acm->throttle = 0;
 
 	tasklet_schedule(&acm->urb_task);
+	set_bit(ASYNCB_INITIALIZED, &acm->port.flags);
 	rv = tty_port_block_til_ready(&acm->port, tty, filp);
 done:
 	mutex_unlock(&acm->mutex);


