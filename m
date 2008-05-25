Return-Path: <linux-kernel-owner+w=401wt.eu-S1762447AbYEYK0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762447AbYEYK0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760491AbYEYKXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762080AbYEYKXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:46 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 10/28] ueagle-atm: treat firmware data as const
Message-Id: <E1K0DO7-0007DQ-Ea@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:39 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/usb/atm/ueagle-atm.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 5f71ff3..cb01b51 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -579,7 +579,7 @@ MODULE_PARM_DESC(annex,
  * uea_send_modem_cmd - Send a command for pre-firmware devices.
  */
 static int uea_send_modem_cmd(struct usb_device *usb,
-		u16 addr, u16 size, u8 * buff)
+			      u16 addr, u16 size, const u8 *buff)
 {
 	int ret = -ENOMEM;
 	u8 *xfer_buff;
@@ -604,7 +604,8 @@ static int uea_send_modem_cmd(struct usb_device *usb,
 static void uea_upload_pre_firmware(const struct firmware *fw_entry, void *context)
 {
 	struct usb_device *usb = context;
-	u8 *pfw, value;
+	const u8 *pfw;
+	u8 value;
 	u32 crc = 0;
 	int ret, size;
 
@@ -720,7 +721,7 @@ static int uea_load_firmware(struct usb_device *usb, unsigned int ver)
 /*
  * Make sure that the DSP code provided is safe to use.
  */
-static int check_dsp_e1(u8 *dsp, unsigned int len)
+static int check_dsp_e1(const u8 *dsp, unsigned int len)
 {
 	u8 pagecount, blockcount;
 	u16 blocksize;
@@ -771,7 +772,7 @@ static int check_dsp_e1(u8 *dsp, unsigned int len)
 	return 0;
 }
 
-static int check_dsp_e4(u8 *dsp, int len)
+static int check_dsp_e4(const u8 *dsp, int len)
 {
 	int i;
 	struct l1_code *p = (struct l1_code *) dsp;
@@ -819,7 +820,7 @@ static int check_dsp_e4(u8 *dsp, int len)
 /*
  * send data to the idma pipe
  * */
-static int uea_idma_write(struct uea_softc *sc, void *data, u32 size)
+static int uea_idma_write(struct uea_softc *sc, const void *data, u32 size)
 {
 	int ret = -ENOMEM;
 	u8 *xfer_buff;
@@ -903,7 +904,7 @@ static void uea_load_page_e1(struct work_struct *work)
 	u16 ovl = sc->ovl;
 	struct block_info_e1 bi;
 
-	u8 *p;
+	const u8 *p;
 	u8 pagecount, blockcount;
 	u16 blockaddr, blocksize;
 	u32 pageoffset;
@@ -986,7 +987,7 @@ static void __uea_load_page_e4(struct uea_softc *sc, u8 pageno, int boot)
 	bi.wReserved = cpu_to_be16(UEA_RESERVED);
 
 	do {
-		u8 *blockoffset;
+		const u8 *blockoffset;
 		unsigned int blocksize;
 
 		blockidx = &p->page_header[blockno];
@@ -1095,7 +1096,7 @@ static inline int wait_cmv_ack(struct uea_softc *sc)
 #define UCDC_SEND_ENCAPSULATED_COMMAND 0x00
 
 static int uea_request(struct uea_softc *sc,
-		u16 value, u16 index, u16 size, void *data)
+		u16 value, u16 index, u16 size, const void *data)
 {
 	u8 *xfer_buff;
 	int ret = -ENOMEM;
@@ -1891,7 +1892,8 @@ static int load_XILINX_firmware(struct uea_softc *sc)
 {
 	const struct firmware *fw_entry;
 	int ret, size, u, ln;
-	u8 *pfw, value;
+	const u8 *pfw;
+	u8 value;
 	char *fw_name = FW_DIR "930-fpga.bin";
 
 	uea_enters(INS_TO_USBDEV(sc));
-- 
1.5.4.5

