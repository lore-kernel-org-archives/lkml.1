Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYLZH3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYLZH3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYLZH3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:29:03 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:33480 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbYLZH3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:29:00 -0500
Date: Fri, 26 Dec 2008 08:28:58 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 6/7] drivers/staging/comedi: Move a dereference below a NULL
 test
Message-ID: <Pine.LNX.4.64.0812260828350.25450@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/).

// <smpl>
@disable is_null@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (E == NULL) S
  f(...,E->fld,...);
- if (E == NULL) S

@@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (!E) S
  f(...,E->fld,...);
- if (!E) S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/comedi/drivers/usbduxfast.c    |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 3a00ff0..5c8db77 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1671,15 +1671,15 @@ static int usbduxfast_detach(comedi_device * dev)
 {
 	usbduxfastsub_t *usbduxfastsub_tmp;
 
-#ifdef CONFIG_COMEDI_DEBUG
-	printk("comedi%d: usbduxfast: detach usb device\n", dev->minor);
-#endif
-
 	if (!dev) {
 		printk("comedi?: usbduxfast: detach without dev variable...\n");
 		return -EFAULT;
 	}
 
+#ifdef CONFIG_COMEDI_DEBUG
+	printk("comedi%d: usbduxfast: detach usb device\n", dev->minor);
+#endif
+
 	usbduxfastsub_tmp = dev->private;
 	if (!usbduxfastsub_tmp) {
 		printk("comedi?: usbduxfast: detach without ptr to usbduxfastsub[]\n");
