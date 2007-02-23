Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbXBWOVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbXBWOVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409AbXBWOVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:21:24 -0500
Received: from lx1.pxnet.com ([195.227.45.3]:33034 "EHLO lx1.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbXBWOVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:21:23 -0500
Date: Fri, 23 Feb 2007 15:21:08 +0100
Message-Id: <200702231421.l1NEL8E0029791@lx1.pxnet.com>
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH] drivers/isdn/gigaset: mark some static data as const (v2)
To: Andrew Morton <akpm@osdl.org>, Karsten Keil <kkeil@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i4ldeveloper@listserv.isdn4linux.de
CC: Hansjoerg Lipp <hjlipp@web.de>
In-Reply-To: <200702231128.l1NBS9R5025966@lx1.pxnet.com>
References: <200702231128.l1NBS9R5025966@lx1.pxnet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>

Mark some static arrays as const that aren't and shouldn't be modified,
and remove incorrect static attribute from some variables.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Hansjoerg Lipp <hjlipp@web.de>

---

In the first submission, one of the hunks got accidentally reversed.
Please replace by this one. Thanks.

 bas-gigaset.c |    4 ++--
 common.c      |    6 +++---
 ev-layer.c    |    4 ++--
 isocdata.c    |    4 ++--
 ser-gigaset.c |    2 +-
 usb-gigaset.c |    4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff -purX linux-2.6.20-work/Documentation/dontdiff linux-2.6.21-rc1-orig/drivers/isdn/gigaset/bas-gigaset.c linux-2.6.21-rc1-work/drivers/isdn/gigaset/bas-gigaset.c
--- linux-2.6.21-rc1-orig/drivers/isdn/gigaset/bas-gigaset.c	2007-02-17 15:08:56.000000000 +0100
+++ linux-2.6.21-rc1-work/drivers/isdn/gigaset/bas-gigaset.c	2007-02-23 00:12:58.000000000 +0100
@@ -54,7 +54,7 @@ MODULE_PARM_DESC(cidmode, "Call-ID mode"
 #define USB_SX353_PRODUCT_ID    0x0022
 
 /* table of devices that work with this driver */
-static struct usb_device_id gigaset_table [] = {
+static const struct usb_device_id gigaset_table [] = {
 	{ USB_DEVICE(USB_GIGA_VENDOR_ID, USB_3070_PRODUCT_ID) },
 	{ USB_DEVICE(USB_GIGA_VENDOR_ID, USB_3075_PRODUCT_ID) },
 	{ USB_DEVICE(USB_GIGA_VENDOR_ID, USB_SX303_PRODUCT_ID) },
@@ -2305,7 +2305,7 @@ static void gigaset_disconnect(struct us
 	gigaset_unassign(cs);
 }
 
-static struct gigaset_ops gigops = {
+static const struct gigaset_ops gigops = {
 	gigaset_write_cmd,
 	gigaset_write_room,
 	gigaset_chars_in_buffer,
diff -purX linux-2.6.20-work/Documentation/dontdiff linux-2.6.21-rc1-orig/drivers/isdn/gigaset/common.c linux-2.6.21-rc1-work/drivers/isdn/gigaset/common.c
--- linux-2.6.21-rc1-orig/drivers/isdn/gigaset/common.c	2007-02-07 22:22:18.000000000 +0100
+++ linux-2.6.21-rc1-work/drivers/isdn/gigaset/common.c	2007-02-23 00:02:10.000000000 +0100
@@ -944,8 +944,8 @@ static DEFINE_SPINLOCK(driver_lock);
 struct cardstate *gigaset_get_cs_by_id(int id)
 {
 	unsigned long flags;
-	static struct cardstate *ret = NULL;
-	static struct cardstate *cs;
+	struct cardstate *ret = NULL;
+	struct cardstate *cs;
 	struct gigaset_driver *drv;
 	unsigned i;
 
@@ -999,7 +999,7 @@ void gigaset_debugdrivers(void)
 static struct cardstate *gigaset_get_cs_by_minor(unsigned minor)
 {
 	unsigned long flags;
-	static struct cardstate *ret = NULL;
+	struct cardstate *ret = NULL;
 	struct gigaset_driver *drv;
 	unsigned index;
 
diff -purX linux-2.6.20-work/Documentation/dontdiff linux-2.6.21-rc1-orig/drivers/isdn/gigaset/ev-layer.c linux-2.6.21-rc1-work/drivers/isdn/gigaset/ev-layer.c
--- linux-2.6.21-rc1-orig/drivers/isdn/gigaset/ev-layer.c	2007-02-07 21:56:37.000000000 +0100
+++ linux-2.6.21-rc1-work/drivers/isdn/gigaset/ev-layer.c	2007-02-23 00:21:24.000000000 +0100
@@ -409,7 +409,7 @@ static struct reply_t tab_cid[] = /* no 
 };
 #endif
 
-static struct resp_type_t resp_type[]=
+static const struct resp_type_t resp_type[] =
 {
 	/*{"",		RSP_EMPTY,	RT_NOTHING},*/
 	{"OK",		RSP_OK,		RT_NOTHING},
@@ -511,7 +511,7 @@ void gigaset_handle_modem_response(struc
 	unsigned char *argv[MAX_REC_PARAMS + 1];
 	int params;
 	int i, j;
-	struct resp_type_t *rt;
+	const struct resp_type_t *rt;
 	int curarg;
 	unsigned long flags;
 	unsigned next, tail, head;
diff -purX linux-2.6.20-work/Documentation/dontdiff linux-2.6.21-rc1-orig/drivers/isdn/gigaset/isocdata.c linux-2.6.21-rc1-work/drivers/isdn/gigaset/isocdata.c
--- linux-2.6.21-rc1-orig/drivers/isdn/gigaset/isocdata.c	2007-02-17 15:06:39.000000000 +0100
+++ linux-2.6.21-rc1-work/drivers/isdn/gigaset/isocdata.c	2007-02-21 12:46:09.000000000 +0100
@@ -274,7 +274,7 @@ static inline void dump_bytes(enum debug
  *        bit 12..10 = number of trailing '1' bits in result
  *        bit 14..13 = number of bits added by stuffing
  */
-static u16 stufftab[5 * 256] = {
+static const u16 stufftab[5 * 256] = {
 // previous 1s = 0:
  0x0000, 0x0001, 0x0002, 0x0003, 0x0004, 0x0005, 0x0006, 0x0007, 0x0008, 0x0009, 0x000a, 0x000b, 0x000c, 0x000d, 0x000e, 0x000f,
  0x0010, 0x0011, 0x0012, 0x0013, 0x0014, 0x0015, 0x0016, 0x0017, 0x0018, 0x0019, 0x001a, 0x001b, 0x001c, 0x001d, 0x001e, 0x201f,
@@ -629,7 +629,7 @@ static inline void hdlc_frag(struct bc_s
  *		     (replacing 8 by 7 to make it fit; the algorithm won't care)
  *        bit 7 set if there are 5 or more "interior" consecutive '1' bits
  */
-static unsigned char bitcounts[256] = {
+static const unsigned char bitcounts[256] = {
   0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x04,
   0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x05,
   0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x04,
diff -purX linux-2.6.20-work/Documentation/dontdiff linux-2.6.21-rc1-orig/drivers/isdn/gigaset/ser-gigaset.c linux-2.6.21-rc1-work/drivers/isdn/gigaset/ser-gigaset.c
--- linux-2.6.21-rc1-orig/drivers/isdn/gigaset/ser-gigaset.c	2007-02-07 23:25:32.000000000 +0100
+++ linux-2.6.21-rc1-work/drivers/isdn/gigaset/ser-gigaset.c	2007-02-23 00:11:04.000000000 +0100
@@ -459,7 +459,7 @@ static int gigaset_set_line_ctrl(struct 
 	return -EINVAL;
 }
 
-static struct gigaset_ops ops = {
+static const struct gigaset_ops ops = {
 	gigaset_write_cmd,
 	gigaset_write_room,
 	gigaset_chars_in_buffer,
diff -purX linux-2.6.20-work/Documentation/dontdiff linux-2.6.21-rc1-orig/drivers/isdn/gigaset/usb-gigaset.c linux-2.6.21-rc1-work/drivers/isdn/gigaset/usb-gigaset.c
--- linux-2.6.21-rc1-orig/drivers/isdn/gigaset/usb-gigaset.c	2006-12-19 01:38:19.000000000 +0100
+++ linux-2.6.21-rc1-work/drivers/isdn/gigaset/usb-gigaset.c	2007-02-23 00:11:03.000000000 +0100
@@ -50,7 +50,7 @@ MODULE_PARM_DESC(cidmode, "Call-ID mode"
 #define USB_M105_PRODUCT_ID	0x0009
 
 /* table of devices that work with this driver */
-static struct usb_device_id gigaset_table [] = {
+static const struct usb_device_id gigaset_table [] = {
 	{ USB_DEVICE(USB_M105_VENDOR_ID, USB_M105_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
@@ -860,7 +860,7 @@ static void gigaset_disconnect(struct us
 	gigaset_unassign(cs);
 }
 
-static struct gigaset_ops ops = {
+static const struct gigaset_ops ops = {
 	gigaset_write_cmd,
 	gigaset_write_room,
 	gigaset_chars_in_buffer,
