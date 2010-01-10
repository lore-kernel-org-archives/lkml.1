Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025Ab0AJOfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0AJOfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738Ab0AJOfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:35:34 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:57117 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab0AJOfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:35:31 -0500
X-Authuid: nmarci
Message-ID: <4B49E5AB.5080309@freemail.hu>
Date: Sun, 10 Jan 2010 15:35:23 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH 9/9] USB goku_udc: make PCI device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32721; Body=5 Fuz1=5
	Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct pci_driver is constant in <linux/pci.h>
so it is worth to make pci_ids also constant.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
disable decl_init,const_decl_init;
identifier I1, I2, x;
@@
	struct I1 {
	  ...
	  const struct I2 *x;
	  ...
	};
@s@
identifier r.I1, y;
identifier r.x, E;
@@
	struct I1 y = {
	  .x = E,
	};
@c@
identifier r.I2;
identifier s.E;
@@
	const struct I2 E[] = ... ;
@depends on !c@
identifier r.I2;
identifier s.E;
@@
+	const
	struct I2 E[] = ...;
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
---
diff -u -p a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
--- a/drivers/usb/gadget/goku_udc.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/usb/gadget/goku_udc.c 2010-01-08 17:07:05.000000000 +0100
@@ -1859,7 +1859,7 @@ done:

 /*-------------------------------------------------------------------------*/

-static struct pci_device_id pci_ids [] = { {
+static const struct pci_device_id pci_ids[] = { {
 	.class =	((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
 	.class_mask =	~0,
 	.vendor =	0x102f,		/* Toshiba */
