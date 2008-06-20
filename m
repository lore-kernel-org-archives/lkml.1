Return-Path: <linux-kernel-owner+w=401wt.eu-S1765466AbYFTUgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765466AbYFTUgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762169AbYFTUWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:22:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35235 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762157AbYFTUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:22:27 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 53/70] tty-usb-kl5kusb105: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:05:02 +0100
Message-ID: <20080620200500.1479.63072.stgit@localhost.localdomain>
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

 drivers/usb/serial/kl5kusb105.c |  389 +++++++++++++++++++--------------------
 1 files changed, 188 insertions(+), 201 deletions(-)


diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index 4c27ccc..d898dc4 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -15,12 +15,12 @@
  * Neither Palm, nor their contractor (MCCI) or their supplier (KLSI) provided
  * information that was not already available.
  *
- * It seems that KLSI bought some silicon-design information from ScanLogic, 
+ * It seems that KLSI bought some silicon-design information from ScanLogic,
  * whose SL11R processor is at the core of the KL5KUSB chipset from KLSI.
  * KLSI has firmware available for their devices; it is probable that the
  * firmware differs from that used by KLSI in their products. If you have an
- * original KLSI device and can provide some information on it, I would be 
- * most interested in adding support for it here. If you have any information 
+ * original KLSI device and can provide some information on it, I would be
+ * most interested in adding support for it here. If you have any information
  * on the protocol used (or find errors in my reverse-engineered stuff), please
  * let me know.
  *
@@ -40,7 +40,7 @@
  *   0.2  - TIOCMGET works, so autopilot(1) can be used!
  *   0.1  - can be used to to pilot-xfer -p /dev/ttyUSB0 -l
  *
- *   The driver skeleton is mainly based on mct_u232.c and various other 
+ *   The driver skeleton is mainly based on mct_u232.c and various other
  *   pieces of code shamelessly copied from the drivers/usb/serial/ directory.
  */
 
@@ -53,7 +53,7 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
 #include <linux/module.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/unaligned.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
@@ -72,37 +72,25 @@ static int debug;
 /*
  * Function prototypes
  */
-static int  klsi_105_startup	         (struct usb_serial *serial);
-static void klsi_105_shutdown	         (struct usb_serial *serial);
-static int  klsi_105_open	         (struct tty_struct *tty,
-					  struct usb_serial_port *port,
-					  struct file *filp);
-static void klsi_105_close	         (struct tty_struct *tty,
-					  struct usb_serial_port *port,
-					  struct file *filp);
-static int  klsi_105_write	         (struct tty_struct *tty,
-					  struct usb_serial_port *port,
-					  const unsigned char *buf,
-					  int count);
-static void klsi_105_write_bulk_callback (struct urb *urb);
-static int  klsi_105_chars_in_buffer     (struct tty_struct *tty);
-static int  klsi_105_write_room          (struct tty_struct *tty);
-
-static void klsi_105_read_bulk_callback  (struct urb *urb);
-static void klsi_105_set_termios         (struct tty_struct *tty,
-					  struct usb_serial_port *port,
-					  struct ktermios *old);
-static void klsi_105_throttle		 (struct tty_struct *tty);
-static void klsi_105_unthrottle		 (struct tty_struct *tty);
-/*
-static void klsi_105_break_ctl	         (struct tty_struct *tty,
-					  int break_state );
- */
-static int  klsi_105_tiocmget	         (struct tty_struct *tty,
-					  struct file *file);
-static int  klsi_105_tiocmset	         (struct tty_struct *tty,
-					  struct file *file, unsigned int set,
-					  unsigned int clear);
+static int  klsi_105_startup(struct usb_serial *serial);
+static void klsi_105_shutdown(struct usb_serial *serial);
+static int  klsi_105_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static void klsi_105_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static int  klsi_105_write(struct tty_struct *tty,
+	struct usb_serial_port *port, const unsigned char *buf, int count);
+static void klsi_105_write_bulk_callback(struct urb *urb);
+static int  klsi_105_chars_in_buffer(struct tty_struct *tty);
+static int  klsi_105_write_room(struct tty_struct *tty);
+static void klsi_105_read_bulk_callback(struct urb *urb);
+static void klsi_105_set_termios(struct tty_struct *tty,
+			struct usb_serial_port *port, struct ktermios *old);
+static void klsi_105_throttle(struct tty_struct *tty);
+static void klsi_105_unthrottle(struct tty_struct *tty);
+static int  klsi_105_tiocmget((struct tty_struct *tty, struct file *file);
+static int  klsi_105_tiocmset(struct tty_struct *tty, struct file *file,
+			unsigned int set, unsigned int clear);
 
 /*
  * All of the device info needed for the KLSI converters.
@@ -113,7 +101,7 @@ static struct usb_device_id id_table [] = {
 	{ }		/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table);
+MODULE_DEVICE_TABLE(usb, id_table);
 
 static struct usb_driver kl5kusb105d_driver = {
 	.name =		"kl5kusb105d",
@@ -138,7 +126,7 @@ static struct usb_serial_driver kl5kusb105d_device = {
 	.write_bulk_callback = klsi_105_write_bulk_callback,
 	.chars_in_buffer =   klsi_105_chars_in_buffer,
 	.write_room =        klsi_105_write_room,
-	.read_bulk_callback =klsi_105_read_bulk_callback,
+	.read_bulk_callback = klsi_105_read_bulk_callback,
 	.set_termios =	     klsi_105_set_termios,
 	/*.break_ctl =	     klsi_105_break_ctl,*/
 	.tiocmget =          klsi_105_tiocmget,
@@ -165,7 +153,7 @@ struct klsi_105_private {
 	struct ktermios			termios;
 	unsigned long			line_state; /* modem line settings */
 	/* write pool */
-	struct urb *			write_urb_pool[NUM_URBS];
+	struct urb			*write_urb_pool[NUM_URBS];
 	spinlock_t			lock;
 	unsigned long			bytes_in;
 	unsigned long			bytes_out;
@@ -184,15 +172,15 @@ static int klsi_105_chg_port_settings(struct usb_serial_port *port,
 {
 	int rc;
 
-        rc = usb_control_msg(port->serial->dev,
-			     usb_sndctrlpipe(port->serial->dev, 0),
-			     KL5KUSB105A_SIO_SET_DATA,
-                             USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_INTERFACE,
-			     0, /* value */
-			     0, /* index */
-			     settings,
-			     sizeof(struct klsi_105_port_settings),
-			     KLSI_TIMEOUT);
+	rc = usb_control_msg(port->serial->dev,
+			usb_sndctrlpipe(port->serial->dev, 0),
+			KL5KUSB105A_SIO_SET_DATA,
+			USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_INTERFACE,
+			0, /* value */
+			0, /* index */
+			settings,
+			sizeof(struct klsi_105_port_settings),
+			KLSI_TIMEOUT);
 	if (rc < 0)
 		err("Change port settings failed (error = %d)", rc);
 	info("%s - %d byte block, baudrate %x, databits %d, u1 %d, u2 %d",
@@ -200,7 +188,7 @@ static int klsi_105_chg_port_settings(struct usb_serial_port *port,
 	    settings->pktlen,
 	    settings->baudrate, settings->databits,
 	    settings->unknown1, settings->unknown2);
-        return rc;
+	return rc;
 } /* klsi_105_chg_port_settings */
 
 /* translate a 16-bit status value from the device to linux's TIO bits */
@@ -214,9 +202,9 @@ static unsigned long klsi_105_status2linestate(const __u16 status)
 
 	return res;
 }
-/* 
+/*
  * Read line control via vendor command and return result through
- * *line_state_p 
+ * *line_state_p
  */
 /* It seems that the status buffer has always only 2 bytes length */
 #define KLSI_STATUSBUF_LEN	2
@@ -224,14 +212,14 @@ static int klsi_105_get_line_state(struct usb_serial_port *port,
 				   unsigned long *line_state_p)
 {
 	int rc;
-	__u8 status_buf[KLSI_STATUSBUF_LEN] = { -1,-1};
+	__u8 status_buf[KLSI_STATUSBUF_LEN] = { -1, -1};
 	__u16 status;
 
 	info("%s - sending SIO Poll request", __func__);
-        rc = usb_control_msg(port->serial->dev,
+	rc = usb_control_msg(port->serial->dev,
 			     usb_rcvctrlpipe(port->serial->dev, 0),
 			     KL5KUSB105A_SIO_POLL,
-                             USB_TYPE_VENDOR | USB_DIR_IN,
+			     USB_TYPE_VENDOR | USB_DIR_IN,
 			     0, /* value */
 			     0, /* index */
 			     status_buf, KLSI_STATUSBUF_LEN,
@@ -247,8 +235,7 @@ static int klsi_105_get_line_state(struct usb_serial_port *port,
 
 		*line_state_p = klsi_105_status2linestate(status);
 	}
-
-        return rc;
+	return rc;
 }
 
 
@@ -256,7 +243,7 @@ static int klsi_105_get_line_state(struct usb_serial_port *port,
  * Driver's tty interface functions
  */
 
-static int klsi_105_startup (struct usb_serial *serial)
+static int klsi_105_startup(struct usb_serial *serial)
 {
 	struct klsi_105_private *priv;
 	int i, j;
@@ -266,7 +253,7 @@ static int klsi_105_startup (struct usb_serial *serial)
 	 */
 
 	/* allocate the private data structure */
-	for (i=0; i<serial->num_ports; i++) {
+	for (i = 0; i < serial->num_ports; i++) {
 		priv = kmalloc(sizeof(struct klsi_105_private),
 						   GFP_KERNEL);
 		if (!priv) {
@@ -287,9 +274,9 @@ static int klsi_105_startup (struct usb_serial *serial)
 		priv->bytes_out	    = 0;
 		usb_set_serial_port_data(serial->port[i], priv);
 
-		spin_lock_init (&priv->lock);
-		for (j=0; j<NUM_URBS; j++) {
-			struct urb* urb = usb_alloc_urb(0, GFP_KERNEL);
+		spin_lock_init(&priv->lock);
+		for (j = 0; j < NUM_URBS; j++) {
+			struct urb *urb = usb_alloc_urb(0, GFP_KERNEL);
 
 			priv->write_urb_pool[j] = urb;
 			if (urb == NULL) {
@@ -297,10 +284,11 @@ static int klsi_105_startup (struct usb_serial *serial)
 				goto err_cleanup;
 			}
 
-			urb->transfer_buffer = kmalloc (URB_TRANSFER_BUFFER_SIZE,
-							GFP_KERNEL);
+			urb->transfer_buffer =
+				kmalloc(URB_TRANSFER_BUFFER_SIZE, GFP_KERNEL);
 			if (!urb->transfer_buffer) {
-				err("%s - out of memory for urb buffers.", __func__);
+				err("%s - out of memory for urb buffers.",
+								__func__);
 				goto err_cleanup;
 			}
 		}
@@ -308,13 +296,13 @@ static int klsi_105_startup (struct usb_serial *serial)
 		/* priv->termios is left uninitalized until port opening */
 		init_waitqueue_head(&serial->port[i]->write_wait);
 	}
-	
+
 	return 0;
 
 err_cleanup:
 	for (; i >= 0; i--) {
 		priv = usb_get_serial_port_data(serial->port[i]);
-		for (j=0; j < NUM_URBS; j++) {
+		for (j = 0; j < NUM_URBS; j++) {
 			if (priv->write_urb_pool[j]) {
 				kfree(priv->write_urb_pool[j]->transfer_buffer);
 				usb_free_urb(priv->write_urb_pool[j]);
@@ -326,22 +314,23 @@ err_cleanup:
 } /* klsi_105_startup */
 
 
-static void klsi_105_shutdown (struct usb_serial *serial)
+static void klsi_105_shutdown(struct usb_serial *serial)
 {
 	int i;
-	
+
 	dbg("%s", __func__);
 
 	/* stop reads and writes on all ports */
-	for (i=0; i < serial->num_ports; ++i) {
-		struct klsi_105_private *priv = usb_get_serial_port_data(serial->port[i]);
+	for (i = 0; i < serial->num_ports; ++i) {
+		struct klsi_105_private *priv =
+				usb_get_serial_port_data(serial->port[i]);
 		unsigned long flags;
 
 		if (priv) {
 			/* kill our write urb pool */
 			int j;
 			struct urb **write_urbs = priv->write_urb_pool;
-			spin_lock_irqsave(&priv->lock,flags);
+			spin_lock_irqsave(&priv->lock, flags);
 
 			for (j = 0; j < NUM_URBS; j++) {
 				if (write_urbs[j]) {
@@ -353,12 +342,10 @@ static void klsi_105_shutdown (struct usb_serial *serial)
 					 * oopses. */
 					/* usb_kill_urb(write_urbs[j]); */
 					kfree(write_urbs[j]->transfer_buffer);
-					usb_free_urb (write_urbs[j]);
+					usb_free_urb(write_urbs[j]);
 				}
 			}
-
-			spin_unlock_irqrestore (&priv->lock, flags);
-
+			spin_unlock_irqrestore(&priv->lock, flags);
 			kfree(priv);
 			usb_set_serial_port_data(serial->port[i], NULL);
 		}
@@ -384,7 +371,7 @@ static int  klsi_105_open(struct tty_struct *tty,
 
 	/* Do a defined restart:
 	 * Set up sane default baud rate and send the 'READ_ON'
-	 * vendor command. 
+	 * vendor command.
 	 * FIXME: set modem line control (how?)
 	 * Then read the modem line control and store values in
 	 * priv->line_state.
@@ -395,24 +382,24 @@ static int  klsi_105_open(struct tty_struct *tty,
 	cfg.unknown1 = 0;
 	cfg.unknown2 = 1;
 	klsi_105_chg_port_settings(port, &cfg);
-	
+
 	/* set up termios structure */
-	spin_lock_irqsave (&priv->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	priv->termios.c_iflag = tty->termios->c_iflag;
 	priv->termios.c_oflag = tty->termios->c_oflag;
 	priv->termios.c_cflag = tty->termios->c_cflag;
 	priv->termios.c_lflag = tty->termios->c_lflag;
-	for (i=0; i<NCCS; i++)
+	for (i = 0; i < NCCS; i++)
 		priv->termios.c_cc[i] = tty->termios->c_cc[i];
 	priv->cfg.pktlen   = cfg.pktlen;
 	priv->cfg.baudrate = cfg.baudrate;
 	priv->cfg.databits = cfg.databits;
 	priv->cfg.unknown1 = cfg.unknown1;
 	priv->cfg.unknown2 = cfg.unknown2;
-	spin_unlock_irqrestore (&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* READ_ON and urb submission */
-	usb_fill_bulk_urb(port->read_urb, port->serial->dev, 
+	usb_fill_bulk_urb(port->read_urb, port->serial->dev,
 		      usb_rcvbulkpipe(port->serial->dev,
 				      port->bulk_in_endpointAddress),
 		      port->read_urb->transfer_buffer,
@@ -428,7 +415,7 @@ static int  klsi_105_open(struct tty_struct *tty,
 	}
 
 	rc = usb_control_msg(port->serial->dev,
-			     usb_sndctrlpipe(port->serial->dev,0),
+			     usb_sndctrlpipe(port->serial->dev, 0),
 			     KL5KUSB105A_SIO_CONFIGURE,
 			     USB_TYPE_VENDOR|USB_DIR_OUT|USB_RECIP_INTERFACE,
 			     KL5KUSB105A_SIO_CONFIGURE_READ_ON,
@@ -439,14 +426,14 @@ static int  klsi_105_open(struct tty_struct *tty,
 	if (rc < 0) {
 		err("Enabling read failed (error = %d)", rc);
 		retval = rc;
-	} else 
+	} else
 		dbg("%s - enabled reading", __func__);
 
 	rc = klsi_105_get_line_state(port, &line_state);
 	if (rc >= 0) {
-		spin_lock_irqsave (&priv->lock, flags);
+		spin_lock_irqsave(&priv->lock, flags);
 		priv->line_state = line_state;
-		spin_unlock_irqrestore (&priv->lock, flags);
+		spin_unlock_irqrestore*&priv->lock, flags);
 		dbg("%s - read line state 0x%lx", __func__, line_state);
 		retval = 0;
 	} else
@@ -468,14 +455,14 @@ static void klsi_105_close(struct tty_struct *tty,
 	mutex_lock(&port->serial->disc_mutex);
 	if (!port->serial->disconnected) {
 		/* send READ_OFF */
-		rc = usb_control_msg (port->serial->dev,
-				      usb_sndctrlpipe(port->serial->dev, 0),
-				      KL5KUSB105A_SIO_CONFIGURE,
-				      USB_TYPE_VENDOR | USB_DIR_OUT,
-				      KL5KUSB105A_SIO_CONFIGURE_READ_OFF,
-				      0, /* index */
-				      NULL, 0,
-				      KLSI_TIMEOUT);
+		rc = usb_control_msg(port->serial->dev,
+				     usb_sndctrlpipe(port->serial->dev, 0),
+				     KL5KUSB105A_SIO_CONFIGURE,
+				     USB_TYPE_VENDOR | USB_DIR_OUT,
+				     KL5KUSB105A_SIO_CONFIGURE_READ_OFF,
+				     0, /* index */
+				     NULL, 0,
+				     KLSI_TIMEOUT);
 		if (rc < 0)
 			err("Disabling read failed (error = %d)", rc);
 	}
@@ -488,12 +475,13 @@ static void klsi_105_close(struct tty_struct *tty,
 	/* FIXME */
 	/* wgg - do I need this? I think so. */
 	usb_kill_urb(port->interrupt_in_urb);
-	info("kl5kusb105 port stats: %ld bytes in, %ld bytes out", priv->bytes_in, priv->bytes_out);
+	info("kl5kusb105 port stats: %ld bytes in, %ld bytes out",
+					priv->bytes_in, priv->bytes_out);
 } /* klsi_105_close */
 
 
 /* We need to write a complete 64-byte data block and encode the
- * number actually sent in the first double-byte, LSB-order. That 
+ * number actually sent in the first double-byte, LSB-order. That
  * leaves at most 62 bytes of payload.
  */
 #define KLSI_105_DATA_OFFSET	2   /* in the bulk urb data block */
@@ -504,7 +492,7 @@ static int klsi_105_write(struct tty_struct *tty,
 {
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
 	int result, size;
-	int bytes_sent=0;
+	int bytes_sent = 0;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -513,34 +501,37 @@ static int klsi_105_write(struct tty_struct *tty,
 		struct urb *urb = NULL;
 		unsigned long flags;
 		int i;
-		/* since the pool is per-port we might not need the spin lock !? */
-		spin_lock_irqsave (&priv->lock, flags);
-		for (i=0; i<NUM_URBS; i++) {
+		/* since the pool is per-port we might not need
+		   the spin lock !? */
+		spin_lock_irqsave(&priv->lock, flags);
+		for (i = 0; i < NUM_URBS; i++) {
 			if (priv->write_urb_pool[i]->status != -EINPROGRESS) {
 				urb = priv->write_urb_pool[i];
 				dbg("%s - using pool URB %d", __func__, i);
 				break;
 			}
 		}
-		spin_unlock_irqrestore (&priv->lock, flags);
+		spin_unlock_irqrestore(&priv->lock, flags);
 
-		if (urb==NULL) {
+		if (urb == NULL) {
 			dbg("%s - no more free urbs", __func__);
 			goto exit;
 		}
 
 		if (urb->transfer_buffer == NULL) {
-			urb->transfer_buffer = kmalloc (URB_TRANSFER_BUFFER_SIZE, GFP_ATOMIC);
+			urb->transfer_buffer =
+				kmalloc(URB_TRANSFER_BUFFER_SIZE, GFP_ATOMIC);
 			if (urb->transfer_buffer == NULL) {
 				err("%s - no more kernel memory...", __func__);
 				goto exit;
 			}
 		}
 
-		size = min (count, port->bulk_out_size - KLSI_105_DATA_OFFSET);
-		size = min (size, URB_TRANSFER_BUFFER_SIZE - KLSI_105_DATA_OFFSET);
+		size = min(count, port->bulk_out_size - KLSI_105_DATA_OFFSET);
+		size = min(size, URB_TRANSFER_BUFFER_SIZE -
+							KLSI_105_DATA_OFFSET);
 
-		memcpy (urb->transfer_buffer + KLSI_105_DATA_OFFSET, buf, size);
+		memcpy(urb->transfer_buffer + KLSI_105_DATA_OFFSET, buf, size);
 
 		/* write payload size into transfer buffer */
 		((__u8 *)urb->transfer_buffer)[0] = (__u8) (size & 0xFF);
@@ -558,7 +549,8 @@ static int klsi_105_write(struct tty_struct *tty,
 		/* send the data out the bulk port */
 		result = usb_submit_urb(urb, GFP_ATOMIC);
 		if (result) {
-			err("%s - failed submitting write urb, error %d", __func__, result);
+			err("%s - failed submitting write urb, error %d",
+							__func__, result);
 			goto exit;
 		}
 		buf += size;
@@ -567,12 +559,12 @@ static int klsi_105_write(struct tty_struct *tty,
 	}
 exit:
 	/* lockless, but it's for debug info only... */
-	priv->bytes_out+=bytes_sent;
+	priv->bytes_out += bytes_sent;
 
 	return bytes_sent;	/* that's how much we wrote */
 } /* klsi_105_write */
 
-static void klsi_105_write_bulk_callback ( struct urb *urb)
+static void klsi_105_write_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
@@ -590,7 +582,7 @@ static void klsi_105_write_bulk_callback ( struct urb *urb)
 
 
 /* return number of characters currently in the writing process */
-static int klsi_105_chars_in_buffer (struct tty_struct *tty)
+static int klsi_105_chars_in_buffer(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	int chars = 0;
@@ -598,21 +590,20 @@ static int klsi_105_chars_in_buffer (struct tty_struct *tty)
 	unsigned long flags;
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
 
-	spin_lock_irqsave (&priv->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	for (i = 0; i < NUM_URBS; ++i) {
-		if (priv->write_urb_pool[i]->status == -EINPROGRESS) {
+		if (priv->write_urb_pool[i]->status == -EINPROGRESS)
 			chars += URB_TRANSFER_BUFFER_SIZE;
-		}
 	}
 
-	spin_unlock_irqrestore (&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	dbg("%s - returns %d", __func__, chars);
-	return (chars);
+	return chars;
 }
 
-static int klsi_105_write_room (struct tty_struct *tty)
+static int klsi_105_write_room(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	unsigned long flags;
@@ -620,22 +611,21 @@ static int klsi_105_write_room (struct tty_struct *tty)
 	int room = 0;
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
 
-	spin_lock_irqsave (&priv->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	for (i = 0; i < NUM_URBS; ++i) {
-		if (priv->write_urb_pool[i]->status != -EINPROGRESS) {
+		if (priv->write_urb_pool[i]->status != -EINPROGRESS)
 			room += URB_TRANSFER_BUFFER_SIZE;
-		}
 	}
 
-	spin_unlock_irqrestore (&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	dbg("%s - returns %d", __func__, room);
-	return (room);
+	return room;
 }
 
 
 
-static void klsi_105_read_bulk_callback (struct urb *urb)
+static void klsi_105_read_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
@@ -674,7 +664,7 @@ static void klsi_105_read_bulk_callback (struct urb *urb)
 		 * against re-entry an then mixed-up data because of
 		 * intermixed tty_flip_buffer_push()s
 		 * FIXME
-		 */ 
+		 */
 		usb_serial_debug_data(debug, &port->dev, __func__,
 				      urb->actual_length, data);
 
@@ -694,7 +684,7 @@ static void klsi_105_read_bulk_callback (struct urb *urb)
 		priv->bytes_in += bytes_sent;
 	}
 	/* Continue trying to always read  */
-	usb_fill_bulk_urb(port->read_urb, port->serial->dev, 
+	usb_fill_bulk_urb(port->read_urb, port->serial->dev,
 		      usb_rcvbulkpipe(port->serial->dev,
 				      port->bulk_in_endpointAddress),
 		      port->read_urb->transfer_buffer,
@@ -703,13 +693,14 @@ static void klsi_105_read_bulk_callback (struct urb *urb)
 		      port);
 	rc = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 	if (rc)
-		err("%s - failed resubmitting read urb, error %d", __func__, rc);
+		err("%s - failed resubmitting read urb, error %d",
+							__func__, rc);
 } /* klsi_105_read_bulk_callback */
 
 
-static void klsi_105_set_termios (struct tty_struct *tty,
-				  struct usb_serial_port *port,
-				  struct ktermios *old_termios)
+static void klsi_105_set_termios(struct tty_struct *tty,
+				 struct usb_serial_port *port,
+				 struct ktermios *old_termios)
 {
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
 	unsigned int iflag = tty->termios->c_iflag;
@@ -719,65 +710,63 @@ static void klsi_105_set_termios (struct tty_struct *tty,
 	struct klsi_105_port_settings cfg;
 	unsigned long flags;
 	speed_t baud;
-	
+
 	/* lock while we are modifying the settings */
-	spin_lock_irqsave (&priv->lock, flags);
-	
+	spin_lock_irqsave(&priv->lock, flags);
+
 	/*
 	 * Update baud rate
 	 */
 	baud = tty_get_baud_rate(tty);
 
-	if( (cflag & CBAUD) != (old_cflag & CBAUD) ) {
-	        /* reassert DTR and (maybe) RTS on transition from B0 */
-		if( (old_cflag & CBAUD) == B0 ) {
+	if ((cflag & CBAUD) != (old_cflag & CBAUD)) {
+		/* reassert DTR and (maybe) RTS on transition from B0 */
+		if ((old_cflag & CBAUD) == B0) {
 			dbg("%s: baud was B0", __func__);
 #if 0
 			priv->control_state |= TIOCM_DTR;
 			/* don't set RTS if using hardware flow control */
-			if (!(old_cflag & CRTSCTS)) {
+			if (!(old_cflag & CRTSCTS))
 				priv->control_state |= TIOCM_RTS;
-			}
 			mct_u232_set_modem_ctrl(serial, priv->control_state);
 #endif
 		}
 	}
-	switch(baud) {
-		case 0: /* handled below */
-			break;
-		case 1200:
-			priv->cfg.baudrate = kl5kusb105a_sio_b1200;
-			break;
-		case 2400:
-			priv->cfg.baudrate = kl5kusb105a_sio_b2400;
-			break;
-		case 4800:
-			priv->cfg.baudrate = kl5kusb105a_sio_b4800;
-			break;
-		case 9600:
+	switch (baud) {
+	case 0: /* handled below */
+		break;
+	case 1200:
+		priv->cfg.baudrate = kl5kusb105a_sio_b1200;
+		break;
+	case 2400:
+		priv->cfg.baudrate = kl5kusb105a_sio_b2400;
+		break;
+	case 4800:
+		priv->cfg.baudrate = kl5kusb105a_sio_b4800;
+		break;
+	case 9600:
+		priv->cfg.baudrate = kl5kusb105a_sio_b9600;
+		break;
+	case 19200:
+		priv->cfg.baudrate = kl5kusb105a_sio_b19200;
+		break;
+	case 38400:
+		priv->cfg.baudrate = kl5kusb105a_sio_b38400;
+		break;
+	case 57600:
+		priv->cfg.baudrate = kl5kusb105a_sio_b57600;
+		break;
+	case 115200:
+		priv->cfg.baudrate = kl5kusb105a_sio_b115200;
+		break;
+	default:
+		dbg("KLSI USB->Serial converter:"
+		    " unsupported baudrate request, using default of 9600");
 			priv->cfg.baudrate = kl5kusb105a_sio_b9600;
-			break;
-		case 19200:
-			priv->cfg.baudrate = kl5kusb105a_sio_b19200;
-			break;
-		case 38400:
-			priv->cfg.baudrate = kl5kusb105a_sio_b38400;
-			break;
-		case 57600:
-			priv->cfg.baudrate = kl5kusb105a_sio_b57600;
-			break;
-		case 115200:
-			priv->cfg.baudrate = kl5kusb105a_sio_b115200;
-			break;
-		default:
-			dbg("KLSI USB->Serial converter:"
-			    " unsupported baudrate request, using default"
-			    " of 9600");
-			priv->cfg.baudrate = kl5kusb105a_sio_b9600;
-			baud = 9600;
-			break;
+		baud = 9600;
+		break;
 	}
-	if ((cflag & CBAUD) == B0 ) {
+	if ((cflag & CBAUD) == B0) {
 		dbg("%s: baud is B0", __func__);
 		/* Drop RTS and DTR */
 		/* maybe this should be simulated by sending read
@@ -786,7 +775,7 @@ static void klsi_105_set_termios (struct tty_struct *tty,
 		;
 #if 0
 		priv->control_state &= ~(TIOCM_DTR | TIOCM_RTS);
-       		mct_u232_set_modem_ctrl(serial, priv->control_state);
+		mct_u232_set_modem_ctrl(serial, priv->control_state);
 #endif
 	}
 	tty_encode_baud_rate(tty, baud, baud);
@@ -796,11 +785,11 @@ static void klsi_105_set_termios (struct tty_struct *tty,
 		switch (cflag & CSIZE) {
 		case CS5:
 			dbg("%s - 5 bits/byte not supported", __func__);
-			spin_unlock_irqrestore (&priv->lock, flags);
+			spin_unlock_irqrestore(&priv->lock, flags);
 			return ;
 		case CS6:
 			dbg("%s - 6 bits/byte not supported", __func__);
-			spin_unlock_irqrestore (&priv->lock, flags);
+			spin_unlock_irqrestore(&priv->lock, flags);
 			return ;
 		case CS7:
 			priv->cfg.databits = kl5kusb105a_dtb_7;
@@ -819,8 +808,7 @@ static void klsi_105_set_termios (struct tty_struct *tty,
 	 * Update line control register (LCR)
 	 */
 	if ((cflag & (PARENB|PARODD)) != (old_cflag & (PARENB|PARODD))
-	    || (cflag & CSTOPB) != (old_cflag & CSTOPB) ) {
-		
+	    || (cflag & CSTOPB) != (old_cflag & CSTOPB)) {
 		/* Not currently supported */
 		tty->termios->c_cflag &= ~(PARENB|PARODD|CSTOPB);
 #if 0
@@ -841,20 +829,18 @@ static void klsi_105_set_termios (struct tty_struct *tty,
 #endif
 		;
 	}
-	
 	/*
 	 * Set flow control: well, I do not really now how to handle DTR/RTS.
 	 * Just do what we have seen with SniffUSB on Win98.
 	 */
-	if( (iflag & IXOFF) != (old_iflag & IXOFF)
+	if ((iflag & IXOFF) != (old_iflag & IXOFF)
 	    || (iflag & IXON) != (old_iflag & IXON)
-	    ||  (cflag & CRTSCTS) != (old_cflag & CRTSCTS) ) {
-		
+	    ||  (cflag & CRTSCTS) != (old_cflag & CRTSCTS)) {
 		/* Not currently supported */
 		tty->termios->c_cflag &= ~CRTSCTS;
 		/* Drop DTR/RTS if no flow control otherwise assert */
 #if 0
-		if ((iflag & IXOFF) || (iflag & IXON) || (cflag & CRTSCTS) )
+		if ((iflag & IXOFF) || (iflag & IXON) || (cflag & CRTSCTS))
 			priv->control_state |= TIOCM_DTR | TIOCM_RTS;
 		else
 			priv->control_state &= ~(TIOCM_DTR | TIOCM_RTS);
@@ -862,20 +848,21 @@ static void klsi_105_set_termios (struct tty_struct *tty,
 #endif
 		;
 	}
-	memcpy (&cfg, &priv->cfg, sizeof(cfg));
-	spin_unlock_irqrestore (&priv->lock, flags);
-	
+	memcpy(&cfg, &priv->cfg, sizeof(cfg));
+	spin_unlock_irqrestore(&priv->lock, flags);
+
 	/* now commit changes to device */
 	klsi_105_chg_port_settings(port, &cfg);
 } /* klsi_105_set_termios */
 
 
 #if 0
-static void mct_u232_break_ctl( struct tty_struct *tty, int break_state )
+static void mct_u232_break_ctl(struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
-	struct mct_u232_private *priv = (struct mct_u232_private *)port->private;
+	struct mct_u232_private *priv =
+				(struct mct_u232_private *)port->private;
 	unsigned char lcr = priv->last_lcr;
 
 	dbg("%sstate=%d", __func__, break_state);
@@ -887,7 +874,7 @@ static void mct_u232_break_ctl( struct tty_struct *tty, int break_state )
 } /* mct_u232_break_ctl */
 #endif
 
-static int klsi_105_tiocmget (struct tty_struct *tty, struct file *file)
+static int klsi_105_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
@@ -903,18 +890,18 @@ static int klsi_105_tiocmget (struct tty_struct *tty, struct file *file)
 		return rc;
 	}
 
-	spin_lock_irqsave (&priv->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	priv->line_state = line_state;
-	spin_unlock_irqrestore (&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	dbg("%s - read line state 0x%lx", __func__, line_state);
 	return (int)line_state;
 }
 
-static int klsi_105_tiocmset (struct tty_struct *tty, struct file *file,
-			      unsigned int set, unsigned int clear)
+static int klsi_105_tiocmset(struct tty_struct *tty, struct file *file,
+			     unsigned int set, unsigned int clear)
 {
 	int retval = -EINVAL;
-	
+
 	dbg("%s", __func__);
 
 /* if this ever gets implemented, it should be done something like this:
@@ -939,14 +926,14 @@ static int klsi_105_tiocmset (struct tty_struct *tty, struct file *file,
 	return retval;
 }
 
-static void klsi_105_throttle (struct tty_struct *tty)
+static void klsi_105_throttle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s - port %d", __func__, port->number);
 	usb_kill_urb(port->read_urb);
 }
 
-static void klsi_105_unthrottle (struct tty_struct *tty)
+static void klsi_105_unthrottle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	int result;
@@ -962,7 +949,7 @@ static void klsi_105_unthrottle (struct tty_struct *tty)
 
 
 
-static int __init klsi_105_init (void)
+static int __init klsi_105_init(void)
 {
 	int retval;
 	retval = usb_serial_register(&kl5kusb105d_device);
@@ -981,19 +968,19 @@ failed_usb_serial_register:
 }
 
 
-static void __exit klsi_105_exit (void)
+static void __exit klsi_105_exit(void)
 {
-	usb_deregister (&kl5kusb105d_driver);
-	usb_serial_deregister (&kl5kusb105d_device);
+	usb_deregister(&kl5kusb105d_driver);
+	usb_serial_deregister(&kl5kusb105d_device);
 }
 
 
-module_init (klsi_105_init);
-module_exit (klsi_105_exit);
+module_init(klsi_105_init);
+module_exit(klsi_105_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
-MODULE_LICENSE("GPL"); 
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
 
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);

