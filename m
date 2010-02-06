Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab0BFAuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 19:50:12 -0500
Received: from mail.perches.com ([173.55.12.10]:1867 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab0BFAuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 19:50:09 -0500
Subject: [PATCH] drivers/usb/serial: Remove unnecessary \n's from dbg uses
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 16:50:08 -0800
Message-ID: <1265417408.10226.53.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#define dbg adds the newline, messages shouldn't.
Converted dbg("%s", "some string") to dbg("some string")
 
Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/serial/cp210x.c      |    2 +-
 drivers/usb/serial/cyberjack.c   |    2 +-
 drivers/usb/serial/ftdi_sio.c    |    2 +-
 drivers/usb/serial/generic.c     |    2 +-
 drivers/usb/serial/io_edgeport.c |    8 ++++----
 drivers/usb/serial/io_ti.c       |    2 +-
 drivers/usb/serial/mos7720.c     |   14 +++++++-------
 drivers/usb/serial/omninet.c     |    2 +-
 drivers/usb/serial/opticon.c     |    4 ++--
 drivers/usb/serial/option.c      |    4 ++--
 drivers/usb/serial/spcp8x5.c     |    2 +-
 drivers/usb/serial/visor.c       |    4 ++--
 12 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index bd254ec..1db281e 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -612,7 +612,7 @@ static void cp210x_set_termios(struct tty_struct *tty,
 				baud);
 		if (cp210x_set_config_single(port, CP210X_SET_BAUDDIV,
 					((BAUD_RATE_GEN_FREQ + baud/2) / baud))) {
-			dbg("Baud rate requested not supported by device\n");
+			dbg("Baud rate requested not supported by device");
 			baud = tty_termios_baud_rate(old_termios);
 		}
 	}
diff --git a/drivers/usb/serial/cyberjack.c b/drivers/usb/serial/cyberjack.c
index b0f6402..5870f88 100644
--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -391,7 +391,7 @@ static void cyberjack_read_bulk_callback(struct urb *urb)
 
 	tty = tty_port_tty_get(&port->port);
 	if (!tty) {
-		dbg("%s - ignoring since device not open\n", __func__);
+		dbg("%s - ignoring since device not open", __func__);
 		return;
 	}
 	if (urb->actual_length) {
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 216f187..35ef834 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1828,7 +1828,7 @@ static int ftdi_write(struct tty_struct *tty, struct usb_serial_port *port,
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	if (priv->tx_outstanding_urbs > URB_UPPER_LIMIT) {
 		spin_unlock_irqrestore(&priv->tx_lock, flags);
-		dbg("%s - write limit hit\n", __func__);
+		dbg("%s - write limit hit", __func__);
 		return 0;
 	}
 	priv->tx_outstanding_urbs++;
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 83443d6..f4e7dd0 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -194,7 +194,7 @@ static int usb_serial_multi_urb_write(struct tty_struct *tty,
 		if (port->urbs_in_flight >
 		    port->serial->type->max_in_flight_urbs) {
 			spin_unlock_irqrestore(&port->lock, flags);
-			dbg("%s - write limit hit\n", __func__);
+			dbg("%s - write limit hit", __func__);
 			return bwrite;
 		}
 		port->tx_bytes_flight += towrite;
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index b97960a..18fcb43 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -2007,7 +2007,7 @@ static void process_rcvd_status(struct edgeport_serial *edge_serial,
 			return;
 
 		case IOSP_EXT_STATUS_RX_CHECK_RSP:
-			dbg("%s ========== Port %u CHECK_RSP Sequence = %02x =============\n", __func__, edge_serial->rxPort, byte3);
+			dbg("%s ========== Port %u CHECK_RSP Sequence = %02x =============", __func__, edge_serial->rxPort, byte3);
 			/* Port->RxCheckRsp = true; */
 			return;
 		}
@@ -2075,7 +2075,7 @@ static void process_rcvd_status(struct edgeport_serial *edge_serial,
 		break;
 
 	default:
-		dbg("%s - Unrecognized IOSP status code %u\n", __func__, code);
+		dbg("%s - Unrecognized IOSP status code %u", __func__, code);
 		break;
 	}
 	return;
@@ -2530,7 +2530,7 @@ static int calc_baud_rate_divisor(int baudrate, int *divisor)
 
 		*divisor = custom;
 
-		dbg("%s - Baud %d = %d\n", __func__, baudrate, custom);
+		dbg("%s - Baud %d = %d", __func__, baudrate, custom);
 		return 0;
 	}
 
@@ -2915,7 +2915,7 @@ static void load_application_firmware(struct edgeport_serial *edge_serial)
 			break;
 
 		case EDGE_DOWNLOAD_FILE_NONE:
-			dbg     ("No download file specified, skipping download\n");
+			dbg("No download file specified, skipping download");
 			return;
 
 		default:
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index d4cc0f7..86c55be 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -1686,7 +1686,7 @@ static void edge_interrupt_callback(struct urb *urb)
 	case TIUMP_INTERRUPT_CODE_MSR:	/* MSR */
 		/* Copy MSR from UMP */
 		msr = data[1];
-		dbg("%s - ===== Port %u MSR Status = %02x ======\n",
+		dbg("%s - ===== Port %u MSR Status = %02x ======",
 		     __func__, port_number, msr);
 		handle_new_msr(edge_port, msr);
 		break;
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 763e32a..95db705 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -106,7 +106,7 @@ static void mos7720_interrupt_callback(struct urb *urb)
 	__u8 sp1;
 	__u8 sp2;
 
-	dbg("%s", " : Entering\n");
+	dbg(" : Entering");
 
 	switch (status) {
 	case 0:
@@ -206,7 +206,7 @@ static void mos7720_bulk_in_callback(struct urb *urb)
 
 	mos7720_port = urb->context;
 	if (!mos7720_port) {
-		dbg("%s", "NULL mos7720_port pointer \n");
+		dbg("NULL mos7720_port pointer");
 		return ;
 	}
 
@@ -314,7 +314,7 @@ static int send_mos_cmd(struct usb_serial *serial, __u8 request, __u16 value,
 				 value, index, data, size, MOS_WDR_TIMEOUT);
 
 	if (status < 0)
-		dbg("Command Write failed Value %x index %x\n", value, index);
+		dbg("Command Write failed Value %x index %x", value, index);
 
 	return status;
 }
@@ -390,7 +390,7 @@ static int mos7720_open(struct tty_struct *tty, struct usb_serial_port *port)
 	  */
 	port_number = port->number - port->serial->minor;
 	send_mos_cmd(port->serial, MOS_READ, port_number, UART_LSR, &data);
-	dbg("SS::%p LSR:%x\n", mos7720_port, data);
+	dbg("SS::%p LSR:%x", mos7720_port, data);
 
 	dbg("Check:Sending Command ..........");
 
@@ -729,7 +729,7 @@ static void mos7720_throttle(struct tty_struct *tty)
 	struct moschip_port *mos7720_port;
 	int status;
 
-	dbg("%s- port %d\n", __func__, port->number);
+	dbg("%s- port %d", __func__, port->number);
 
 	mos7720_port = usb_get_serial_port_data(port);
 
@@ -1208,7 +1208,7 @@ static void mos7720_set_termios(struct tty_struct *tty,
 		return;
 	}
 
-	dbg("%s\n", "setting termios - ASPIRE");
+	dbg("setting termios - ASPIRE");
 
 	cflag = tty->termios->c_cflag;
 
@@ -1226,7 +1226,7 @@ static void mos7720_set_termios(struct tty_struct *tty,
 	change_port_settings(tty, mos7720_port, old_termios);
 
 	if (!port->read_urb) {
-		dbg("%s", "URB KILLED !!!!!\n");
+		dbg("URB KILLED !!!!!");
 		return;
 	}
 
diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
index 0622650..40c3bff 100644
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -332,7 +332,7 @@ static void omninet_write_bulk_callback(struct urb *urb)
 	struct usb_serial_port 	*port   =  urb->context;
 	int status = urb->status;
 
-	dbg("%s - port %0x\n", __func__, port->number);
+	dbg("%s - port %0x", __func__, port->number);
 
 	port->write_urb_busy = 0;
 	if (status) {
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 4cdb975..0b29d25 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -217,7 +217,7 @@ static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
 	spin_lock_irqsave(&priv->lock, flags);
 	if (priv->outstanding_urbs > URB_UPPER_LIMIT) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		dbg("%s - write limit hit\n", __func__);
+		dbg("%s - write limit hit", __func__);
 		return 0;
 	}
 	priv->outstanding_urbs++;
@@ -288,7 +288,7 @@ static int opticon_write_room(struct tty_struct *tty)
 	spin_lock_irqsave(&priv->lock, flags);
 	if (priv->outstanding_urbs > URB_UPPER_LIMIT * 2 / 3) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		dbg("%s - write limit hit\n", __func__);
+		dbg("%s - write limit hit", __func__);
 		return 0;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 6e94a67..1a3915b 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -985,7 +985,7 @@ static void option_instat_callback(struct urb *urb)
 				(struct usb_ctrlrequest *)urb->transfer_buffer;
 
 		if (!req_pkt) {
-			dbg("%s: NULL req_pkt\n", __func__);
+			dbg("%s: NULL req_pkt", __func__);
 			return;
 		}
 		if ((req_pkt->bRequestType == 0xA1) &&
@@ -1401,7 +1401,7 @@ static int option_resume(struct usb_serial *serial)
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
 		if (!port->interrupt_in_urb) {
-			dbg("%s: No interrupt URB for port %d\n", __func__, i);
+			dbg("%s: No interrupt URB for port %d", __func__, i);
 			continue;
 		}
 		err = usb_submit_urb(port->interrupt_in_urb, GFP_NOIO);
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 1e58220..9af452e 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -609,7 +609,7 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 	if (i < 0)
 		dev_err(&port->dev, "Set UART format %#x failed (error = %d)\n",
 			uartdata, i);
-	dbg("0x21:0x40:0:0  %d\n", i);
+	dbg("0x21:0x40:0:0  %d", i);
 
 	if (cflag & CRTSCTS) {
 		/* enable hardware flow control */
diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index ad1f923..290e717 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -368,7 +368,7 @@ static int visor_write(struct tty_struct *tty, struct usb_serial_port *port,
 	spin_lock_irqsave(&priv->lock, flags);
 	if (priv->outstanding_urbs > URB_UPPER_LIMIT) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		dbg("%s - write limit hit\n", __func__);
+		dbg("%s - write limit hit", __func__);
 		return 0;
 	}
 	priv->outstanding_urbs++;
@@ -446,7 +446,7 @@ static int visor_write_room(struct tty_struct *tty)
 	spin_lock_irqsave(&priv->lock, flags);
 	if (priv->outstanding_urbs > URB_UPPER_LIMIT * 2 / 3) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		dbg("%s - write limit hit\n", __func__);
+		dbg("%s - write limit hit", __func__);
 		return 0;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);


