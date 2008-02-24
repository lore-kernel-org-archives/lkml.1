Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYBXKl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYBXKl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 05:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYBXKlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 05:41:16 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:12691 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYBXKlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 05:41:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qNtwmkBZoOSfiYxEE18dQ0+S700wADo/hF7ZrnsUfvBkGP4MOwaDzBV+TjNj2O76fq50iucFuP4CFqlh25vaij4Myz4tocB1B7usK72siMhWL/n7Kv49CfoptxzWQQZ1PLC8PZDz03YkDqTJPvU93DDEc8NRwW3WejOlyliqw5w=
From: Ming Lei <tom.leiming@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, lm_tom@163.com,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] USB: remove unnecessary type casting of urb->context
Date: Sun, 24 Feb 2008 18:41:47 +0800
Message-Id: <1203849707-4019-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.5.4.3.192.g923d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

urb->context code cleanup

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/usb/atm/cxacru.c              |    2 +-
 drivers/usb/class/cdc-acm.c           |    2 +-
 drivers/usb/misc/auerswald.c          |   12 ++++++------
 drivers/usb/misc/ftdi-elan.c          |    2 +-
 drivers/usb/misc/iowarrior.c          |    4 ++--
 drivers/usb/misc/legousbtower.c       |    4 ++--
 drivers/usb/misc/usblcd.c             |    2 +-
 drivers/usb/misc/usbtest.c            |    4 ++--
 drivers/usb/serial/belkin_sa.c        |    2 +-
 drivers/usb/serial/cyberjack.c        |    6 +++---
 drivers/usb/serial/cypress_m8.c       |    4 ++--
 drivers/usb/serial/digi_acceleport.c  |    8 ++++----
 drivers/usb/serial/empeg.c            |    2 +-
 drivers/usb/serial/ftdi_sio.c         |    4 ++--
 drivers/usb/serial/garmin_gps.c       |    6 +++---
 drivers/usb/serial/generic.c          |    4 ++--
 drivers/usb/serial/io_edgeport.c      |    8 ++++----
 drivers/usb/serial/io_ti.c            |    6 +++---
 drivers/usb/serial/ipaq.c             |    4 ++--
 drivers/usb/serial/ir-usb.c           |    4 ++--
 drivers/usb/serial/iuu_phoenix.c      |   16 ++++++++--------
 drivers/usb/serial/keyspan.c          |   28 ++++++++++++++--------------
 drivers/usb/serial/keyspan_pda.c      |    4 ++--
 drivers/usb/serial/kl5kusb105.c       |    4 ++--
 drivers/usb/serial/mct_u232.c         |    2 +-
 drivers/usb/serial/mos7840.c          |    8 ++++----
 drivers/usb/serial/omninet.c          |    4 ++--
 drivers/usb/serial/option.c           |    6 +++---
 drivers/usb/serial/oti6858.c          |    6 +++---
 drivers/usb/serial/pl2303.c           |    6 +++---
 drivers/usb/serial/safe_serial.c      |    2 +-
 drivers/usb/serial/sierra.c           |    4 ++--
 drivers/usb/serial/ti_usb_3410_5052.c |    6 +++---
 drivers/usb/serial/visor.c            |    6 +++---
 drivers/usb/serial/whiteheat.c        |    6 +++---
 drivers/usb/storage/transport.c       |    2 +-
 drivers/usb/usb-skeleton.c            |    2 +-
 37 files changed, 101 insertions(+), 101 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index a51eeed..d470c72 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -444,7 +444,7 @@ CXACRU_ALL_FILES(INIT);
 /* the following three functions are stolen from drivers/usb/core/message.c */
 static void cxacru_blocking_completion(struct urb *urb)
 {
-	complete((struct completion *)urb->context);
+	complete(urb->context);
 }
 
 static void cxacru_timeout_kill(unsigned long data)
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index bcc4213..705c471 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -450,7 +450,7 @@ urbs:
 /* data interface wrote those outgoing bytes */
 static void acm_write_bulk(struct urb *urb)
 {
-	struct acm *acm = (struct acm *)urb->context;
+	struct acm *acm = urb->context;
 
 	dbg("Entering acm_write_bulk with status %d", urb->status);
 
diff --git a/drivers/usb/misc/auerswald.c b/drivers/usb/misc/auerswald.c
index df7e1ec..920f561 100644
--- a/drivers/usb/misc/auerswald.c
+++ b/drivers/usb/misc/auerswald.c
@@ -283,7 +283,7 @@ static void auerchain_complete (struct urb * urb)
         int result;
 
         /* get pointer to element and to chain */
-        pauerchainelement_t acep = (pauerchainelement_t) urb->context;
+        pauerchainelement_t acep =  urb->context;
         pauerchain_t         acp = acep->chain;
 
         /* restore original entries in urb */
@@ -593,7 +593,7 @@ ac_fail:/* free the elements */
 /* completion handler for synchronous chained URBs */
 static void auerchain_blocking_completion (struct urb *urb)
 {
-	pauerchain_chs_t pchs = (pauerchain_chs_t)urb->context;
+	pauerchain_chs_t pchs = urb->context;
 	pchs->done = 1;
 	wmb();
 	wake_up (&pchs->wqh);
@@ -846,7 +846,7 @@ static int auerswald_status_retry (int status)
 /* Completion of asynchronous write block */
 static void auerchar_ctrlwrite_complete (struct urb * urb)
 {
-	pauerbuf_t bp = (pauerbuf_t) urb->context;
+	pauerbuf_t bp =  urb->context;
 	pauerswald_t cp = ((pauerswald_t)((char *)(bp->list)-(unsigned long)(&((pauerswald_t)0)->bufctl)));
 	dbg ("auerchar_ctrlwrite_complete called");
 
@@ -859,7 +859,7 @@ static void auerchar_ctrlwrite_complete (struct urb * urb)
 /* Completion handler for dummy retry packet */
 static void auerswald_ctrlread_wretcomplete (struct urb * urb)
 {
-        pauerbuf_t bp = (pauerbuf_t) urb->context;
+        pauerbuf_t bp =  urb->context;
         pauerswald_t cp;
 	int ret;
 	int status = urb->status;
@@ -903,7 +903,7 @@ static void auerswald_ctrlread_complete (struct urb * urb)
         unsigned int  serviceid;
         pauerswald_t  cp;
         pauerscon_t   scp;
-        pauerbuf_t    bp  = (pauerbuf_t) urb->context;
+        pauerbuf_t    bp  =  urb->context;
 	int status = urb->status;
 	int ret;
 
@@ -980,7 +980,7 @@ static void auerswald_int_complete (struct urb * urb)
         int ret;
 	int status = urb->status;
         pauerbuf_t   bp = NULL;
-        pauerswald_t cp = (pauerswald_t) urb->context;
+        pauerswald_t cp =  urb->context;
 
         dbg ("%s called", __FUNCTION__);
 
diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 148b7fe..13c0930 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -746,7 +746,7 @@ static ssize_t ftdi_elan_read(struct file *file, char __user *buffer,
 
 static void ftdi_elan_write_bulk_callback(struct urb *urb)
 {
-        struct usb_ftdi *ftdi = (struct usb_ftdi *)urb->context;
+        struct usb_ftdi *ftdi = urb->context;
 	int status = urb->status;
 
 	if (status && !(status == -ENOENT || status == -ECONNRESET ||
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 8010705..6ece2af 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -154,7 +154,7 @@ MODULE_DEVICE_TABLE(usb, iowarrior_ids);
  */
 static void iowarrior_callback(struct urb *urb)
 {
-	struct iowarrior *dev = (struct iowarrior *)urb->context;
+	struct iowarrior *dev = urb->context;
 	int intr_idx;
 	int read_idx;
 	int aux_idx;
@@ -230,7 +230,7 @@ static void iowarrior_write_callback(struct urb *urb)
 	struct iowarrior *dev;
 	int status = urb->status;
 
-	dev = (struct iowarrior *)urb->context;
+	dev = urb->context;
 	/* sync/async unlink faults aren't errors */
 	if (status &&
 	    !(status == -ENOENT ||
diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index 6664043..f74b22b 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -753,7 +753,7 @@ exit:
  */
 static void tower_interrupt_in_callback (struct urb *urb)
 {
-	struct lego_usb_tower *dev = (struct lego_usb_tower *)urb->context;
+	struct lego_usb_tower *dev = urb->context;
 	int status = urb->status;
 	int retval;
 
@@ -810,7 +810,7 @@ exit:
  */
 static void tower_interrupt_out_callback (struct urb *urb)
 {
-	struct lego_usb_tower *dev = (struct lego_usb_tower *)urb->context;
+	struct lego_usb_tower *dev = urb->context;
 	int status = urb->status;
 
 	dbg(4, "%s: enter, status %d", __FUNCTION__, status);
diff --git a/drivers/usb/misc/usblcd.c b/drivers/usb/misc/usblcd.c
index 20777d0..2704eef 100644
--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -185,7 +185,7 @@ static void lcd_write_bulk_callback(struct urb *urb)
 	struct usb_lcd *dev;
 	int status = urb->status;
 
-	dev = (struct usb_lcd *)urb->context;
+	dev = urb->context;
 
 	/* sync/async unlink faults aren't errors */
 	if (status &&
diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index da922df..f94bdec 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -201,7 +201,7 @@ found:
 
 static void simple_callback (struct urb *urb)
 {
-	complete ((struct completion *) urb->context);
+	complete (urb->context);
 }
 
 static struct urb *simple_alloc_urb (
@@ -1045,7 +1045,7 @@ static void unlink1_callback (struct urb *urb)
 		status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status) {
 		urb->status = status;
-		complete ((struct completion *) urb->context);
+		complete (urb->context);
 	}
 }
 
diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index df0a2b3..335fb1f 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -251,7 +251,7 @@ static void belkin_sa_close (struct usb_serial_port *port, struct file *filp)
 
 static void belkin_sa_read_int_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct belkin_sa_private *priv;
 	unsigned char *data = urb->transfer_buffer;
 	int retval;
diff --git a/drivers/usb/serial/cyberjack.c b/drivers/usb/serial/cyberjack.c
index 8d9b045..44bb91d 100644
--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -302,7 +302,7 @@ static int cyberjack_write_room( struct usb_serial_port *port )
 
 static void cyberjack_read_int_callback( struct urb *urb )
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct cyberjack_private *priv = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
@@ -359,7 +359,7 @@ resubmit:
 
 static void cyberjack_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct cyberjack_private *priv = usb_get_serial_port_data(port);
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
@@ -411,7 +411,7 @@ static void cyberjack_read_bulk_callback (struct urb *urb)
 
 static void cyberjack_write_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct cyberjack_private *priv = usb_get_serial_port_data(port);
 	int status = urb->status;
 
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 08c65c1..3503188 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -1272,7 +1272,7 @@ static void cypress_unthrottle (struct usb_serial_port *port)
 
 static void cypress_read_int_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
@@ -1424,7 +1424,7 @@ continue_read:
 
 static void cypress_write_int_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	int result;
 	int status = urb->status;
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 5f9c6e4..204b071 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -1233,7 +1233,7 @@ static int digi_write(struct usb_serial_port *port, const unsigned char *buf, in
 static void digi_write_bulk_callback(struct urb *urb)
 {
 
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial;
 	struct digi_port *priv;
 	struct digi_serial *serial_priv;
@@ -1611,7 +1611,7 @@ static void digi_shutdown(struct usb_serial *serial)
 
 static void digi_read_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct digi_port *priv;
 	struct digi_serial *serial_priv;
 	int ret;
@@ -1670,7 +1670,7 @@ static void digi_read_bulk_callback(struct urb *urb)
 static int digi_read_inb_callback(struct urb *urb)
 {
 
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty = port->tty;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	int opcode = ((unsigned char *)urb->transfer_buffer)[0];
@@ -1760,7 +1760,7 @@ static int digi_read_inb_callback(struct urb *urb)
 static int digi_read_oob_callback(struct urb *urb)
 {
 
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial = port->serial;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	int opcode, line, status, val;
diff --git a/drivers/usb/serial/empeg.c b/drivers/usb/serial/empeg.c
index a5c8e1e..090b8d5 100644
--- a/drivers/usb/serial/empeg.c
+++ b/drivers/usb/serial/empeg.c
@@ -343,7 +343,7 @@ static void empeg_write_bulk_callback (struct urb *urb)
 
 static void empeg_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int result;
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 90dcc62..bc63a75 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1354,7 +1354,7 @@ error_no_buffer:
 static void ftdi_write_bulk_callback (struct urb *urb)
 {
 	unsigned long flags;
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct ftdi_private *priv;
 	int data_offset;       /* will be 1 for the SIO and 0 otherwise */
 	unsigned long countback;
@@ -1437,7 +1437,7 @@ static int ftdi_chars_in_buffer (struct usb_serial_port *port)
 
 static void ftdi_read_bulk_callback (struct urb *urb)
 { /* ftdi_read_bulk_callback */
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty;
 	struct ftdi_private *priv;
 	unsigned long countread;
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index d74e43d..fac4ec5 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -1046,7 +1046,7 @@ static void garmin_close (struct usb_serial_port *port, struct file * filp)
 static void garmin_write_bulk_callback (struct urb *urb)
 {
 	unsigned long flags;
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
 
 	if (port) {
@@ -1286,7 +1286,7 @@ static void garmin_read_process(struct garmin_data * garmin_data_p,
 static void garmin_read_bulk_callback (struct urb *urb)
 {
 	unsigned long flags;
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial =  port->serial;
 	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
@@ -1344,7 +1344,7 @@ static void garmin_read_int_callback (struct urb *urb)
 {
 	unsigned long flags;
 	int retval;
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial = port->serial;
 	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 97fa3c4..9fcc11b 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -332,7 +332,7 @@ static void flush_and_resubmit_read_urb (struct usb_serial_port *port)
 
 void usb_serial_generic_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
 	unsigned long flags;
@@ -358,7 +358,7 @@ EXPORT_SYMBOL_GPL(usb_serial_generic_read_bulk_callback);
 
 void usb_serial_generic_write_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 3428ccc..6e4fd45 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -589,7 +589,7 @@ static int get_epic_descriptor(struct edgeport_serial *ep)
  *****************************************************************************/
 static void edge_interrupt_callback (struct urb *urb)
 {
-	struct edgeport_serial	*edge_serial = (struct edgeport_serial *)urb->context;
+	struct edgeport_serial	*edge_serial = urb->context;
 	struct edgeport_port *edge_port;
 	struct usb_serial_port *port;
 	unsigned char *data = urb->transfer_buffer;
@@ -689,7 +689,7 @@ exit:
  *****************************************************************************/
 static void edge_bulk_in_callback (struct urb *urb)
 {
-	struct edgeport_serial	*edge_serial = (struct edgeport_serial *)urb->context;
+	struct edgeport_serial	*edge_serial = urb->context;
 	unsigned char		*data = urb->transfer_buffer;
 	int			retval;
 	__u16			raw_data_length;
@@ -749,7 +749,7 @@ static void edge_bulk_in_callback (struct urb *urb)
  *****************************************************************************/
 static void edge_bulk_out_data_callback (struct urb *urb)
 {
-	struct edgeport_port *edge_port = (struct edgeport_port *)urb->context;
+	struct edgeport_port *edge_port = urb->context;
 	struct tty_struct *tty;
 	int status = urb->status;
 
@@ -782,7 +782,7 @@ static void edge_bulk_out_data_callback (struct urb *urb)
  *****************************************************************************/
 static void edge_bulk_out_cmd_callback (struct urb *urb)
 {
-	struct edgeport_port *edge_port = (struct edgeport_port *)urb->context;
+	struct edgeport_port *edge_port = urb->context;
 	struct tty_struct *tty;
 	int status = urb->status;
 
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index cd34059..f298e12 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -1713,7 +1713,7 @@ static void handle_new_lsr (struct edgeport_port *edge_port, int lsr_data, __u8
 
 static void edge_interrupt_callback (struct urb *urb)
 {
-	struct edgeport_serial *edge_serial = (struct edgeport_serial *)urb->context;
+	struct edgeport_serial *edge_serial = urb->context;
 	struct usb_serial_port *port;
 	struct edgeport_port *edge_port;
 	unsigned char *data = urb->transfer_buffer;
@@ -1806,7 +1806,7 @@ exit:
 
 static void edge_bulk_in_callback (struct urb *urb)
 {
-	struct edgeport_port *edge_port = (struct edgeport_port *)urb->context;
+	struct edgeport_port *edge_port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	struct tty_struct *tty;
 	int retval = 0;
@@ -1900,7 +1900,7 @@ static void edge_tty_recv(struct device *dev, struct tty_struct *tty, unsigned c
 
 static void edge_bulk_out_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	int status = urb->status;
 
diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
index 9b38a08..1693469 100644
--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -732,7 +732,7 @@ static void ipaq_close(struct usb_serial_port *port, struct file *filp)
 
 static void ipaq_read_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port	*port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port	*port = urb->context;
 	struct tty_struct	*tty;
 	unsigned char		*data = urb->transfer_buffer;
 	int			result;
@@ -872,7 +872,7 @@ static void ipaq_write_gather(struct usb_serial_port *port)
 
 static void ipaq_write_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port	*port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port	*port = urb->context;
 	struct ipaq_private	*priv = usb_get_serial_port_data(port);
 	unsigned long		flags;
 	int			result;
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index 6b803ab..c5dba5c 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -396,7 +396,7 @@ static int ir_write (struct usb_serial_port *port, const unsigned char *buf, int
 
 static void ir_write_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
@@ -420,7 +420,7 @@ static void ir_write_bulk_callback (struct urb *urb)
 
 static void ir_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int result;
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index fde188e..bb9a3c1 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -178,7 +178,7 @@ static int iuu_tiocmget(struct usb_serial_port *port, struct file *file)
 
 static void iuu_rxcmd(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int result;
 	dbg("%s - enter", __FUNCTION__);
 
@@ -232,7 +232,7 @@ static int iuu_reset(struct usb_serial_port *port, u8 wt)
  */
 static void iuu_update_status_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
 	u8 *st;
 	dbg("%s - enter", __FUNCTION__);
@@ -262,7 +262,7 @@ static void iuu_update_status_callback(struct urb *urb)
 
 static void iuu_status_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int result;
 	dbg("%s - enter", __FUNCTION__);
 
@@ -384,7 +384,7 @@ static void iuu_rgbf_fill_buffer(u8 *buf, u8 r1, u8 r2, u8 g1, u8 g2, u8 b1,
 
 static void iuu_led_activity_on(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int result;
 	char *buf_ptr = port->write_urb->transfer_buffer;
 	*buf_ptr++ = IUU_SET_LED;
@@ -405,7 +405,7 @@ static void iuu_led_activity_on(struct urb *urb)
 
 static void iuu_led_activity_off(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int result;
 	char *buf_ptr = port->write_urb->transfer_buffer;
 	if (xmas == 1) {
@@ -608,7 +608,7 @@ static int iuu_uart_flush(struct usb_serial_port *port)
 
 static void read_buf_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	struct tty_struct *tty;
 	dbg("%s - urb->status = %d", __FUNCTION__, urb->status);
@@ -684,7 +684,7 @@ static int iuu_read_buf(struct usb_serial_port *port, int len)
 
 static void iuu_uart_read_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
 	unsigned int flags;
 	int status;
@@ -773,7 +773,7 @@ static int iuu_uart_write(struct usb_serial_port *port, const u8 *buf,
 
 static void read_rxcmd_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int result;
 	dbg("%s - enter", __FUNCTION__);
 
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index ea7bba6..b2dfe38 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -445,7 +445,7 @@ static void	usa26_indat_callback(struct urb *urb)
 		return;
 	}
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	tty = port->tty;
 	if (tty && urb->actual_length) {
 		/* 0x80 bit is error flag */
@@ -490,7 +490,7 @@ static void	usa2x_outdat_callback(struct urb *urb)
 	struct usb_serial_port *port;
 	struct keyspan_port_private *p_priv;
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 	dbg ("%s - urb %d", __FUNCTION__, urb == p_priv->out_urbs[1]); 
 
@@ -509,7 +509,7 @@ static void	usa26_outcont_callback(struct urb *urb)
 	struct usb_serial_port *port;
 	struct keyspan_port_private *p_priv;
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 
 	if (p_priv->resend_cont) {
@@ -528,7 +528,7 @@ static void	usa26_instat_callback(struct urb *urb)
 	int old_dcd_state, err;
 	int status = urb->status;
 
-	serial = (struct usb_serial *) urb->context;
+	serial =  urb->context;
 
 	if (status) {
 		dbg("%s - nonzero status: %x", __FUNCTION__, status);
@@ -599,7 +599,7 @@ static void usa28_indat_callback(struct urb *urb)
 
 	dbg ("%s", __FUNCTION__);
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 	data = urb->transfer_buffer;
 
@@ -613,7 +613,7 @@ static void usa28_indat_callback(struct urb *urb)
 			return;
 		}
 
-		port = (struct usb_serial_port *) urb->context;
+		port =  urb->context;
 		p_priv = usb_get_serial_port_data(port);
 		data = urb->transfer_buffer;
 
@@ -647,7 +647,7 @@ static void	usa28_outcont_callback(struct urb *urb)
 	struct usb_serial_port *port;
 	struct keyspan_port_private *p_priv;
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 
 	if (p_priv->resend_cont) {
@@ -667,7 +667,7 @@ static void	usa28_instat_callback(struct urb *urb)
 	int old_dcd_state;
 	int status = urb->status;
 
-	serial = (struct usb_serial *) urb->context;
+	serial =  urb->context;
 
 	if (status) {
 		dbg("%s - nonzero status: %x", __FUNCTION__, status);
@@ -733,7 +733,7 @@ static void	usa49_glocont_callback(struct urb *urb)
 
 	dbg ("%s", __FUNCTION__);
 
-	serial = (struct usb_serial *) urb->context;
+	serial =  urb->context;
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		p_priv = usb_get_serial_port_data(port);
@@ -761,7 +761,7 @@ static void	usa49_instat_callback(struct urb *urb)
 
 	dbg ("%s", __FUNCTION__);
 
-	serial = (struct usb_serial *) urb->context;
+	serial =  urb->context;
 
 	if (status) {
 		dbg("%s - nonzero status: %x", __FUNCTION__, status);
@@ -836,7 +836,7 @@ static void	usa49_indat_callback(struct urb *urb)
 		return;
 	}
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	tty = port->tty;
 	if (tty && urb->actual_length) {
 		/* 0x80 bit is error flag */
@@ -973,7 +973,7 @@ static void usa90_indat_callback(struct urb *urb)
 		return;
 	}
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 
 	tty = port->tty;
@@ -1037,7 +1037,7 @@ static void	usa90_instat_callback(struct urb *urb)
 	int old_dcd_state, err;
 	int status = urb->status;
 
-	serial = (struct usb_serial *) urb->context;
+	serial =  urb->context;
 
 	if (status) {
 		dbg("%s - nonzero status: %x", __FUNCTION__, status);
@@ -1084,7 +1084,7 @@ static void	usa90_outcont_callback(struct urb *urb)
 	struct usb_serial_port *port;
 	struct keyspan_port_private *p_priv;
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 
 	if (p_priv->resend_cont) {
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index b1fa5a3..3ff8a86 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -214,7 +214,7 @@ static void keyspan_pda_request_unthrottle(struct work_struct *work)
 
 static void keyspan_pda_rx_interrupt (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
        	struct tty_struct *tty = port->tty;
 	unsigned char *data = urb->transfer_buffer;
 	int i;
@@ -608,7 +608,7 @@ exit:
 
 static void keyspan_pda_write_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct keyspan_pda_private *priv;
 
 	port->write_urb_busy = 0;
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index 55736df..417fd3b 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -570,7 +570,7 @@ exit:
 
 static void klsi_105_write_bulk_callback ( struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
@@ -631,7 +631,7 @@ static int klsi_105_write_room (struct usb_serial_port *port)
 
 static void klsi_105_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index fc1cea4..372a5c0 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -517,7 +517,7 @@ static void mct_u232_close (struct usb_serial_port *port, struct file *filp)
 
 static void mct_u232_read_int_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	struct usb_serial *serial = port->serial;
 	struct tty_struct *tty;
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 869ecd3..507f724 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -436,7 +436,7 @@ static void mos7840_control_callback(struct urb *urb)
 	int result = 0;
 	int status = urb->status;
 
-	mos7840_port = (struct moschip_port *)urb->context;
+	mos7840_port = urb->context;
 
 	switch (status) {
 	case 0:
@@ -541,7 +541,7 @@ static void mos7840_interrupt_callback(struct urb *urb)
 	length = urb->actual_length;
 	data = urb->transfer_buffer;
 
-	serial = (struct usb_serial *)urb->context;
+	serial = urb->context;
 
 	/* Moschip get 5 bytes
 	 * Byte 1 IIR Port 1 (port.number is 0)
@@ -672,7 +672,7 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 		return;
 	}
 
-	mos7840_port = (struct moschip_port *)urb->context;
+	mos7840_port = urb->context;
 	if (!mos7840_port) {
 		dbg("%s", "NULL mos7840_port pointer \n");
 		return;
@@ -739,7 +739,7 @@ static void mos7840_bulk_out_data_callback(struct urb *urb)
 	int status = urb->status;
 	int i;
 
-	mos7840_port = (struct moschip_port *)urb->context;
+	mos7840_port = urb->context;
 	spin_lock(&mos7840_port->pool_lock);
 	for (i = 0; i < NUM_URBS; i++) {
 		if (urb == mos7840_port->write_urb_pool[i]) {
diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
index ee94d96..649bda1 100644
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -197,7 +197,7 @@ static void omninet_close (struct usb_serial_port *port, struct file * filp)
 
 static void omninet_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port 	*port 	= (struct usb_serial_port *)urb->context;
+	struct usb_serial_port 	*port 	= urb->context;
 	unsigned char 		*data 	= urb->transfer_buffer;
 	struct omninet_header 	*header = (struct omninet_header *) &data[0];
 	int status = urb->status;
@@ -311,7 +311,7 @@ static int omninet_write_room (struct usb_serial_port *port)
 static void omninet_write_bulk_callback (struct urb *urb)
 {
 /*	struct omninet_header	*header = (struct omninet_header  *) urb->transfer_buffer; */
-	struct usb_serial_port 	*port   = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port 	*port   =  urb->context;
 	int status = urb->status;
 
 	dbg("%s - port %0x\n", __FUNCTION__, port->number);
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 5e8bf1b..3d10e84 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -432,7 +432,7 @@ static void option_indat_callback(struct urb *urb)
 	dbg("%s: %p", __FUNCTION__, urb);
 
 	endpoint = usb_pipeendpoint(urb->pipe);
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 
 	if (status) {
 		dbg("%s: nonzero status: %d on endpoint %02x.",
@@ -466,7 +466,7 @@ static void option_outdat_callback(struct urb *urb)
 
 	dbg("%s", __FUNCTION__);
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 
 	usb_serial_port_softint(port);
 
@@ -484,7 +484,7 @@ static void option_instat_callback(struct urb *urb)
 {
 	int err;
 	int status = urb->status;
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct option_port_private *portdata = usb_get_serial_port_data(port);
 	struct usb_serial *serial = port->serial;
 
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index a3847d6..ed16066 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -878,7 +878,7 @@ static void oti6858_shutdown(struct usb_serial *serial)
 
 static void oti6858_read_int_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	int transient = 0, can_recv = 0, resubmit = 1;
 	int status = urb->status;
@@ -992,7 +992,7 @@ static void oti6858_read_int_callback(struct urb *urb)
 
 static void oti6858_read_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
@@ -1045,7 +1045,7 @@ static void oti6858_read_bulk_callback(struct urb *urb)
 
 static void oti6858_write_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	int status = urb->status;
 	int result;
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index ae3ec1a..497e648 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -942,7 +942,7 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 
 static void pl2303_read_int_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned int actual_length = urb->actual_length;
 	int status = urb->status;
@@ -982,7 +982,7 @@ exit:
 
 static void pl2303_read_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
@@ -1065,7 +1065,7 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 
 static void pl2303_write_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	int result;
 	int status = urb->status;
diff --git a/drivers/usb/serial/safe_serial.c b/drivers/usb/serial/safe_serial.c
index 4e6dcc1..e07b44f 100644
--- a/drivers/usb/serial/safe_serial.c
+++ b/drivers/usb/serial/safe_serial.c
@@ -195,7 +195,7 @@ static __u16 __inline__ fcs_compute10 (unsigned char *sp, int len, __u16 fcs)
 
 static void safe_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned char length = urb->actual_length;
 	int i;
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 4c925e3..f5f45db 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -417,7 +417,7 @@ static void sierra_indat_callback(struct urb *urb)
 	dbg("%s: %p", __FUNCTION__, urb);
 
 	endpoint = usb_pipeendpoint(urb->pipe);
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 
 	if (status) {
 		dbg("%s: nonzero status: %d on endpoint %02x.",
@@ -447,7 +447,7 @@ static void sierra_instat_callback(struct urb *urb)
 {
 	int err;
 	int status = urb->status;
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
 	struct usb_serial *serial = port->serial;
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index b517f93..1bcbaac 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1099,7 +1099,7 @@ static void ti_break(struct usb_serial_port *port, int break_state)
 
 static void ti_interrupt_callback(struct urb *urb)
 {
-	struct ti_device *tdev = (struct ti_device *)urb->context;
+	struct ti_device *tdev = urb->context;
 	struct usb_serial_port *port;
 	struct usb_serial *serial = tdev->td_serial;
 	struct ti_port *tport;
@@ -1182,7 +1182,7 @@ exit:
 
 static void ti_bulk_in_callback(struct urb *urb)
 {
-	struct ti_port *tport = (struct ti_port *)urb->context;
+	struct ti_port *tport = urb->context;
 	struct usb_serial_port *port = tport->tp_port;
 	struct device *dev = &urb->dev->dev;
 	int status = urb->status;
@@ -1248,7 +1248,7 @@ exit:
 
 static void ti_bulk_out_callback(struct urb *urb)
 {
-	struct ti_port *tport = (struct ti_port *)urb->context;
+	struct ti_port *tport = urb->context;
 	struct usb_serial_port *port = tport->tp_port;
 	struct device *dev = &urb->dev->dev;
 	int status = urb->status;
diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 22b3f78..cbe2526 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -485,7 +485,7 @@ static int visor_chars_in_buffer (struct usb_serial_port *port)
 
 static void visor_write_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct visor_private *priv = usb_get_serial_port_data(port);
 	int status = urb->status;
 	unsigned long flags;
@@ -509,7 +509,7 @@ static void visor_write_bulk_callback (struct urb *urb)
 
 static void visor_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct visor_private *priv = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
@@ -560,7 +560,7 @@ static void visor_read_bulk_callback (struct urb *urb)
 
 static void visor_read_int_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
 	int result;
 
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 38726ef..fe0535a 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -971,7 +971,7 @@ static void command_port_write_callback(struct urb *urb)
 
 static void command_port_read_callback(struct urb *urb)
 {
-	struct usb_serial_port *command_port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *command_port = urb->context;
 	struct whiteheat_command_private *command_info;
 	int status = urb->status;
 	unsigned char *data = urb->transfer_buffer;
@@ -1021,7 +1021,7 @@ static void command_port_read_callback(struct urb *urb)
 
 static void whiteheat_read_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct whiteheat_urb_wrap *wrap;
 	unsigned char *data = urb->transfer_buffer;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
@@ -1065,7 +1065,7 @@ static void whiteheat_read_callback(struct urb *urb)
 
 static void whiteheat_write_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
 	struct whiteheat_urb_wrap *wrap;
 	int status = urb->status;
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index d9f4912..7a5c34a 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -110,7 +110,7 @@
  */
 static void usb_stor_blocking_completion(struct urb *urb)
 {
-	struct completion *urb_done_ptr = (struct completion *)urb->context;
+	struct completion *urb_done_ptr = urb->context;
 
 	complete(urb_done_ptr);
 }
diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index c815a40..3f33077 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -212,7 +212,7 @@ static void skel_write_bulk_callback(struct urb *urb)
 {
 	struct usb_skel *dev;
 
-	dev = (struct usb_skel *)urb->context;
+	dev = urb->context;
 
 	/* sync/async unlink faults aren't errors */
 	if (urb->status) {
-- 
1.5.4.3.192.g923d4

