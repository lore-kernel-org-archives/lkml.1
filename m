Return-Path: <linux-kernel-owner+w=401wt.eu-S1762060AbYETTYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762060AbYETTYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbYETTYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:24:14 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:60163 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318AbYETTYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UXai5tf1lTzr8rDzuJedIMafP4eJIRQ6Ox1ZLK+JLcBKTBsDVHE25QLzWOaweuVJ/QWIzNqO3GyLXQ+80NyC4xwQpN8OtRlikqgFvS/xA0WmGciaV+RvE0bPaJ1MI1RlIbbjcMuB2fQDtpGEXjBHsjA0GK6hJ0xI1jJyFqV8FNE=
Subject: [PATCH 1/2] Remove all users of cpu_to_{le|be}{16|32|64}p
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 12:24:08 -0700
Message-Id: <1211311449.5915.193.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
akpm: applies on top of the 21-patch aligned get/put helpers series.

 arch/sparc64/lib/PeeCeeI.c      |   16 ++++++++--------
 drivers/i2c/busses/i2c-pmcmsp.c |    2 +-
 drivers/isdn/hisax/st5481_usb.c |    4 ++--
 drivers/net/usb/kaweth.c        |    6 +++---
 drivers/net/usb/pegasus.c       |   12 ++++++------
 drivers/usb/class/cdc-acm.c     |    5 +++--
 drivers/usb/core/message.c      |    6 +++---
 drivers/usb/gadget/net2280.c    |    2 +-
 drivers/usb/host/ohci.h         |    8 ++------
 9 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/arch/sparc64/lib/PeeCeeI.c b/arch/sparc64/lib/PeeCeeI.c
index f85a50f..a00686f 100644
--- a/arch/sparc64/lib/PeeCeeI.c
+++ b/arch/sparc64/lib/PeeCeeI.c
@@ -55,7 +55,7 @@ void outsl(unsigned long __addr, const void *src, unsigned long count)
 		if ((((u64)src) & 0x3) == 0) {
 			u32 *p = (u32 *)src;
 			while (count--) {
-				u32 val = cpu_to_le32p(p);
+				u32 val = cpu_to_le32(*p);
 				outl(val, addr);
 				p++;
 			}
@@ -68,17 +68,17 @@ void outsl(unsigned long __addr, const void *src, unsigned long count)
 			switch (((u64)src) & 0x3) {
 			case 0x2:
 				count -= 1;
-				l = cpu_to_le16p(ps) << 16;
+				l = cpu_to_le16(*ps) << 16;
 				ps++;
 				pi = (u32 *)ps;
 				while (count--) {
-					l2 = cpu_to_le32p(pi);
+					l2 = cpu_to_le32(*pi);
 					pi++;
 					outl(((l >> 16) | (l2 << 16)), addr);
 					l = l2;
 				}
 				ps = (u16 *)pi;
-				l2 = cpu_to_le16p(ps);
+				l2 = cpu_to_le16(*ps);
 				outl(((l >> 16) | (l2 << 16)), addr);
 				break;
 
@@ -87,12 +87,12 @@ void outsl(unsigned long __addr, const void *src, unsigned long count)
 				pb = (u8 *)src;
 				l = (*pb++ << 8);
 				ps = (u16 *)pb;
-				l2 = cpu_to_le16p(ps);
+				l2 = cpu_to_le16(*ps);
 				ps++;
 				l |= (l2 << 16);
 				pi = (u32 *)ps;
 				while (count--) {
-					l2 = cpu_to_le32p(pi);
+					l2 = cpu_to_le32(*pi);
 					pi++;
 					outl(((l >> 8) | (l2 << 24)), addr);
 					l = l2;
@@ -107,13 +107,13 @@ void outsl(unsigned long __addr, const void *src, unsigned long count)
 				l = (*pb++ << 24);
 				pi = (u32 *)pb;
 				while (count--) {
-					l2 = cpu_to_le32p(pi);
+					l2 = cpu_to_le32(*pi);
 					pi++;
 					outl(((l >> 24) | (l2 << 8)), addr);
 					l = l2;
 				}
 				ps = (u16 *)pi;
-				l2 = cpu_to_le16p(ps);
+				l2 = cpu_to_le16(*ps);
 				ps++;
 				pb = (u8 *)ps;
 				l2 |= (*pb << 16);
diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index 63b3e2c..977eb55 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -486,7 +486,7 @@ static enum pmcmsptwi_xfer_result pmcmsptwi_xfer_cmd(
 
 	if (cmd->type == MSP_TWI_CMD_WRITE ||
 	    cmd->type == MSP_TWI_CMD_WRITE_READ) {
-		__be64 tmp = cpu_to_be64p((u64 *)cmd->write_data);
+		__be64 tmp = cpu_to_be64(*(u64 *)cmd->write_data);
 		tmp >>= (MSP_MAX_BYTES_PER_RW - cmd->write_len) * 8;
 		dev_dbg(&pmcmsptwi_adapter.dev, "Writing 0x%016llx\n", tmp);
 		pmcmsptwi_writel(tmp & 0x00000000ffffffffLL,
diff --git a/drivers/isdn/hisax/st5481_usb.c b/drivers/isdn/hisax/st5481_usb.c
index 427a8b0..4639c02 100644
--- a/drivers/isdn/hisax/st5481_usb.c
+++ b/drivers/isdn/hisax/st5481_usb.c
@@ -73,8 +73,8 @@ static void usb_ctrl_msg(struct st5481_adapter *adapter,
    
 	ctrl_msg->dr.bRequestType = requesttype;
 	ctrl_msg->dr.bRequest = request;
-	ctrl_msg->dr.wValue = cpu_to_le16p(&value);
-	ctrl_msg->dr.wIndex = cpu_to_le16p(&index);
+	ctrl_msg->dr.wValue = cpu_to_le16(value);
+	ctrl_msg->dr.wIndex = cpu_to_le16(index);
 	ctrl_msg->dr.wLength = 0;
 	ctrl_msg->complete = complete;
 	ctrl_msg->context = context;
diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index 0cff7e1..b50c022 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -280,9 +280,9 @@ static int kaweth_control(struct kaweth_device *kaweth,
 
 	dr->bRequestType= requesttype;
 	dr->bRequest = request;
-	dr->wValue = cpu_to_le16p(&value);
-	dr->wIndex = cpu_to_le16p(&index);
-	dr->wLength = cpu_to_le16p(&size);
+	dr->wValue = cpu_to_le16(value);
+	dr->wIndex = cpu_to_le16(index);
+	dr->wLength = cpu_to_le16(size);
 
 	return kaweth_internal_control_msg(kaweth->dev,
 					pipe,
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 2a4f981..d7043af 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -149,8 +149,8 @@ static int get_registers(pegasus_t * pegasus, __u16 indx, __u16 size,
 	pegasus->dr.bRequestType = PEGASUS_REQT_READ;
 	pegasus->dr.bRequest = PEGASUS_REQ_GET_REGS;
 	pegasus->dr.wValue = cpu_to_le16(0);
-	pegasus->dr.wIndex = cpu_to_le16p(&indx);
-	pegasus->dr.wLength = cpu_to_le16p(&size);
+	pegasus->dr.wIndex = cpu_to_le16(indx);
+	pegasus->dr.wLength = cpu_to_le16(size);
 	pegasus->ctrl_urb->transfer_buffer_length = size;
 
 	usb_fill_control_urb(pegasus->ctrl_urb, pegasus->usb,
@@ -207,8 +207,8 @@ static int set_registers(pegasus_t * pegasus, __u16 indx, __u16 size,
 	pegasus->dr.bRequestType = PEGASUS_REQT_WRITE;
 	pegasus->dr.bRequest = PEGASUS_REQ_SET_REGS;
 	pegasus->dr.wValue = cpu_to_le16(0);
-	pegasus->dr.wIndex = cpu_to_le16p(&indx);
-	pegasus->dr.wLength = cpu_to_le16p(&size);
+	pegasus->dr.wIndex = cpu_to_le16(indx);
+	pegasus->dr.wLength = cpu_to_le16(size);
 	pegasus->ctrl_urb->transfer_buffer_length = size;
 
 	usb_fill_control_urb(pegasus->ctrl_urb, pegasus->usb,
@@ -260,7 +260,7 @@ static int set_register(pegasus_t * pegasus, __u16 indx, __u8 data)
 	pegasus->dr.bRequestType = PEGASUS_REQT_WRITE;
 	pegasus->dr.bRequest = PEGASUS_REQ_SET_REG;
 	pegasus->dr.wValue = cpu_to_le16(data);
-	pegasus->dr.wIndex = cpu_to_le16p(&indx);
+	pegasus->dr.wIndex = cpu_to_le16(indx);
 	pegasus->dr.wLength = cpu_to_le16(1);
 	pegasus->ctrl_urb->transfer_buffer_length = 1;
 
@@ -475,7 +475,7 @@ static inline void get_node_id(pegasus_t * pegasus, __u8 * id)
 
 	for (i = 0; i < 3; i++) {
 		read_eprom_word(pegasus, i, &w16);
-		((__le16 *) id)[i] = cpu_to_le16p(&w16);
+		((__le16 *)id)[i] = cpu_to_le16(w16);
 	}
 }
 
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 63c3404..93310c0 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -736,8 +736,9 @@ static void acm_tty_set_termios(struct tty_struct *tty, struct ktermios *termios
 	if (!ACM_READY(acm))
 		return;
 
-	newline.dwDTERate = cpu_to_le32p(acm_tty_speed +
-		(termios->c_cflag & CBAUD & ~CBAUDEX) + (termios->c_cflag & CBAUDEX ? 15 : 0));
+	newline.dwDTERate = cpu_to_le32(acm_tty_speed[
+			    (termios->c_cflag & CBAUD & ~CBAUDEX) +
+			    (termios->c_cflag & CBAUDEX ? 15 : 0)]);
 	newline.bCharFormat = termios->c_cflag & CSTOPB ? 2 : 0;
 	newline.bParityType = termios->c_cflag & PARENB ?
 		(termios->c_cflag & PARODD ? 1 : 2) + (termios->c_cflag & CMSPAR ? 2 : 0) : 0;
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index fe47d14..d260b5f 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -139,9 +139,9 @@ int usb_control_msg(struct usb_device *dev, unsigned int pipe, __u8 request,
 
 	dr->bRequestType = requesttype;
 	dr->bRequest = request;
-	dr->wValue = cpu_to_le16p(&value);
-	dr->wIndex = cpu_to_le16p(&index);
-	dr->wLength = cpu_to_le16p(&size);
+	dr->wValue = cpu_to_le16(value);
+	dr->wIndex = cpu_to_le16(index);
+	dr->wLength = cpu_to_le16(size);
 
 	/* dbg("usb_control_msg"); */
 
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index cb8a3ab..37e5f2e 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -668,7 +668,7 @@ fill_dma_desc (struct net2280_ep *ep, struct net2280_request *req, int valid)
 
 	/* 2280 may be polling VALID_BIT through ep->dma->dmadesc */
 	wmb ();
-	td->dmacount = cpu_to_le32p (&dmacount);
+	td->dmacount = cpu_to_le32(dmacount);
 }
 
 static const u32 dmactl_default =
diff --git a/drivers/usb/host/ohci.h b/drivers/usb/host/ohci.h
index a1b55dc..79f7406 100644
--- a/drivers/usb/host/ohci.h
+++ b/drivers/usb/host/ohci.h
@@ -588,9 +588,7 @@ static inline __hc16 cpu_to_hc16 (const struct ohci_hcd *ohci, const u16 x)
 
 static inline __hc16 cpu_to_hc16p (const struct ohci_hcd *ohci, const u16 *x)
 {
-	return big_endian_desc(ohci) ?
-		cpu_to_be16p(x) :
-		cpu_to_le16p(x);
+	return big_endian_desc(ohci) ? cpu_to_be16(*x) : cpu_to_le16(*x);
 }
 
 static inline __hc32 cpu_to_hc32 (const struct ohci_hcd *ohci, const u32 x)
@@ -602,9 +600,7 @@ static inline __hc32 cpu_to_hc32 (const struct ohci_hcd *ohci, const u32 x)
 
 static inline __hc32 cpu_to_hc32p (const struct ohci_hcd *ohci, const u32 *x)
 {
-	return big_endian_desc(ohci) ?
-		cpu_to_be32p(x) :
-		cpu_to_le32p(x);
+	return big_endian_desc(ohci) ? cpu_to_be32(*x) : cpu_to_le32(*x);
 }
 
 /* ohci to cpu */
-- 
1.5.5.1.570.g26b5e


