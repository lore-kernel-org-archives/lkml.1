Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYBJUP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYBJUP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYBJUPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:15:17 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:54335 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbYBJUPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:15:15 -0500
Date: Sun, 10 Feb 2008 21:15:09 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/8] drivers/usb: Use FIELD_SIZEOF
Message-ID: <Pine.LNX.4.64.0802102114330.23906@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Robert P.J. Day proposed to use the macro FIELD_SIZEOF in replace of code
that matches its definition.

The modification was made using the following semantic patch
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
type t;
identifier f;
@@

- (sizeof(((t*)0)->f))
+ FIELD_SIZEOF(t, f)

@depends on haskernel@
type t;
identifier f;
@@

- sizeof(((t*)0)->f)
+ FIELD_SIZEOF(t, f)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c 2007-09-20 18:59:00.000000000 +0200
+++ b/drivers/usb/atm/usbatm.c 2008-02-10 18:13:48.000000000 +0100
@@ -1349,7 +1349,7 @@ static int __init usbatm_usb_init(void)
 {
 	dbg("%s: driver version %s", __func__, DRIVER_VERSION);
 
-	if (sizeof(struct usbatm_control) > sizeof(((struct sk_buff *) 0)->cb)) {
+	if (sizeof(struct usbatm_control) > FIELD_SIZEOF(struct sk_buff, cb)) {
 		printk(KERN_ERR "%s unusable with this kernel!\n", usbatm_driver_name);
 		return -EIO;
 	}
diff -u -p a/drivers/usb/serial/io_usbvend.h b/drivers/usb/serial/io_usbvend.h
--- a/drivers/usb/serial/io_usbvend.h 2007-07-20 15:28:33.000000000 +0200
+++ b/drivers/usb/serial/io_usbvend.h 2008-02-10 18:15:37.000000000 +0100
@@ -514,10 +514,10 @@ struct edge_manuf_descriptor {
 
 #define MANUF_BOARD_REV_A		1	// First rev of 251+Netchip design
 
-#define	MANUF_SERNUM_LENGTH		sizeof(((struct edge_manuf_descriptor *)0)->SerialNumber)
-#define	MANUF_ASSYNUM_LENGTH		sizeof(((struct edge_manuf_descriptor *)0)->AssemblyNumber)
-#define	MANUF_OEMASSYNUM_LENGTH		sizeof(((struct edge_manuf_descriptor *)0)->OemAssyNumber)
-#define	MANUF_MANUFDATE_LENGTH		sizeof(((struct edge_manuf_descriptor *)0)->ManufDate)
+#define	MANUF_SERNUM_LENGTH		FIELD_SIZEOF(struct edge_manuf_descriptor, SerialNumber)
+#define	MANUF_ASSYNUM_LENGTH		FIELD_SIZEOF(struct edge_manuf_descriptor, AssemblyNumber)
+#define	MANUF_OEMASSYNUM_LENGTH		FIELD_SIZEOF(struct edge_manuf_descriptor, OemAssyNumber)
+#define	MANUF_MANUFDATE_LENGTH		FIELD_SIZEOF(struct edge_manuf_descriptor, ManufDate)
 
 #define	MANUF_ION_CONFIG_DIAG_NO_LOOP	0x20	// As below but no ext loopback test
 #define	MANUF_ION_CONFIG_DIAG		0x40	// 930 based device: 1=Run h/w diags, 0=norm
