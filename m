Return-Path: <linux-kernel-owner+w=401wt.eu-S1764102AbYFTU30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764102AbYFTU30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761390AbYFTUUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:20:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35205 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761370AbYFTUU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:20:28 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 38/70] garmin_gps: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:03:02 +0100
Message-ID: <20080620200301.1479.64141.stgit@localhost.localdomain>
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

 drivers/usb/serial/garmin_gps.c |  354 +++++++++++++++++++--------------------
 1 files changed, 176 insertions(+), 178 deletions(-)


diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index 06cfa43..2e663f1 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -33,7 +33,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/atomic.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
@@ -44,7 +44,7 @@
 static int initial_mode = 1;
 
 /* debug flag */
-static int debug = 0;
+static int debug;
 
 #define GARMIN_VENDOR_ID             0x091E
 
@@ -56,7 +56,7 @@ static int debug = 0;
 #define VERSION_MINOR	31
 
 #define _STR(s) #s
-#define _DRIVER_VERSION(a,b) "v" _STR(a) "." _STR(b)
+#define _DRIVER_VERSION(a, b) "v" _STR(a) "." _STR(b)
 #define DRIVER_VERSION _DRIVER_VERSION(VERSION_MAJOR, VERSION_MINOR)
 #define DRIVER_AUTHOR "hermann kneissel"
 #define DRIVER_DESC "garmin gps driver"
@@ -65,37 +65,37 @@ static int debug = 0;
 #define EINVPKT	1000	/* invalid packet structure */
 
 
-// size of the header of a packet using the usb protocol
+/* size of the header of a packet using the usb protocol */
 #define GARMIN_PKTHDR_LENGTH	12
 
-// max. possible size of a packet using the serial protocol 
-#define MAX_SERIAL_PKT_SIZ (3+255+3)
+/* max. possible size of a packet using the serial protocol */
+#define MAX_SERIAL_PKT_SIZ (3 + 255 + 3)
 
-// max. possible size of a packet with worst case stuffing
-#define MAX_SERIAL_PKT_SIZ_STUFFED MAX_SERIAL_PKT_SIZ+256
+/*  max. possible size of a packet with worst case stuffing */
+#define MAX_SERIAL_PKT_SIZ_STUFFED (MAX_SERIAL_PKT_SIZ + 256)
 
-// size of a buffer able to hold a complete (no stuffing) packet
-// (the document protocol does not contain packets with a larger
-//  size, but in theory a packet may be 64k+12 bytes - if in
-//  later protocol versions larger packet sizes occur, this value
-//  should be increased accordingly, so the input buffer is always 
-//  large enough the store a complete packet inclusive header)
-#define GPS_IN_BUFSIZ  (GARMIN_PKTHDR_LENGTH+MAX_SERIAL_PKT_SIZ) 
+/* size of a buffer able to hold a complete (no stuffing) packet
+ * (the document protocol does not contain packets with a larger
+ *  size, but in theory a packet may be 64k+12 bytes - if in
+ *  later protocol versions larger packet sizes occur, this value
+ *  should be increased accordingly, so the input buffer is always
+ *  large enough the store a complete packet inclusive header) */
+#define GPS_IN_BUFSIZ  (GARMIN_PKTHDR_LENGTH+MAX_SERIAL_PKT_SIZ)
 
-// size of a buffer able to hold a complete (incl. stuffing) packet
-#define GPS_OUT_BUFSIZ (GARMIN_PKTHDR_LENGTH+MAX_SERIAL_PKT_SIZ_STUFFED) 
+/* size of a buffer able to hold a complete (incl. stuffing) packet */
+#define GPS_OUT_BUFSIZ (GARMIN_PKTHDR_LENGTH+MAX_SERIAL_PKT_SIZ_STUFFED)
 
-// where to place the packet id of a serial packet, so we can
-// prepend the usb-packet header without the need to move the
-// packets data
+/* where to place the packet id of a serial packet, so we can
+ * prepend the usb-packet header without the need to move the
+ * packets data */
 #define GSP_INITIAL_OFFSET (GARMIN_PKTHDR_LENGTH-2)
 
-// max. size of incoming private packets (header+1 param)
+/* max. size of incoming private packets (header+1 param) */
 #define PRIVPKTSIZ (GARMIN_PKTHDR_LENGTH+4)
 
 #define GARMIN_LAYERID_TRANSPORT  0
 #define GARMIN_LAYERID_APPL      20
-// our own layer-id to use for some control mechanisms
+/* our own layer-id to use for some control mechanisms */
 #define GARMIN_LAYERID_PRIVATE	0x01106E4B
 
 #define GARMIN_PKTID_PVT_DATA	51
@@ -103,7 +103,7 @@ static int debug = 0;
 
 #define CMND_ABORT_TRANSFER 0
 
-// packet ids used in private layer
+/* packet ids used in private layer */
 #define PRIV_PKTID_SET_DEBUG	1
 #define PRIV_PKTID_SET_MODE	2
 #define PRIV_PKTID_INFO_REQ	3
@@ -121,7 +121,8 @@ static int debug = 0;
 struct garmin_packet {
 	struct list_head  list;
 	int               seq;
-	int               size; // the real size of the data array, always > 0
+	/* the real size of the data array, always > 0 */
+	int               size;
 	__u8              data[1];
 };
 
@@ -164,7 +165,7 @@ struct garmin_data {
 #define MODE_NATIVE          0
 #define MODE_GARMIN_SERIAL   1
 
-// Flags used in garmin_data.flags:
+/* Flags used in garmin_data.flags: */
 #define FLAGS_SESSION_REPLY_MASK  0x00C0
 #define FLAGS_SESSION_REPLY1_SEEN 0x0080
 #define FLAGS_SESSION_REPLY2_SEEN 0x0040
@@ -185,7 +186,7 @@ struct garmin_data {
 
 
 /* function prototypes */
-static void gsp_next_packet(struct garmin_data * garmin_data_p);
+static void gsp_next_packet(struct garmin_data *garmin_data_p);
 static int  garmin_write_bulk(struct usb_serial_port *port,
 			     const unsigned char *buf, int count,
 			     int dismiss_ack);
@@ -217,12 +218,13 @@ static unsigned char const PRIVATE_REQ[]
 
 
 static struct usb_device_id id_table [] = {
-	/* the same device id seems to be used by all usb enabled gps devices */
-	{ USB_DEVICE(GARMIN_VENDOR_ID, 3 ) },
+	/* the same device id seems to be used by all
+	   usb enabled GPS devices */
+	{ USB_DEVICE(GARMIN_VENDOR_ID, 3) },
 	{ }					/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table);
+MODULE_DEVICE_TABLE(usb, id_table);
 
 static struct usb_driver garmin_driver = {
 	.name =		"garmin_gps",
@@ -233,9 +235,10 @@ static struct usb_driver garmin_driver = {
 };
 
 
-static inline int noResponseFromAppLayer(struct garmin_data * garmin_data_p)
+static inline int noResponseFromAppLayer(struct garmin_data *garmin_data_p)
 {
-	return atomic_read(&garmin_data_p->req_count) == atomic_read(&garmin_data_p->resp_count);
+	return atomic_read(&garmin_data_p->req_count) ==
+				atomic_read(&garmin_data_p->resp_count);
 }
 
 
@@ -261,10 +264,10 @@ static inline int getDataLength(const __u8 *usbPacket)
  */
 static inline int isAbortTrfCmnd(const unsigned char *buf)
 {
-	if (0 == memcmp(buf, GARMIN_STOP_TRANSFER_REQ, 
-	                sizeof(GARMIN_STOP_TRANSFER_REQ)) ||
-	    0 == memcmp(buf, GARMIN_STOP_TRANSFER_REQ_V2, 
-	                sizeof(GARMIN_STOP_TRANSFER_REQ_V2)))
+	if (0 == memcmp(buf, GARMIN_STOP_TRANSFER_REQ,
+					sizeof(GARMIN_STOP_TRANSFER_REQ)) ||
+	    0 == memcmp(buf, GARMIN_STOP_TRANSFER_REQ_V2,
+					sizeof(GARMIN_STOP_TRANSFER_REQ_V2)))
 		return 1;
 	else
 		return 0;
@@ -279,7 +282,7 @@ static void send_to_tty(struct usb_serial_port *port,
 
 	if (tty && actual_length) {
 
-		usb_serial_debug_data(debug, &port->dev, 
+		usb_serial_debug_data(debug, &port->dev,
 					__func__, actual_length, data);
 
 		tty_buffer_request_room(tty, actual_length);
@@ -296,7 +299,7 @@ static void send_to_tty(struct usb_serial_port *port,
 /*
  * queue a received (usb-)packet for later processing
  */
-static int pkt_add(struct garmin_data * garmin_data_p,
+static int pkt_add(struct garmin_data *garmin_data_p,
 		   unsigned char *data, unsigned int data_length)
 {
 	int state = 0;
@@ -307,7 +310,7 @@ static int pkt_add(struct garmin_data * garmin_data_p,
 	/* process only packets containg data ... */
 	if (data_length) {
 		pkt = kmalloc(sizeof(struct garmin_packet)+data_length,
-		              GFP_ATOMIC);
+								GFP_ATOMIC);
 		if (pkt == NULL) {
 			dev_err(&garmin_data_p->port->dev, "out of memory\n");
 			return 0;
@@ -325,16 +328,15 @@ static int pkt_add(struct garmin_data * garmin_data_p,
 
 		/* in serial mode, if someone is waiting for data from
 		   the device, iconvert and send the next packet to tty. */
-		if (result && (state == STATE_GSP_WAIT_DATA)) {
+		if (result && (state == STATE_GSP_WAIT_DATA))
 			gsp_next_packet(garmin_data_p);
-		}
 	}
 	return result;
 }
 
 
 /* get the next pending packet */
-static struct garmin_packet *pkt_pop(struct garmin_data * garmin_data_p)
+static struct garmin_packet *pkt_pop(struct garmin_data *garmin_data_p)
 {
 	unsigned long flags;
 	struct garmin_packet *result = NULL;
@@ -350,7 +352,7 @@ static struct garmin_packet *pkt_pop(struct garmin_data * garmin_data_p)
 
 
 /* free up all queued data */
-static void pkt_clear(struct garmin_data * garmin_data_p)
+static void pkt_clear(struct garmin_data *garmin_data_p)
 {
 	unsigned long flags;
 	struct garmin_packet *result = NULL;
@@ -372,7 +374,7 @@ static void pkt_clear(struct garmin_data * garmin_data_p)
  ******************************************************************************/
 
 /* send an ack packet back to the tty */
-static int gsp_send_ack(struct garmin_data * garmin_data_p, __u8 pkt_id)
+static int gsp_send_ack(struct garmin_data *garmin_data_p, __u8 pkt_id)
 {
 	__u8 pkt[10];
 	__u8 cksum = 0;
@@ -391,9 +393,8 @@ static int gsp_send_ack(struct garmin_data * garmin_data_p, __u8 pkt_id)
 	*ptr++ = pkt_id;
 	cksum += pkt_id;
 
-	if (pkt_id == DLE) {
+	if (pkt_id == DLE)
 		*ptr++ = DLE;
-	}
 
 	*ptr++ = 0;
 	*ptr++ = 0xFF & (-cksum);
@@ -415,12 +416,12 @@ static int gsp_send_ack(struct garmin_data * garmin_data_p, __u8 pkt_id)
  * at GSP_INITIAL_OFFSET.
  *
  * count - number of bytes in the input buffer including space reserved for
- *         the usb header: GSP_INITIAL_OFFSET + number of bytes in packet 
+ *         the usb header: GSP_INITIAL_OFFSET + number of bytes in packet
  *         (including pkt-id, data-length a. cksum)
  */
-static int gsp_rec_packet(struct garmin_data * garmin_data_p, int count)
+static int gsp_rec_packet(struct garmin_data *garmin_data_p, int count)
 {
-	const __u8* recpkt = garmin_data_p->inbuffer+GSP_INITIAL_OFFSET;
+	const __u8 *recpkt = garmin_data_p->inbuffer+GSP_INITIAL_OFFSET;
 	__le32 *usbdata = (__le32 *) garmin_data_p->inbuffer;
 
 	int cksum = 0;
@@ -440,8 +441,8 @@ static int gsp_rec_packet(struct garmin_data * garmin_data_p, int count)
 	cksum += *recpkt++;
 	cksum += *recpkt++;
 
-	// sanity check, remove after test ...
-	if ((__u8*)&(usbdata[3]) != recpkt) {
+	/* sanity check, remove after test ... */
+	if ((__u8 *)&(usbdata[3]) != recpkt) {
 		dbg("%s - ptr mismatch %p - %p",
 			__func__, &(usbdata[4]), recpkt);
 		return -EINVPKT;
@@ -462,7 +463,7 @@ static int gsp_rec_packet(struct garmin_data * garmin_data_p, int count)
 	usbdata[1] = __cpu_to_le32(pktid);
 	usbdata[2] = __cpu_to_le32(size);
 
-	garmin_write_bulk (garmin_data_p->port, garmin_data_p->inbuffer,
+	garmin_write_bulk(garmin_data_p->port, garmin_data_p->inbuffer,
 			   GARMIN_PKTHDR_LENGTH+size, 0);
 
 	/* if this was an abort-transfer command, flush all
@@ -495,7 +496,7 @@ static int gsp_rec_packet(struct garmin_data * garmin_data_p, int count)
  * if the input is an abort command, drop all queued data.
  */
 
-static int gsp_receive(struct garmin_data * garmin_data_p,
+static int gsp_receive(struct garmin_data *garmin_data_p,
 		       const unsigned char *buf, int count)
 {
 	unsigned long flags;
@@ -504,10 +505,11 @@ static int gsp_receive(struct garmin_data * garmin_data_p,
 	int i = 0;
 	__u8 *dest;
 	int size;
-	// dleSeen: set if last byte read was a DLE
+	/* dleSeen: set if last byte read was a DLE */
 	int dleSeen;
-	// skip: if set, skip incoming data until possible start of
-	//       new packet
+	/* skip: if set, skip incoming data until possible start of
+	 *       new packet
+	 */
 	int skip;
 	__u8 data;
 
@@ -521,14 +523,13 @@ static int gsp_receive(struct garmin_data * garmin_data_p,
 	dbg("%s - dle=%d skip=%d size=%d count=%d",
 		__func__, dleSeen, skip, size, count);
 
-	if (size == 0) {
+	if (size == 0)
 		size = GSP_INITIAL_OFFSET;
-	}
 
 	while (offs < count) {
 
 		data = *(buf+offs);
-		offs ++;
+		offs++;
 
 		if (data == DLE) {
 			if (skip) { /* start of a new pkt */
@@ -554,9 +555,8 @@ static int gsp_receive(struct garmin_data * garmin_data_p,
 					ack_or_nak_seen = NAK;
 					dbg("NAK packet complete.");
 				} else {
-					dbg("packet complete "
-						        "- id=0x%X.",
-						        0xFF & data);
+					dbg("packet complete - id=0x%X.",
+						0xFF & data);
 					gsp_rec_packet(garmin_data_p, size);
 				}
 
@@ -589,7 +589,7 @@ static int gsp_receive(struct garmin_data * garmin_data_p,
 
 	garmin_data_p->insize = size;
 
-	// copy flags back to structure
+	/* copy flags back to structure */
 	if (skip)
 		garmin_data_p->flags |= FLAGS_GSP_SKIP;
 	else
@@ -600,16 +600,13 @@ static int gsp_receive(struct garmin_data * garmin_data_p,
 	else
 		garmin_data_p->flags &= ~FLAGS_GSP_DLESEEN;
 
-	if (ack_or_nak_seen) {
+	if (ack_or_nak_seen)
 		garmin_data_p->state = STATE_GSP_WAIT_DATA;
-	}
 
 	spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 
-	if (ack_or_nak_seen) {
+	if (ack_or_nak_seen)
 		gsp_next_packet(garmin_data_p);
-	}
-
 	return count;
 }
 
@@ -623,7 +620,7 @@ static int gsp_receive(struct garmin_data * garmin_data_p,
  *
  * return <0 on error, 0 if packet is incomplete or > 0 if packet was sent
  */
-static int gsp_send(struct garmin_data * garmin_data_p,
+static int gsp_send(struct garmin_data *garmin_data_p,
 		    const unsigned char *buf, int count)
 {
 	const unsigned char *src;
@@ -631,11 +628,11 @@ static int gsp_send(struct garmin_data * garmin_data_p,
 	int pktid = 0;
 	int datalen = 0;
 	int cksum = 0;
-	int i=0;
+	int i = 0;
 	int k;
 
 	dbg("%s - state %d - %d bytes.", __func__,
-	         garmin_data_p->state, count);
+					garmin_data_p->state, count);
 
 	k = garmin_data_p->outsize;
 	if ((k+count) > GPS_OUT_BUFSIZ) {
@@ -650,7 +647,7 @@ static int gsp_send(struct garmin_data * garmin_data_p,
 
 	if (k >= GARMIN_PKTHDR_LENGTH) {
 		pktid  = getPacketId(garmin_data_p->outbuffer);
-		datalen= getDataLength(garmin_data_p->outbuffer);
+		datalen = getDataLength(garmin_data_p->outbuffer);
 		i = GARMIN_PKTHDR_LENGTH + datalen;
 		if (k < i)
 			return 0;
@@ -658,19 +655,18 @@ static int gsp_send(struct garmin_data * garmin_data_p,
 		return 0;
 	}
 
-	dbg("%s - %d bytes in buffer, %d bytes in pkt.", __func__,
-	         k, i);
+	dbg("%s - %d bytes in buffer, %d bytes in pkt.", __func__, k, i);
 
 	/* garmin_data_p->outbuffer now contains a complete packet */
 
 	usb_serial_debug_data(debug, &garmin_data_p->port->dev,
-		                   __func__, k, garmin_data_p->outbuffer);
+				__func__, k, garmin_data_p->outbuffer);
 
 	garmin_data_p->outsize = 0;
 
 	if (GARMIN_LAYERID_APPL != getLayerId(garmin_data_p->outbuffer)) {
-		dbg("not an application packet (%d)", 
-		        getLayerId(garmin_data_p->outbuffer));
+		dbg("not an application packet (%d)",
+				getLayerId(garmin_data_p->outbuffer));
 		return -1;
 	}
 
@@ -688,14 +684,14 @@ static int gsp_send(struct garmin_data * garmin_data_p,
 
 	k = 0;
 	src = garmin_data_p->outbuffer+GARMIN_PKTHDR_LENGTH;
-	for (i=0; i<datalen; i++) {
+	for (i = 0; i < datalen; i++) {
 		if (*src++ == DLE)
 			k++;
 	}
 
 	src = garmin_data_p->outbuffer+GARMIN_PKTHDR_LENGTH;
 	if (k > (GARMIN_PKTHDR_LENGTH-2)) {
-		/* can't add stuffing DLEs in place, move data to end 
+		/* can't add stuffing DLEs in place, move data to end
 		   of buffer ... */
 		dst = garmin_data_p->outbuffer+GPS_OUT_BUFSIZ-datalen;
 		memcpy(dst, src, datalen);
@@ -712,14 +708,14 @@ static int gsp_send(struct garmin_data * garmin_data_p,
 	if (datalen == DLE)
 		*dst++ = DLE;
 
-	for (i=0; i<datalen; i++) {
+	for (i = 0; i < datalen; i++) {
 		__u8 c = *src++;
 		*dst++ = c;
 		cksum += c;
 		if (c == DLE)
 			*dst++ = DLE;
 	}
-		
+
 	cksum = 0xFF & -cksum;
 	*dst++ = cksum;
 	if (cksum == DLE)
@@ -744,7 +740,7 @@ static int gsp_send(struct garmin_data * garmin_data_p,
 /*
  * Process the next pending data packet - if there is one
  */
-static void gsp_next_packet(struct garmin_data * garmin_data_p)
+static void gsp_next_packet(struct garmin_data *garmin_data_p)
 {
 	struct garmin_packet *pkt = NULL;
 
@@ -774,17 +770,17 @@ static void gsp_next_packet(struct garmin_data * garmin_data_p)
  * buf contains the data read, it may span more than one packet
  * or even incomplete packets
  */
-static int nat_receive(struct garmin_data * garmin_data_p,
+static int nat_receive(struct garmin_data *garmin_data_p,
 		       const unsigned char *buf, int count)
 {
 	unsigned long flags;
-	__u8 * dest;
+	__u8 *dest;
 	int offs = 0;
 	int result = count;
 	int len;
 
 	while (offs < count) {
-		// if buffer contains header, copy rest of data
+		/* if buffer contains header, copy rest of data */
 		if (garmin_data_p->insize >= GARMIN_PKTHDR_LENGTH)
 			len = GARMIN_PKTHDR_LENGTH
 			      +getDataLength(garmin_data_p->inbuffer);
@@ -792,9 +788,9 @@ static int nat_receive(struct garmin_data * garmin_data_p,
 			len = GARMIN_PKTHDR_LENGTH;
 
 		if (len >= GPS_IN_BUFSIZ) {
-			/* seem to be an invalid packet, ignore rest of input */
-			dbg("%s - packet size too large: %d",
-			        __func__, len);
+			/* seems to be an invalid packet, ignore rest
+			   of input */
+			dbg("%s - packet size too large: %d", __func__, len);
 			garmin_data_p->insize = 0;
 			count = 0;
 			result = -EINVPKT;
@@ -804,7 +800,7 @@ static int nat_receive(struct garmin_data * garmin_data_p,
 				len = (count-offs);
 			if (len > 0) {
 				dest = garmin_data_p->inbuffer
-				       	+garmin_data_p->insize;
+						+ garmin_data_p->insize;
 				memcpy(dest, buf+offs, len);
 				garmin_data_p->insize += len;
 				offs += len;
@@ -816,17 +812,19 @@ static int nat_receive(struct garmin_data * garmin_data_p,
 			len = GARMIN_PKTHDR_LENGTH+
 			   getDataLength(garmin_data_p->inbuffer);
 			if (garmin_data_p->insize >= len) {
-				garmin_write_bulk (garmin_data_p->port,
-				                   garmin_data_p->inbuffer,
-				                   len, 0);
+				garmin_write_bulk(garmin_data_p->port,
+						   garmin_data_p->inbuffer,
+						   len, 0);
 				garmin_data_p->insize = 0;
 
 				/* if this was an abort-transfer command,
 				   flush all queued data. */
 				if (isAbortTrfCmnd(garmin_data_p->inbuffer)) {
-					spin_lock_irqsave(&garmin_data_p->lock, flags);
+					spin_lock_irqsave(&garmin_data_p->lock,
+									flags);
 					garmin_data_p->flags |= FLAGS_DROP_DATA;
-					spin_unlock_irqrestore(&garmin_data_p->lock, flags);
+					spin_unlock_irqrestore(
+						&garmin_data_p->lock, flags);
 					pkt_clear(garmin_data_p);
 				}
 			}
@@ -842,7 +840,7 @@ static int nat_receive(struct garmin_data * garmin_data_p,
 
 static void priv_status_resp(struct usb_serial_port *port)
 {
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 	__le32 *pkt = (__le32 *)garmin_data_p->privpkt;
 
 	pkt[0] = __cpu_to_le32(GARMIN_LAYERID_PRIVATE);
@@ -852,7 +850,7 @@ static void priv_status_resp(struct usb_serial_port *port)
 	pkt[4] = __cpu_to_le32(garmin_data_p->mode);
 	pkt[5] = __cpu_to_le32(garmin_data_p->serial_num);
 
-	send_to_tty(port, (__u8*)pkt, 6*4);
+	send_to_tty(port, (__u8 *)pkt, 6 * 4);
 }
 
 
@@ -864,7 +862,7 @@ static int process_resetdev_request(struct usb_serial_port *port)
 {
 	unsigned long flags;
 	int status;
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 
 	spin_lock_irqsave(&garmin_data_p->lock, flags);
 	garmin_data_p->flags &= ~(CLEAR_HALT_REQUIRED);
@@ -872,8 +870,8 @@ static int process_resetdev_request(struct usb_serial_port *port)
 	garmin_data_p->serial_num = 0;
 	spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 
-	usb_kill_urb (port->interrupt_in_urb);
-	dbg("%s - usb_reset_device", __func__ );
+	usb_kill_urb(port->interrupt_in_urb);
+	dbg("%s - usb_reset_device", __func__);
 	status = usb_reset_device(port->serial->dev);
 	if (status)
 		dbg("%s - usb_reset_device failed: %d",
@@ -886,7 +884,7 @@ static int process_resetdev_request(struct usb_serial_port *port)
 /*
  * clear all cached data
  */
-static int garmin_clear(struct garmin_data * garmin_data_p)
+static int garmin_clear(struct garmin_data *garmin_data_p)
 {
 	unsigned long flags;
 	int status = 0;
@@ -896,8 +894,7 @@ static int garmin_clear(struct garmin_data * garmin_data_p)
 	if (port != NULL && atomic_read(&garmin_data_p->resp_count)) {
 		/* send a terminate command */
 		status = garmin_write_bulk(port, GARMIN_STOP_TRANSFER_REQ,
-		                           sizeof(GARMIN_STOP_TRANSFER_REQ),
-					   1);
+					sizeof(GARMIN_STOP_TRANSFER_REQ), 1);
 	}
 
 	/* flush all queued data */
@@ -920,28 +917,26 @@ static int garmin_init_session(struct usb_serial_port *port)
 {
 	unsigned long flags;
 	struct usb_serial *serial = port->serial;
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 	int status = 0;
 
 	if (status == 0) {
-		usb_kill_urb (port->interrupt_in_urb);
+		usb_kill_urb(port->interrupt_in_urb);
 
 		dbg("%s - adding interrupt input", __func__);
 		port->interrupt_in_urb->dev = serial->dev;
 		status = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 		if (status)
 			dev_err(&serial->dev->dev,
-			        "%s - failed submitting interrupt urb,"
-				" error %d\n",
-			        __func__, status);
+			  "%s - failed submitting interrupt urb, error %d\n",
+							__func__, status);
 	}
 
 	if (status == 0) {
 		dbg("%s - starting session ...", __func__);
 		garmin_data_p->state = STATE_ACTIVE;
 		status = garmin_write_bulk(port, GARMIN_START_SESSION_REQ,
-		                           sizeof(GARMIN_START_SESSION_REQ),
-					   0);
+					sizeof(GARMIN_START_SESSION_REQ), 0);
 
 		if (status >= 0) {
 
@@ -951,14 +946,14 @@ static int garmin_init_session(struct usb_serial_port *port)
 
 			/* not needed, but the win32 driver does it too ... */
 			status = garmin_write_bulk(port,
-						   GARMIN_START_SESSION_REQ2,
-			                           sizeof(GARMIN_START_SESSION_REQ2),
-						   0);
+					GARMIN_START_SESSION_REQ2,
+					sizeof(GARMIN_START_SESSION_REQ2), 0);
 			if (status >= 0) {
 				status = 0;
 				spin_lock_irqsave(&garmin_data_p->lock, flags);
 				garmin_data_p->ignorePkts++;
-				spin_unlock_irqrestore(&garmin_data_p->lock, flags);
+				spin_unlock_irqrestore(&garmin_data_p->lock,
+									flags);
 			}
 		}
 	}
@@ -970,12 +965,12 @@ static int garmin_init_session(struct usb_serial_port *port)
 
 
 
-static int garmin_open (struct tty_struct *tty,
+static int garmin_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp)
 {
 	unsigned long flags;
 	int status = 0;
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -996,8 +991,8 @@ static int garmin_open (struct tty_struct *tty,
 	spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 
 	/* shutdown any bulk reads that might be going on */
-	usb_kill_urb (port->write_urb);
-	usb_kill_urb (port->read_urb);
+	usb_kill_urb(port->write_urb);
+	usb_kill_urb(port->read_urb);
 
 	if (garmin_data_p->state == STATE_RESET)
 		status = garmin_init_session(port);
@@ -1008,10 +1003,10 @@ static int garmin_open (struct tty_struct *tty,
 
 
 static void garmin_close(struct tty_struct *tty,
-			struct usb_serial_port *port, struct file * filp)
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 
 	dbg("%s - port %d - mode=%d state=%d flags=0x%X", __func__,
 		port->number, garmin_data_p->mode,
@@ -1025,8 +1020,8 @@ static void garmin_close(struct tty_struct *tty,
 		garmin_clear(garmin_data_p);
 
 	/* shutdown our urbs */
-	usb_kill_urb (port->read_urb);
-	usb_kill_urb (port->write_urb);
+	usb_kill_urb(port->read_urb);
+	usb_kill_urb(port->write_urb);
 
 	if (!port->serial->disconnected) {
 		if (noResponseFromAppLayer(garmin_data_p) ||
@@ -1042,20 +1037,22 @@ static void garmin_close(struct tty_struct *tty,
 	mutex_unlock(&port->serial->disc_mutex);
 }
 
-static void garmin_write_bulk_callback (struct urb *urb)
+static void garmin_write_bulk_callback(struct urb *urb)
 {
 	unsigned long flags;
 	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
 
 	if (port) {
-		struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+		struct garmin_data *garmin_data_p =
+					usb_get_serial_port_data(port);
 
 		dbg("%s - port %d", __func__, port->number);
 
 		if (GARMIN_LAYERID_APPL == getLayerId(urb->transfer_buffer)
 		    && (garmin_data_p->mode == MODE_GARMIN_SERIAL))  {
-			gsp_send_ack(garmin_data_p, ((__u8 *)urb->transfer_buffer)[4]);
+			gsp_send_ack(garmin_data_p,
+					((__u8 *)urb->transfer_buffer)[4]);
 		}
 
 		if (status) {
@@ -1069,20 +1066,21 @@ static void garmin_write_bulk_callback (struct urb *urb)
 		usb_serial_port_softint(port);
 	}
 
-	/* Ignore errors that resulted from garmin_write_bulk with dismiss_ack=1 */
+	/* Ignore errors that resulted from garmin_write_bulk with
+	   dismiss_ack = 1 */
 
 	/* free up the transfer buffer, as usb_free_urb() does not do this */
-	kfree (urb->transfer_buffer);
+	kfree(urb->transfer_buffer);
 }
 
 
-static int garmin_write_bulk (struct usb_serial_port *port,
+static int garmin_write_bulk(struct usb_serial_port *port,
 			      const unsigned char *buf, int count,
 			      int dismiss_ack)
 {
 	unsigned long flags;
 	struct usb_serial *serial = port->serial;
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 	struct urb *urb;
 	unsigned char *buffer;
 	int status;
@@ -1094,7 +1092,7 @@ static int garmin_write_bulk (struct usb_serial_port *port,
 	garmin_data_p->flags &= ~FLAGS_DROP_DATA;
 	spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 
-	buffer = kmalloc (count, GFP_ATOMIC);
+	buffer = kmalloc(count, GFP_ATOMIC);
 	if (!buffer) {
 		dev_err(&port->dev, "out of memory\n");
 		return -ENOMEM;
@@ -1103,17 +1101,17 @@ static int garmin_write_bulk (struct usb_serial_port *port,
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
 		dev_err(&port->dev, "no more free urbs\n");
-		kfree (buffer);
+		kfree(buffer);
 		return -ENOMEM;
 	}
 
-	memcpy (buffer, buf, count);
+	memcpy(buffer, buf, count);
 
 	usb_serial_debug_data(debug, &port->dev, __func__, count, buffer);
 
-	usb_fill_bulk_urb (urb, serial->dev,
-			 	usb_sndbulkpipe (serial->dev,
-				port->bulk_out_endpointAddress),
+	usb_fill_bulk_urb(urb, serial->dev,
+				usb_sndbulkpipe(serial->dev,
+					port->bulk_out_endpointAddress),
 				buffer, count,
 				garmin_write_bulk_callback,
 				dismiss_ack ? NULL : port);
@@ -1131,24 +1129,23 @@ static int garmin_write_bulk (struct usb_serial_port *port,
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status) {
 		dev_err(&port->dev,
-		        "%s - usb_submit_urb(write bulk) "
-		        "failed with status = %d\n",
+		   "%s - usb_submit_urb(write bulk) failed with status = %d\n",
 				__func__, status);
 		count = status;
 	}
 
 	/* we are done with this urb, so let the host driver
 	 * really free it when it is finished with it */
-	usb_free_urb (urb);
+	usb_free_urb(urb);
 
 	return count;
 }
 
-static int garmin_write (struct tty_struct *tty, struct usb_serial_port *port,
+static int garmin_write(struct tty_struct *tty, struct usb_serial_port *port,
 					 const unsigned char *buf, int count)
 {
 	int pktid, pktsiz, len;
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 	__le32 *privpkt = (__le32 *)garmin_data_p->privpkt;
 
 	usb_serial_debug_data(debug, &port->dev, __func__, count, buf);
@@ -1165,15 +1162,16 @@ static int garmin_write (struct tty_struct *tty, struct usb_serial_port *port,
 		pktid  = getPacketId(garmin_data_p->privpkt);
 
 		if (count == (GARMIN_PKTHDR_LENGTH+pktsiz)
-		    && GARMIN_LAYERID_PRIVATE == getLayerId(garmin_data_p->privpkt)) {
+		    && GARMIN_LAYERID_PRIVATE ==
+				getLayerId(garmin_data_p->privpkt)) {
 
 			dbg("%s - processing private request %d",
 				__func__, pktid);
 
-			// drop all unfinished transfers
+			/* drop all unfinished transfers */
 			garmin_clear(garmin_data_p);
 
-			switch(pktid) {
+			switch (pktid) {
 
 			case PRIV_PKTID_SET_DEBUG:
 				if (pktsiz != 4)
@@ -1228,25 +1226,25 @@ static int garmin_write_room(struct tty_struct *tty)
 	/*
 	 * Report back the bytes currently available in the output buffer.
 	 */
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 	return GPS_OUT_BUFSIZ-garmin_data_p->outsize;
 }
 
 
-static void garmin_read_process(struct garmin_data * garmin_data_p,
+static void garmin_read_process(struct garmin_data *garmin_data_p,
 				 unsigned char *data, unsigned data_length)
 {
 	if (garmin_data_p->flags & FLAGS_DROP_DATA) {
 		/* abort-transfer cmd is actice */
 		dbg("%s - pkt dropped", __func__);
 	} else if (garmin_data_p->state != STATE_DISCONNECTED &&
-	           garmin_data_p->state != STATE_RESET ) {
+		garmin_data_p->state != STATE_RESET) {
 
 		/* remember any appl.layer packets, so we know
 		   if a reset is required or not when closing
 		   the device */
 		if (0 == memcmp(data, GARMIN_APP_LAYER_REPLY,
-		                sizeof(GARMIN_APP_LAYER_REPLY))) {
+				sizeof(GARMIN_APP_LAYER_REPLY))) {
 			atomic_inc(&garmin_data_p->resp_count);
 		}
 
@@ -1256,9 +1254,8 @@ static void garmin_read_process(struct garmin_data * garmin_data_p,
 		if (garmin_data_p->flags & FLAGS_QUEUING) {
 			pkt_add(garmin_data_p, data, data_length);
 		} else if (garmin_data_p->mode == MODE_GARMIN_SERIAL) {
-			if (getLayerId(data) == GARMIN_LAYERID_APPL) {
+			if (getLayerId(data) == GARMIN_LAYERID_APPL)
 				pkt_add(garmin_data_p, data, data_length);
-			}
 		} else {
 			send_to_tty(garmin_data_p->port, data, data_length);
 		}
@@ -1266,12 +1263,12 @@ static void garmin_read_process(struct garmin_data * garmin_data_p,
 }
 
 
-static void garmin_read_bulk_callback (struct urb *urb)
+static void garmin_read_bulk_callback(struct urb *urb)
 {
 	unsigned long flags;
 	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial =  port->serial;
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
 	int retval;
@@ -1289,7 +1286,7 @@ static void garmin_read_bulk_callback (struct urb *urb)
 		return;
 	}
 
-	usb_serial_debug_data(debug, &port->dev, 
+	usb_serial_debug_data(debug, &port->dev,
 				__func__, urb->actual_length, data);
 
 	garmin_read_process(garmin_data_p, data, urb->actual_length);
@@ -1323,13 +1320,13 @@ static void garmin_read_bulk_callback (struct urb *urb)
 }
 
 
-static void garmin_read_int_callback (struct urb *urb)
+static void garmin_read_int_callback(struct urb *urb)
 {
 	unsigned long flags;
 	int retval;
 	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial = port->serial;
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
 
@@ -1355,30 +1352,31 @@ static void garmin_read_int_callback (struct urb *urb)
 
 	if (urb->actual_length == sizeof(GARMIN_BULK_IN_AVAIL_REPLY) &&
 	    0 == memcmp(data, GARMIN_BULK_IN_AVAIL_REPLY,
-		        sizeof(GARMIN_BULK_IN_AVAIL_REPLY))) {
+				sizeof(GARMIN_BULK_IN_AVAIL_REPLY))) {
 
 		dbg("%s - bulk data available.", __func__);
 
 		if (0 == (garmin_data_p->flags & FLAGS_BULK_IN_ACTIVE)) {
 
 			/* bulk data available */
-			usb_fill_bulk_urb (port->read_urb, serial->dev,
-					usb_rcvbulkpipe (serial->dev,
-					port->bulk_in_endpointAddress),
+			usb_fill_bulk_urb(port->read_urb, serial->dev,
+					usb_rcvbulkpipe(serial->dev,
+						port->bulk_in_endpointAddress),
 					port->read_urb->transfer_buffer,
 					port->read_urb->transfer_buffer_length,
 					garmin_read_bulk_callback, port);
 			retval = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 			if (retval) {
 				dev_err(&port->dev,
-					"%s - failed submitting read urb, error %d\n",
-				__func__, retval);
+				 "%s - failed submitting read urb, error %d\n",
+							__func__, retval);
 			} else {
 				spin_lock_irqsave(&garmin_data_p->lock, flags);
 				garmin_data_p->flags |= FLAGS_BULK_IN_ACTIVE;
 				/* do not send this packet to the user */
 				garmin_data_p->ignorePkts = 1;
-				spin_unlock_irqrestore(&garmin_data_p->lock, flags);
+				spin_unlock_irqrestore(&garmin_data_p->lock,
+									flags);
 			}
 		} else {
 			/* bulk-in transfer still active */
@@ -1389,15 +1387,15 @@ static void garmin_read_int_callback (struct urb *urb)
 
 	} else if (urb->actual_length == (4+sizeof(GARMIN_START_SESSION_REPLY))
 			 && 0 == memcmp(data, GARMIN_START_SESSION_REPLY,
-			                sizeof(GARMIN_START_SESSION_REPLY))) {
+					sizeof(GARMIN_START_SESSION_REPLY))) {
 
 		spin_lock_irqsave(&garmin_data_p->lock, flags);
 		garmin_data_p->flags |= FLAGS_SESSION_REPLY1_SEEN;
 		spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 
 		/* save the serial number */
-		garmin_data_p->serial_num 
-			= __le32_to_cpup((__le32*)(data+GARMIN_PKTHDR_LENGTH));
+		garmin_data_p->serial_num = __le32_to_cpup(
+					(__le32 *)(data+GARMIN_PKTHDR_LENGTH));
 
 		dbg("%s - start-of-session reply seen - serial %u.",
 			__func__, garmin_data_p->serial_num);
@@ -1416,7 +1414,7 @@ static void garmin_read_int_callback (struct urb *urb)
 	}
 
 	port->interrupt_in_urb->dev = port->serial->dev;
-	retval = usb_submit_urb (urb, GFP_ATOMIC);
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		dev_err(&urb->dev->dev,
 			"%s - Error %d submitting interrupt urb\n",
@@ -1429,7 +1427,7 @@ static void garmin_read_int_callback (struct urb *urb)
  * and then sets a timer to call itself again until all queued data
  * is sent.
  */
-static int garmin_flush_queue(struct garmin_data * garmin_data_p)
+static int garmin_flush_queue(struct garmin_data *garmin_data_p)
 {
 	unsigned long flags;
 	struct garmin_packet *pkt;
@@ -1454,7 +1452,7 @@ static int garmin_flush_queue(struct garmin_data * garmin_data_p)
 static void garmin_throttle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 	unsigned long flags;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -1466,10 +1464,10 @@ static void garmin_throttle(struct tty_struct *tty)
 }
 
 
-static void garmin_unthrottle (struct tty_struct *tty)
+static void garmin_unthrottle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 	unsigned long flags;
 	int status;
 
@@ -1513,7 +1511,7 @@ static int garmin_attach(struct usb_serial *serial)
 {
 	int status = 0;
 	struct usb_serial_port *port = serial->port[0];
-	struct garmin_data * garmin_data_p = NULL;
+	struct garmin_data *garmin_data_p = NULL;
 
 	dbg("%s", __func__);
 
@@ -1525,7 +1523,7 @@ static int garmin_attach(struct usb_serial *serial)
 	init_timer(&garmin_data_p->timer);
 	spin_lock_init(&garmin_data_p->lock);
 	INIT_LIST_HEAD(&garmin_data_p->pktlist);
-	//garmin_data_p->timer.expires = jiffies + session_timeout;
+	/* garmin_data_p->timer.expires = jiffies + session_timeout; */
 	garmin_data_p->timer.data = (unsigned long)garmin_data_p;
 	garmin_data_p->timer.function = timeout_handler;
 	garmin_data_p->port = port;
@@ -1542,13 +1540,13 @@ static int garmin_attach(struct usb_serial *serial)
 static void garmin_shutdown(struct usb_serial *serial)
 {
 	struct usb_serial_port *port = serial->port[0];
-	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 
 	dbg("%s", __func__);
 
-	usb_kill_urb (port->interrupt_in_urb);
+	usb_kill_urb(port->interrupt_in_urb);
 	del_timer_sync(&garmin_data_p->timer);
-	kfree (garmin_data_p);
+	kfree(garmin_data_p);
 	usb_set_serial_port_data(port, NULL);
 }
 
@@ -1578,7 +1576,7 @@ static struct usb_serial_driver garmin_device = {
 
 
 
-static int __init garmin_init (void)
+static int __init garmin_init(void)
 {
 	int retval;
 
@@ -1598,10 +1596,10 @@ failed_garmin_register:
 }
 
 
-static void __exit garmin_exit (void)
+static void __exit garmin_exit(void)
 {
-	usb_deregister (&garmin_driver);
-	usb_serial_deregister (&garmin_device);
+	usb_deregister(&garmin_driver);
+	usb_serial_deregister(&garmin_device);
 }
 
 
@@ -1610,8 +1608,8 @@ static void __exit garmin_exit (void)
 module_init(garmin_init);
 module_exit(garmin_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IWUSR | S_IRUGO);

