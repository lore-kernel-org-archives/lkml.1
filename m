Return-Path: <linux-kernel-owner+w=401wt.eu-S1762817AbZGAAmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817AbZGAAmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760943AbZGAAcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:32:51 -0400
Received: from kroah.org ([198.145.64.141]:59808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760948AbZGAAcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:32:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:51 2009
Message-Id: <20090701001551.101806792@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Scott James Remnant <scott@canonical.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Philippe De Muyter <phdm@macqel.be>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [patch 17/35] floppy: provide a PNP device table in the module.
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=floppy-provide-a-pnp-device-table-in-the-module.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Scott James Remnant <scott@canonical.com>

commit 83f9ef463bcb4ba7b4fee1d6212fac7d277010d3 upstream.

The missing device table means that the floppy module is not auto-loaded,
even when the appropriate PNP device (0700) is found.

We don't actually use the table in the module, since the device doesn't
have a struct pnp_driver, but it's sufficient to cause an alias in the
module that udev/modprobe will use.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Philippe De Muyter <phdm@macqel.be>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/floppy.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -177,6 +177,7 @@ static int print_unex = 1;
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/mod_devicetable.h>
 #include <linux/buffer_head.h>	/* for invalidate_buffers() */
 #include <linux/mutex.h>
 
@@ -4598,6 +4599,13 @@ MODULE_AUTHOR("Alain L. Knaff");
 MODULE_SUPPORTED_DEVICE("fd");
 MODULE_LICENSE("GPL");
 
+/* This doesn't actually get used other than for module information */
+static const struct pnp_device_id floppy_pnpids[] = {
+	{ "PNP0700", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(pnp, floppy_pnpids);
+
 #else
 
 __setup("floppy=", floppy_setup);


