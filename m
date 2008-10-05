Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbYJEQb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbYJEQb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbYJEQX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:23:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34327 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759122AbYJEQX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:23:28 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 67/76] tty: Remove lots of NULL checks
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:23:28 +0100
Message-ID: <20081005162321.1997.71337.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many tty drivers contain 'can't happen' checks against NULL pointers passed
in by the tty layer. These have never been possible to occur. Even more
importantly if they ever do occur we want to know as it would be a serious
bug.
---

 drivers/char/amiserial.c      |    6 ------
 drivers/char/generic_serial.c |   21 ---------------------
 drivers/char/istallion.c      |    6 ------
 drivers/char/mxser.c          |    5 -----
 drivers/char/n_r3964.c        |    9 +--------
 drivers/char/stallion.c       |   34 ----------------------------------
 6 files changed, 1 insertions(+), 80 deletions(-)

diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 6e763e3..98821f9 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -837,9 +837,6 @@ static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 	struct async_struct *info;
 	unsigned long flags;
 
-	if (!tty)
-		return 0;
-
 	info = tty->driver_data;
 
 	if (serial_paranoia_check(info, tty->name, "rs_put_char"))
@@ -892,9 +889,6 @@ static int rs_write(struct tty_struct * tty, const unsigned char *buf, int count
 	struct async_struct *info;
 	unsigned long flags;
 
-	if (!tty)
-		return 0;
-
 	info = tty->driver_data;
 
 	if (serial_paranoia_check(info, tty->name, "rs_write"))
diff --git a/drivers/char/generic_serial.c b/drivers/char/generic_serial.c
index 19d3afb..c6090f8 100644
--- a/drivers/char/generic_serial.c
+++ b/drivers/char/generic_serial.c
@@ -54,8 +54,6 @@ int gs_put_char(struct tty_struct * tty, unsigned char ch)
 
 	func_enter (); 
 
-	if (!tty) return 0;
-
 	port = tty->driver_data;
 
 	if (!port) return 0;
@@ -97,8 +95,6 @@ int gs_write(struct tty_struct * tty,
 
 	func_enter ();
 
-	if (!tty) return 0;
-
 	port = tty->driver_data;
 
 	if (!port) return 0;
@@ -185,7 +181,6 @@ static int gs_real_chars_in_buffer(struct tty_struct *tty)
 	struct gs_port *port;
 	func_enter ();
 
-	if (!tty) return 0;
 	port = tty->driver_data;
 
 	if (!port->rd) return 0;
@@ -274,8 +269,6 @@ void gs_flush_buffer(struct tty_struct *tty)
 
 	func_enter ();
 
-	if (!tty) return;
-
 	port = tty->driver_data;
 
 	if (!port) return;
@@ -296,8 +289,6 @@ void gs_flush_chars(struct tty_struct * tty)
 
 	func_enter ();
 
-	if (!tty) return;
-
 	port = tty->driver_data;
 
 	if (!port) return;
@@ -321,8 +312,6 @@ void gs_stop(struct tty_struct * tty)
 
 	func_enter ();
 
-	if (!tty) return;
-
 	port = tty->driver_data;
 
 	if (!port) return;
@@ -341,8 +330,6 @@ void gs_start(struct tty_struct * tty)
 {
 	struct gs_port *port;
 
-	if (!tty) return;
-
 	port = tty->driver_data;
 
 	if (!port) return;
@@ -393,8 +380,6 @@ void gs_hangup(struct tty_struct *tty)
 
 	func_enter ();
 
-	if (!tty) return;
-
 	port = tty->driver_data;
 	tty = port->port.tty;
 	if (!tty) 
@@ -426,8 +411,6 @@ int gs_block_til_ready(void *port_, struct file * filp)
 
 	tty = port->port.tty;
 
-	if (!tty) return 0;
-
 	gs_dprintk (GS_DEBUG_BTR, "Entering gs_block_till_ready.\n"); 
 	/*
 	 * If the device is in the middle of being closed, then block
@@ -523,8 +506,6 @@ void gs_close(struct tty_struct * tty, struct file * filp)
 	
 	func_enter ();
 
-	if (!tty) return;
-
 	port = (struct gs_port *) tty->driver_data;
 
 	if (!port) return;
@@ -621,8 +602,6 @@ void gs_set_termios (struct tty_struct * tty,
 
 	func_enter();
 
-	if (!tty) return;
-
 	port = tty->driver_data;
 
 	if (!port) return;
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 96ee112..505d7a1 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -1375,8 +1375,6 @@ static void stli_flushchars(struct tty_struct *tty)
 	stli_txcookrealsize = 0;
 	stli_txcooktty = NULL;
 
-	if (tty == NULL)
-		return;
 	if (cooktty == NULL)
 		return;
 	if (tty != cooktty)
@@ -1732,8 +1730,6 @@ static void stli_settermios(struct tty_struct *tty, struct ktermios *old)
 	struct ktermios *tiosp;
 	asyport_t aport;
 
-	if (tty == NULL)
-		return;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return;
@@ -1938,8 +1934,6 @@ static void stli_waituntilsent(struct tty_struct *tty, int timeout)
 	struct stliport *portp;
 	unsigned long tend;
 
-	if (tty == NULL)
-		return;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return;
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 308cb60..8beef50 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -616,9 +616,6 @@ static int mxser_set_baud(struct tty_struct *tty, long newspd)
 	int quot = 0, baud;
 	unsigned char cval;
 
-	if (!tty->termios)
-		return -1;
-
 	if (!info->ioaddr)
 		return -1;
 
@@ -688,8 +685,6 @@ static int mxser_change_speed(struct tty_struct *tty,
 	int ret = 0;
 	unsigned char status;
 
-	if (!tty->termios)
-		return ret;
 	cflag = tty->termios->c_cflag;
 	if (!info->ioaddr)
 		return ret;
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index ae377aa..c0a1df9 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -372,15 +372,8 @@ static void remove_from_rx_queue(struct r3964_info *pInfo,
 static void put_char(struct r3964_info *pInfo, unsigned char ch)
 {
 	struct tty_struct *tty = pInfo->tty;
-
-	if (tty == NULL)
-		return;
-
 	/* FIXME: put_char should not be called from an IRQ */
-	if (tty->ops->put_char) {
-		tty->ops->put_char(tty, ch);
-	}
-	pInfo->bcc ^= ch;
+	tty_put_char(tty, ch);
 }
 
 static void flush(struct r3964_info *pInfo)
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 81b3234..8b8f07a 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -849,8 +849,6 @@ static void stl_flushbuffer(struct tty_struct *tty)
 
 	pr_debug("stl_flushbuffer(tty=%p)\n", tty);
 
-	if (tty == NULL)
-		return;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return;
@@ -868,8 +866,6 @@ static void stl_waituntilsent(struct tty_struct *tty, int timeout)
 
 	pr_debug("stl_waituntilsent(tty=%p,timeout=%d)\n", tty, timeout);
 
-	if (tty == NULL)
-		return;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return;
@@ -1036,8 +1032,6 @@ static int stl_putchar(struct tty_struct *tty, unsigned char ch)
 
 	pr_debug("stl_putchar(tty=%p,ch=%x)\n", tty, ch);
 
-	if (tty == NULL)
-		return -EINVAL;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return -EINVAL;
@@ -1073,8 +1067,6 @@ static void stl_flushchars(struct tty_struct *tty)
 
 	pr_debug("stl_flushchars(tty=%p)\n", tty);
 
-	if (tty == NULL)
-		return;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return;
@@ -1093,8 +1085,6 @@ static int stl_writeroom(struct tty_struct *tty)
 
 	pr_debug("stl_writeroom(tty=%p)\n", tty);
 
-	if (tty == NULL)
-		return 0;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return 0;
@@ -1125,8 +1115,6 @@ static int stl_charsinbuffer(struct tty_struct *tty)
 
 	pr_debug("stl_charsinbuffer(tty=%p)\n", tty);
 
-	if (tty == NULL)
-		return 0;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return 0;
@@ -1219,8 +1207,6 @@ static int stl_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct stlport	*portp;
 
-	if (tty == NULL)
-		return -ENODEV;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return -ENODEV;
@@ -1236,8 +1222,6 @@ static int stl_tiocmset(struct tty_struct *tty, struct file *file,
 	struct stlport	*portp;
 	int rts = -1, dtr = -1;
 
-	if (tty == NULL)
-		return -ENODEV;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return -ENODEV;
@@ -1266,8 +1250,6 @@ static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd
 	pr_debug("stl_ioctl(tty=%p,file=%p,cmd=%x,arg=%lx)\n", tty, file, cmd,
 			arg);
 
-	if (tty == NULL)
-		return -ENODEV;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return -ENODEV;
@@ -1321,8 +1303,6 @@ static void stl_start(struct tty_struct *tty)
 
 	pr_debug("stl_start(tty=%p)\n", tty);
 
-	if (tty == NULL)
-		return;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return;
@@ -1338,8 +1318,6 @@ static void stl_settermios(struct tty_struct *tty, struct ktermios *old)
 
 	pr_debug("stl_settermios(tty=%p,old=%p)\n", tty, old);
 
-	if (tty == NULL)
-		return;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return;
@@ -1373,8 +1351,6 @@ static void stl_throttle(struct tty_struct *tty)
 
 	pr_debug("stl_throttle(tty=%p)\n", tty);
 
-	if (tty == NULL)
-		return;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return;
@@ -1393,8 +1369,6 @@ static void stl_unthrottle(struct tty_struct *tty)
 
 	pr_debug("stl_unthrottle(tty=%p)\n", tty);
 
-	if (tty == NULL)
-		return;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return;
@@ -1414,8 +1388,6 @@ static void stl_stop(struct tty_struct *tty)
 
 	pr_debug("stl_stop(tty=%p)\n", tty);
 
-	if (tty == NULL)
-		return;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return;
@@ -1436,8 +1408,6 @@ static void stl_hangup(struct tty_struct *tty)
 
 	pr_debug("stl_hangup(tty=%p)\n", tty);
 
-	if (tty == NULL)
-		return;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return;
@@ -1470,8 +1440,6 @@ static int stl_breakctl(struct tty_struct *tty, int state)
 
 	pr_debug("stl_breakctl(tty=%p,state=%d)\n", tty, state);
 
-	if (tty == NULL)
-		return -EINVAL;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return -EINVAL;
@@ -1488,8 +1456,6 @@ static void stl_sendxchar(struct tty_struct *tty, char ch)
 
 	pr_debug("stl_sendxchar(tty=%p,ch=%x)\n", tty, ch);
 
-	if (tty == NULL)
-		return;
 	portp = tty->driver_data;
 	if (portp == NULL)
 		return;

