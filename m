Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbXKIXgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbXKIXgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbXKIXgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:36:10 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57127 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbXKIXgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:36:08 -0500
Message-id: <2360191482474314192.slaby@pripojeni.net>
In-reply-to: <133622706419279219.slaby@pripojeni.net>
Subject: [PATCH 3/7] Char: rocket, remove useless macros
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Fri, 9 Nov 2007 18:36:08 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rocket, remove useless macros

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 585adae2019a87909ec738cbd414a330afbe04a8
tree cb170c8236ae0e49b81b50c305fa221aeb4315c2
parent c0e0b8a247ca469f85e51867fb11b5dbc19dace7
author Jiri Slaby <jirislaby@gmail.com> Sat, 20 Oct 2007 22:18:40 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:26:05 +0100

 drivers/char/rocket.c     |   11 ++---------
 drivers/char/rocket_int.h |   18 ------------------
 2 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index ffb34c4..68c289f 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -40,12 +40,6 @@
  */
 
 /****** Defines ******/
-#ifdef PCI_NUM_RESOURCES
-#define PCI_BASE_ADDRESS(dev, r) ((dev)->resource[r].start)
-#else
-#define PCI_BASE_ADDRESS(dev, r) ((dev)->base_address[r])
-#endif
-
 #define ROCKET_PARANOIA_CHECK
 #define ROCKET_DISABLE_SIMUSAGE
 
@@ -981,7 +975,7 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
 	CHANNEL_t *cp;
 	unsigned long page;
 
-	line = TTY_GET_LINE(tty);
+	line = tty->index;
 	if ((line < 0) || (line >= MAX_RP_PORTS) || ((info = rp_table[line]) == NULL))
 		return -ENXIO;
 
@@ -1166,8 +1160,7 @@ static void rp_close(struct tty_struct *tty, struct file *filp)
 	if (C_HUPCL(tty))
 		sClrDTR(cp);
 
-	if (TTY_DRIVER_FLUSH_BUFFER_EXISTS(tty))
-		TTY_DRIVER_FLUSH_BUFFER(tty);
+	rp_flush_buffer(tty);
 		
 	tty_ldisc_flush(tty);
 
diff --git a/drivers/char/rocket_int.h b/drivers/char/rocket_int.h
index c3aab52..f3a7579 100644
--- a/drivers/char/rocket_int.h
+++ b/drivers/char/rocket_int.h
@@ -105,12 +105,6 @@ static inline unsigned short sInW(unsigned short port)
 #define AIOPID_NULL -1		/* no AIOP or channel exists */
 #define AIOPID_0001 0x0001	/* AIOP release 1 */
 
-#define NULLDEV -1		/* identifies non-existant device */
-#define NULLCTL -1		/* identifies non-existant controller */
-#define NULLCTLPTR (CONTROLLER_T *)0	/* identifies non-existant controller */
-#define NULLAIOP -1		/* identifies non-existant AIOP */
-#define NULLCHAN -1		/* identifies non-existant channel */
-
 /************************************************************************
  Global Register Offsets - Direct Access - Fixed values
 ************************************************************************/
@@ -1187,9 +1181,6 @@ struct r_port {
 #define ROCKET_CLOSING		0x40000000	/* Serial port is closing */
 #define ROCKET_NORMAL_ACTIVE	0x20000000	/* Normal port is active */
 
-/* tty subtypes */
-#define SERIAL_TYPE_NORMAL 1
-
 /*
  * Assigned major numbers for the Comtrol Rocketport
  */
@@ -1240,12 +1231,3 @@ struct r_port {
 /* Compact PCI device */ 
 #define PCI_DEVICE_ID_CRP16INTF		0x0903	/* Rocketport Compact PCI 16 port w/external I/F */
 
-#define TTY_GET_LINE(t) t->index
-#define TTY_DRIVER_MINOR_START(t) t->driver->minor_start
-#define TTY_DRIVER_SUBTYPE(t) t->driver->subtype
-#define TTY_DRIVER_NAME(t) t->driver->name
-#define TTY_DRIVER_NAME_BASE(t) t->driver->name_base
-#define TTY_DRIVER_FLUSH_BUFFER_EXISTS(t) t->driver->flush_buffer
-#define TTY_DRIVER_FLUSH_BUFFER(t) t->driver->flush_buffer(t)
-
-
