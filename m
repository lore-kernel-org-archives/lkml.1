Return-Path: <linux-kernel-owner+w=401wt.eu-S1765823AbYFTUiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765823AbYFTUiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762399AbYFTUXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:23:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58339 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753734AbYFTUXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:23:13 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 57/70] tty-usb-mct-u232: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:05:48 +0100
Message-ID: <20080620200544.1479.52038.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/mct_u232.c |  273 +++++++++++++++++++++--------------------
 1 files changed, 141 insertions(+), 132 deletions(-)


diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index 7bce430..7a804d6 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -33,10 +33,11 @@
  *   - Fixed an endianess problem with the baudrate selection for PowerPC.
  *
  * 06-Dec-2001 Martin Hamilton <martinh@gnu.org>
- *	Added support for the Belkin F5U109 DB9 adaptor
+ *   - Added support for the Belkin F5U109 DB9 adaptor
  *
  * 30-May-2001 Greg Kroah-Hartman
- *	switched from using spinlock to a semaphore, which fixes lots of problems.
+ *   - switched from using spinlock to a semaphore, which fixes lots of
+ *     problems.
  *
  * 04-May-2001 Stelian Pop
  *   - Set the maximum bulk output size for Sitecom U232-P25 model to 16 bytes
@@ -49,7 +50,7 @@
  * 08-Apr-2001 gb
  *   - Identify version on module load.
  *
- * 06-Jan-2001 Cornel Ciocirlan 
+ * 06-Jan-2001 Cornel Ciocirlan
  *   - Added support for Sitecom U232-P25 model (Product Id 0x0230)
  *   - Added support for D-Link DU-H3SP USB BAY (Product Id 0x0200)
  *
@@ -59,8 +60,8 @@
  *     (lots of things will change if/when the usb-serial core changes to
  *     handle these issues.
  *
- * 27-Nov-2000 Wolfgang Grandegger
- *   A version for kernel 2.4.0-test10 released to the Linux community 
+ * 27-Nov-2000 Wolfgang Grandegge
+ *   A version for kernel 2.4.0-test10 released to the Linux community
  *   (via linux-usb-devel).
  */
 
@@ -73,7 +74,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include "mct_u232.h"
@@ -90,27 +91,21 @@ static int debug;
 /*
  * Function prototypes
  */
-static int  mct_u232_startup	         (struct usb_serial *serial);
-static void mct_u232_shutdown	         (struct usb_serial *serial);
-static int  mct_u232_open	         (struct tty_struct *tty,
-					  struct usb_serial_port *port,
-					  struct file *filp);
-static void mct_u232_close	         (struct tty_struct *tty,
-					  struct usb_serial_port *port,
-					  struct file *filp);
-static void mct_u232_read_int_callback   (struct urb *urb);
-static void mct_u232_set_termios         (struct tty_struct *tty,
-					  struct usb_serial_port *port,
-					  struct ktermios * old);
-static void mct_u232_break_ctl	         (struct tty_struct *tty,
-					  int break_state );
-static int  mct_u232_tiocmget		 (struct tty_struct *tty,
-					  struct file *file);
-static int  mct_u232_tiocmset		 (struct tty_struct *tty,
-					  struct file *file, unsigned int set,
-					  unsigned int clear);
-static void mct_u232_throttle		 (struct tty_struct *tty);
-static void mct_u232_unthrottle		 (struct tty_struct *tty);
+static int  mct_u232_startup(struct usb_serial *serial);
+static void mct_u232_shutdown(struct usb_serial *serial);
+static int  mct_u232_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static void mct_u232_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static void mct_u232_read_int_callback(struct urb *urb);
+static void mct_u232_set_termios(struct tty_struct *tty,
+			struct usb_serial_port *port, struct ktermios *old);
+static void mct_u232_break_ctl(struct tty_struct *tty, int break_state);
+static int  mct_u232_tiocmget(struct tty_struct *tty, struct file *file);
+static int  mct_u232_tiocmset(struct tty_struct *tty, struct file *file,
+			unsigned int set, unsigned int clear);
+static void mct_u232_throttle(struct tty_struct *tty);
+static void mct_u232_unthrottle(struct tty_struct *tty);
 
 
 /*
@@ -124,7 +119,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ }		/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table_combined);
+MODULE_DEVICE_TABLE(usb, id_table_combined);
 
 static struct usb_driver mct_u232_driver = {
 	.name =		"mct_u232",
@@ -178,23 +173,34 @@ struct mct_u232_private {
  * Later day 2.6.0-test kernels have new baud rates like B230400 which
  * we do not know how to support. We ignore them for the moment.
  */
-static int mct_u232_calculate_baud_rate(struct usb_serial *serial, speed_t value, speed_t *result)
+static int mct_u232_calculate_baud_rate(struct usb_serial *serial,
+					speed_t value, speed_t *result)
 {
 	*result = value;
 
 	if (le16_to_cpu(serial->dev->descriptor.idProduct) == MCT_U232_SITECOM_PID
-	  || le16_to_cpu(serial->dev->descriptor.idProduct) == MCT_U232_BELKIN_F5U109_PID) {
+		|| le16_to_cpu(serial->dev->descriptor.idProduct) == MCT_U232_BELKIN_F5U109_PID) {
 		switch (value) {
-		case    300: return 0x01;
-		case    600: return 0x02; /* this one not tested */
-		case   1200: return 0x03;
-		case   2400: return 0x04;
-		case   4800: return 0x06;
-		case   9600: return 0x08;
-		case  19200: return 0x09;
-		case  38400: return 0x0a;
-		case  57600: return 0x0b;
-		case 115200: return 0x0c;
+		case 300:
+			return 0x01;
+		case 600:
+			return 0x02; /* this one not tested */
+		case 1200:
+			return 0x03;
+		case 2400:
+			return 0x04;
+		case 4800:
+			return 0x06;
+		case 9600:
+			return 0x08;
+		case 19200:
+			return 0x09;
+		case 38400:
+			return 0x0a;
+		case 57600:
+			return 0x0b;
+		case 115200:
+			return 0x0c;
 		default:
 			*result = 9600;
 			return 0x08;
@@ -226,18 +232,19 @@ static int mct_u232_set_baud_rate(struct tty_struct *tty,
 	struct usb_serial *serial, struct usb_serial_port *port, speed_t value)
 {
 	__le32 divisor;
-        int rc;
-        unsigned char zero_byte = 0;
-        unsigned char cts_enable_byte = 0;
-        speed_t speed;
-
-	divisor = cpu_to_le32(mct_u232_calculate_baud_rate(serial, value, &speed));
-
-        rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-                             MCT_U232_SET_BAUD_RATE_REQUEST,
-			     MCT_U232_SET_REQUEST_TYPE,
-                             0, 0, &divisor, MCT_U232_SET_BAUD_RATE_SIZE,
-			     WDR_TIMEOUT);
+	int rc;
+	unsigned char zero_byte = 0;
+	unsigned char cts_enable_byte = 0;
+	speed_t speed;
+
+	divisor = cpu_to_le32(mct_u232_calculate_baud_rate(serial, value,
+								&speed));
+
+	rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
+				MCT_U232_SET_BAUD_RATE_REQUEST,
+				MCT_U232_SET_REQUEST_TYPE,
+				0, 0, &divisor, MCT_U232_SET_BAUD_RATE_SIZE,
+				WDR_TIMEOUT);
 	if (rc < 0)	/*FIXME: What value speed results */
 		err("Set BAUD RATE %d failed (error = %d)", value, rc);
 	else
@@ -256,55 +263,55 @@ static int mct_u232_set_baud_rate(struct tty_struct *tty,
 	   whether data will be transmitted to a device which is not asserting
 	   the 'CTS' signal.  If the second message's data byte is zero, data
 	   will be transmitted even if 'CTS' is not asserted (i.e. no hardware
-	   flow control).  if the second message's data byte is nonzero (a value
-	   of 1 is used by this driver), data will not be transmitted to a device
-	   which is not asserting 'CTS'.
+	   flow control).  if the second message's data byte is nonzero (a
+	   value of 1 is used by this driver), data will not be transmitted to
+	   a device which is not asserting 'CTS'.
 	*/
 
 	rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			     MCT_U232_SET_UNKNOWN1_REQUEST, 
-			     MCT_U232_SET_REQUEST_TYPE,
-			     0, 0, &zero_byte, MCT_U232_SET_UNKNOWN1_SIZE, 
-			     WDR_TIMEOUT);
+				MCT_U232_SET_UNKNOWN1_REQUEST,
+				MCT_U232_SET_REQUEST_TYPE,
+				0, 0, &zero_byte, MCT_U232_SET_UNKNOWN1_SIZE,
+				WDR_TIMEOUT);
 	if (rc < 0)
-		err("Sending USB device request code %d failed (error = %d)", 
+		err("Sending USB device request code %d failed (error = %d)",
 		    MCT_U232_SET_UNKNOWN1_REQUEST, rc);
 
-	if (port && C_CRTSCTS(tty)) {
+	if (port && C_CRTSCTS(tty))
 	   cts_enable_byte = 1;
-	}
 
-        dbg("set_baud_rate: send second control message, data = %02X", cts_enable_byte);
+	dbg("set_baud_rate: send second control message, data = %02X",
+							cts_enable_byte);
 	rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			     MCT_U232_SET_CTS_REQUEST,
-			     MCT_U232_SET_REQUEST_TYPE,
-			     0, 0, &cts_enable_byte, MCT_U232_SET_CTS_SIZE,
-			     WDR_TIMEOUT);
+			MCT_U232_SET_CTS_REQUEST,
+			MCT_U232_SET_REQUEST_TYPE,
+			0, 0, &cts_enable_byte, MCT_U232_SET_CTS_SIZE,
+			WDR_TIMEOUT);
 	if (rc < 0)
-	  err("Sending USB device request code %d failed (error = %d)",
-	      MCT_U232_SET_CTS_REQUEST, rc);
+		err("Sending USB device request code %d failed (error = %d)",
+					MCT_U232_SET_CTS_REQUEST, rc);
 
-        return rc;
+	return rc;
 } /* mct_u232_set_baud_rate */
 
 static int mct_u232_set_line_ctrl(struct usb_serial *serial, unsigned char lcr)
 {
-        int rc;
-        rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-                             MCT_U232_SET_LINE_CTRL_REQUEST,
-			     MCT_U232_SET_REQUEST_TYPE,
-                             0, 0, &lcr, MCT_U232_SET_LINE_CTRL_SIZE,
-			     WDR_TIMEOUT);
+	int rc;
+	rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
+			MCT_U232_SET_LINE_CTRL_REQUEST,
+			MCT_U232_SET_REQUEST_TYPE,
+			0, 0, &lcr, MCT_U232_SET_LINE_CTRL_SIZE,
+			WDR_TIMEOUT);
 	if (rc < 0)
 		err("Set LINE CTRL 0x%x failed (error = %d)", lcr, rc);
 	dbg("set_line_ctrl: 0x%x", lcr);
-        return rc;
+	return rc;
 } /* mct_u232_set_line_ctrl */
 
 static int mct_u232_set_modem_ctrl(struct usb_serial *serial,
 				   unsigned int control_state)
 {
-        int rc;
+	int rc;
 	unsigned char mcr = MCT_U232_MCR_NONE;
 
 	if (control_state & TIOCM_DTR)
@@ -312,37 +319,39 @@ static int mct_u232_set_modem_ctrl(struct usb_serial *serial,
 	if (control_state & TIOCM_RTS)
 		mcr |= MCT_U232_MCR_RTS;
 
-        rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-                             MCT_U232_SET_MODEM_CTRL_REQUEST,
-			     MCT_U232_SET_REQUEST_TYPE,
-                             0, 0, &mcr, MCT_U232_SET_MODEM_CTRL_SIZE,
-			     WDR_TIMEOUT);
+	rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
+			MCT_U232_SET_MODEM_CTRL_REQUEST,
+			MCT_U232_SET_REQUEST_TYPE,
+			0, 0, &mcr, MCT_U232_SET_MODEM_CTRL_SIZE,
+			WDR_TIMEOUT);
 	if (rc < 0)
 		err("Set MODEM CTRL 0x%x failed (error = %d)", mcr, rc);
 	dbg("set_modem_ctrl: state=0x%x ==> mcr=0x%x", control_state, mcr);
 
-        return rc;
+	return rc;
 } /* mct_u232_set_modem_ctrl */
 
-static int mct_u232_get_modem_stat(struct usb_serial *serial, unsigned char *msr)
+static int mct_u232_get_modem_stat(struct usb_serial *serial,
+						unsigned char *msr)
 {
-        int rc;
-        rc = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-                             MCT_U232_GET_MODEM_STAT_REQUEST,
-			     MCT_U232_GET_REQUEST_TYPE,
-                             0, 0, msr, MCT_U232_GET_MODEM_STAT_SIZE,
-			     WDR_TIMEOUT);
+	int rc;
+	rc = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+			MCT_U232_GET_MODEM_STAT_REQUEST,
+			MCT_U232_GET_REQUEST_TYPE,
+			0, 0, msr, MCT_U232_GET_MODEM_STAT_SIZE,
+			WDR_TIMEOUT);
 	if (rc < 0) {
 		err("Get MODEM STATus failed (error = %d)", rc);
 		*msr = 0;
 	}
 	dbg("get_modem_stat: 0x%x", *msr);
-        return rc;
+	return rc;
 } /* mct_u232_get_modem_stat */
 
-static void mct_u232_msr_to_state(unsigned int *control_state, unsigned char msr)
+static void mct_u232_msr_to_state(unsigned int *control_state,
+						unsigned char msr)
 {
- 	/* Translate Control Line states */
+	/* Translate Control Line states */
 	if (msr & MCT_U232_MSR_DSR)
 		*control_state |=  TIOCM_DSR;
 	else
@@ -359,14 +368,14 @@ static void mct_u232_msr_to_state(unsigned int *control_state, unsigned char msr
 		*control_state |=  TIOCM_CD;
 	else
 		*control_state &= ~TIOCM_CD;
- 	dbg("msr_to_state: msr=0x%x ==> state=0x%x", msr, *control_state);
+	dbg("msr_to_state: msr=0x%x ==> state=0x%x", msr, *control_state);
 } /* mct_u232_msr_to_state */
 
 /*
  * Driver's tty interface functions
  */
 
-static int mct_u232_startup (struct usb_serial *serial)
+static int mct_u232_startup(struct usb_serial *serial)
 {
 	struct mct_u232_private *priv;
 	struct usb_serial_port *port, *rport;
@@ -388,18 +397,18 @@ static int mct_u232_startup (struct usb_serial *serial)
 	rport->interrupt_in_urb = NULL;
 	port->read_urb->context = port;
 
-	return (0);
+	return 0;
 } /* mct_u232_startup */
 
 
-static void mct_u232_shutdown (struct usb_serial *serial)
+static void mct_u232_shutdown(struct usb_serial *serial)
 {
 	struct mct_u232_private *priv;
 	int i;
-	
+
 	dbg("%s", __func__);
 
-	for (i=0; i < serial->num_ports; ++i) {
+	for (i = 0; i < serial->num_ports; ++i) {
 		/* My special items, the standard routines free my urbs */
 		priv = usb_get_serial_port_data(serial->port[i]);
 		if (priv) {
@@ -409,7 +418,7 @@ static void mct_u232_shutdown (struct usb_serial *serial)
 	}
 } /* mct_u232_shutdown */
 
-static int  mct_u232_open (struct tty_struct *tty,
+static int  mct_u232_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
@@ -427,10 +436,11 @@ static int  mct_u232_open (struct tty_struct *tty,
 	 * it seems to be able to accept only 16 bytes (and that's what
 	 * SniffUSB says too...)
 	 */
-	if (le16_to_cpu(serial->dev->descriptor.idProduct) == MCT_U232_SITECOM_PID)
+	if (le16_to_cpu(serial->dev->descriptor.idProduct)
+						== MCT_U232_SITECOM_PID)
 		port->bulk_out_size = 16;
 
-	/* Do a defined restart: the normal serial device seems to 
+	/* Do a defined restart: the normal serial device seems to
 	 * always turn on DTR and RTS here, so do the same. I'm not
 	 * sure if this is really necessary. But it should not harm
 	 * either.
@@ -440,8 +450,8 @@ static int  mct_u232_open (struct tty_struct *tty,
 		priv->control_state = TIOCM_DTR | TIOCM_RTS;
 	else
 		priv->control_state = 0;
-	
-	priv->last_lcr = (MCT_U232_DATA_BITS_8 | 
+
+	priv->last_lcr = (MCT_U232_DATA_BITS_8 |
 			  MCT_U232_PARITY_NONE |
 			  MCT_U232_STOP_BITS_1);
 	control_state = priv->control_state;
@@ -488,7 +498,7 @@ static void mct_u232_close(struct tty_struct *tty,
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	dbg("%s port %d", __func__, port->number);
 
-   	if (tty) {
+	if (tty) {
 		c_cflag = tty->termios->c_cflag;
 		mutex_lock(&port->serial->disc_mutex);
 		if (c_cflag & HUPCL && !port->serial->disconnected) {
@@ -512,7 +522,7 @@ static void mct_u232_close(struct tty_struct *tty,
 } /* mct_u232_close */
 
 
-static void mct_u232_read_int_callback (struct urb *urb)
+static void mct_u232_read_int_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
@@ -545,8 +555,9 @@ static void mct_u232_read_int_callback (struct urb *urb)
 		return;
 	}
 
-        dbg("%s - port %d", __func__, port->number);
-	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
+	dbg("%s - port %d", __func__, port->number);
+	usb_serial_debug_data(debug, &port->dev, __func__,
+					urb->actual_length, data);
 
 	/*
 	 * Work-a-round: handle the 'usual' bulk-in pipe here
@@ -555,26 +566,25 @@ static void mct_u232_read_int_callback (struct urb *urb)
 		int i;
 		tty = port->port.tty;
 		if (urb->actual_length) {
-			for (i = 0; i < urb->actual_length ; ++i) {
+			for (i = 0; i < urb->actual_length ; ++i)
 				tty_insert_flip_char(tty, data[i], 0);
-			}
 			tty_flip_buffer_push(tty);
 		}
 		goto exit;
 	}
-	
+
 	/*
 	 * The interrupt-in pipe signals exceptional conditions (modem line
 	 * signal changes and errors). data[0] holds MSR, data[1] holds LSR.
 	 */
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->last_msr = data[MCT_U232_MSR_INDEX];
-	
+
 	/* Record Control Line states */
 	mct_u232_msr_to_state(&priv->control_state, priv->last_msr);
 
 #if 0
-	/* Not yet handled. See belin_sa.c for further information */
+	/* Not yet handled. See belkin_sa.c for further information */
 	/* Now to report any errors */
 	priv->last_lsr = data[MCT_U232_LSR_INDEX];
 	/*
@@ -600,15 +610,15 @@ static void mct_u232_read_int_callback (struct urb *urb)
 #endif
 	spin_unlock_irqrestore(&priv->lock, flags);
 exit:
-	retval = usb_submit_urb (urb, GFP_ATOMIC);
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		err ("%s - usb_submit_urb failed with result %d",
+		err("%s - usb_submit_urb failed with result %d",
 		     __func__, retval);
 } /* mct_u232_read_int_callback */
 
-static void mct_u232_set_termios (struct tty_struct *tty,
-				  struct usb_serial_port *port,
-				  struct ktermios *old_termios)
+static void mct_u232_set_termios(struct tty_struct *tty,
+				 struct usb_serial_port *port,
+				 struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
@@ -632,7 +642,7 @@ static void mct_u232_set_termios (struct tty_struct *tty,
 	 * Premature optimization is the root of all evil.
 	 */
 
-        /* reassert DTR and RTS on transition from B0 */
+	/* reassert DTR and RTS on transition from B0 */
 	if ((old_cflag & CBAUD) == B0) {
 		dbg("%s: baud was B0", __func__);
 		control_state |= TIOCM_DTR | TIOCM_RTS;
@@ -641,11 +651,11 @@ static void mct_u232_set_termios (struct tty_struct *tty,
 
 	mct_u232_set_baud_rate(tty, serial, port, tty_get_baud_rate(tty));
 
-	if ((cflag & CBAUD) == B0 ) {
+	if ((cflag & CBAUD) == B0) {
 		dbg("%s: baud is B0", __func__);
 		/* Drop RTS and DTR */
 		control_state &= ~(TIOCM_DTR | TIOCM_RTS);
-       		mct_u232_set_modem_ctrl(serial, control_state);
+		mct_u232_set_modem_ctrl(serial, control_state);
 	}
 
 	/*
@@ -717,7 +727,7 @@ static int mct_u232_tiocmget(struct tty_struct *tty, struct file *file)
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	unsigned int control_state;
 	unsigned long flags;
-	
+
 	dbg("%s", __func__);
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -735,7 +745,7 @@ static int mct_u232_tiocmset(struct tty_struct *tty, struct file *file,
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	unsigned int control_state;
 	unsigned long flags;
-	
+
 	dbg("%s", __func__);
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -798,7 +808,7 @@ static void mct_u232_unthrottle(struct tty_struct *tty)
 	}
 }
 
-static int __init mct_u232_init (void)
+static int __init mct_u232_init(void)
 {
 	int retval;
 	retval = usb_serial_register(&mct_u232_device);
@@ -816,18 +826,17 @@ failed_usb_serial_register:
 }
 
 
-static void __exit mct_u232_exit (void)
+static void __exit mct_u232_exit(void)
 {
-	usb_deregister (&mct_u232_driver);
-	usb_serial_deregister (&mct_u232_device);
+	usb_deregister(&mct_u232_driver);
+	usb_serial_deregister(&mct_u232_device);
 }
 
-
-module_init (mct_u232_init);
+module_init(mct_u232_init);
 module_exit(mct_u232_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);

