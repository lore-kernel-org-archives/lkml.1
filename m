Return-Path: <linux-kernel-owner+w=401wt.eu-S1764479AbYEYKbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764479AbYEYKbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761951AbYEYKYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43332 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762240AbYEYKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:14 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 01/28] libertas: treat firmware data as const
Message-Id: <E1K0DNx-0007Cq-Uy@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:29 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_cs.c   |    2 +-
 drivers/net/wireless/libertas/if_sdio.c |    4 ++--
 drivers/net/wireless/libertas/if_usb.c  |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 54280e2..d075b44 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -122,7 +122,7 @@ static inline void if_cs_write16(struct if_cs_card *card, uint reg, u16 val)
 static inline void if_cs_write16_rep(
 	struct if_cs_card *card,
 	uint reg,
-	void *buf,
+	const void *buf,
 	unsigned long count)
 {
 	if (debug_output)
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 51f664b..3dd537b 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -392,7 +392,7 @@ static int if_sdio_prog_helper(struct if_sdio_card *card)
 	unsigned long timeout;
 	u8 *chunk_buffer;
 	u32 chunk_size;
-	u8 *firmware;
+	const u8 *firmware;
 	size_t size;
 
 	lbs_deb_enter(LBS_DEB_SDIO);
@@ -508,7 +508,7 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
 	unsigned long timeout;
 	u8 *chunk_buffer;
 	u32 chunk_size;
-	u8 *firmware;
+	const u8 *firmware;
 	size_t size, req_size;
 
 	lbs_deb_enter(LBS_DEB_SDIO);
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 8032df7..a25b670 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -293,7 +293,7 @@ static void if_usb_disconnect(struct usb_interface *intf)
 static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
 {
 	struct fwdata *fwdata = cardp->ep_out_buf;
-	uint8_t *firmware = cardp->fw->data;
+	const uint8_t *firmware = cardp->fw->data;
 
 	/* If we got a CRC failure on the last block, back
 	   up and retry it */
@@ -746,7 +746,7 @@ static int if_usb_issue_boot_command(struct if_usb_card *cardp, int ivalue)
  *         len               image length
  *  @return     0 or -1
  */
-static int check_fwfile_format(uint8_t *data, uint32_t totlen)
+static int check_fwfile_format(const uint8_t *data, uint32_t totlen)
 {
 	uint32_t bincmd, exit;
 	uint32_t blksize, offset, len;
-- 
1.5.4.5

