Return-Path: <linux-kernel-owner+w=401wt.eu-S933488AbYEAWwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbYEAWwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933211AbYEAWwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:52:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56395 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762343AbYEAWwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:52:06 -0400
Date: Thu, 1 May 2008 18:52:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: akpm@osdl.org, Alain Degreffe <eczema@ecze.com>
Subject: [PATCH] fix irq flags for iuu_phoenix.c
Message-ID: <Pine.LNX.4.58.0805011851230.12785@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The file drivers/usb/serial/iuu_phoenix.c uses "int" for flags. This can
cause hard to find bugs on some architectures. This patch converts the
flags to use "long" instead.

This bug was discovered by doing an allyesconfig make on the -rt kernel
where checks are done to ensure all flags are of size sizeof(long).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 drivers/usb/serial/iuu_phoenix.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-compile.git/drivers/usb/serial/iuu_phoenix.c
===================================================================
--- linux-compile.git.orig/drivers/usb/serial/iuu_phoenix.c	2008-05-01 16:58:50.000000000 -0400
+++ linux-compile.git/drivers/usb/serial/iuu_phoenix.c	2008-05-01 18:45:03.000000000 -0400
@@ -643,7 +643,7 @@ static void read_buf_callback(struct urb
 static int iuu_bulk_write(struct usb_serial_port *port)
 {
 	struct iuu_private *priv = usb_get_serial_port_data(port);
-	unsigned int flags;
+	unsigned long flags;
 	int result;
 	int i;
 	char *buf_ptr = port->write_urb->transfer_buffer;
@@ -694,7 +694,7 @@ static void iuu_uart_read_callback(struc
 {
 	struct usb_serial_port *port = urb->context;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
-	unsigned int flags;
+	unsigned long flags;
 	int status;
 	int error = 0;
 	int len = 0;
@@ -759,7 +759,7 @@ static int iuu_uart_write(struct usb_ser
 			  int count)
 {
 	struct iuu_private *priv = usb_get_serial_port_data(port);
-	unsigned int flags;
+	unsigned long flags;
 	dbg("%s - enter", __func__);

 	if (count > 256)

