Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbYEYKcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbYEYKcn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761126AbYEYKY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43362 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762607AbYEYKYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:15 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Kirk Lapray <kirk_lapray@bigfoot.com>,
       Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCHv2 21/28] dvb frontends: treat firmware data as const
Message-Id: <E1K0DOJ-0007E8-50@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:51 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/media/dvb/frontends/bcm3510.c  |    5 +++--
 drivers/media/dvb/frontends/nxt200x.c  |    3 ++-
 drivers/media/dvb/frontends/or51211.c  |    4 ++--
 drivers/media/dvb/frontends/sp8870.c   |    2 +-
 drivers/media/dvb/frontends/sp887x.c   |    2 +-
 drivers/media/dvb/frontends/tda10048.c |    2 +-
 drivers/media/dvb/frontends/tda1004x.c |    2 +-
 7 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/frontends/bcm3510.c b/drivers/media/dvb/frontends/bcm3510.c
index d268e65..cf5e576 100644
--- a/drivers/media/dvb/frontends/bcm3510.c
+++ b/drivers/media/dvb/frontends/bcm3510.c
@@ -590,7 +590,8 @@ static void bcm3510_release(struct dvb_frontend* fe)
  */
 #define BCM3510_DEFAULT_FIRMWARE "dvb-fe-bcm3510-01.fw"
 
-static int bcm3510_write_ram(struct bcm3510_state *st, u16 addr, u8 *b, u16 len)
+static int bcm3510_write_ram(struct bcm3510_state *st, u16 addr, const u8 *b,
+			     u16 len)
 {
 	int ret = 0,i;
 	bcm3510_register_value vH, vL,vD;
@@ -614,7 +615,7 @@ static int bcm3510_download_firmware(struct dvb_frontend* fe)
 	struct bcm3510_state* st = fe->demodulator_priv;
 	const struct firmware *fw;
 	u16 addr,len;
-	u8  *b;
+	const u8 *b;
 	int ret,i;
 
 	deb_info("requesting firmware\n");
diff --git a/drivers/media/dvb/frontends/nxt200x.c b/drivers/media/dvb/frontends/nxt200x.c
index 23d0228..af29835 100644
--- a/drivers/media/dvb/frontends/nxt200x.c
+++ b/drivers/media/dvb/frontends/nxt200x.c
@@ -93,7 +93,8 @@ static u8 i2c_readbytes (struct nxt200x_state* state, u8 addr, u8* buf, u8 len)
 	return 0;
 }
 
-static int nxt200x_writebytes (struct nxt200x_state* state, u8 reg, u8 *buf, u8 len)
+static int nxt200x_writebytes (struct nxt200x_state* state, u8 reg,
+			       const u8 *buf, u8 len)
 {
 	u8 buf2 [len+1];
 	int err;
diff --git a/drivers/media/dvb/frontends/or51211.c b/drivers/media/dvb/frontends/or51211.c
index 7eaa476..6afe12a 100644
--- a/drivers/media/dvb/frontends/or51211.c
+++ b/drivers/media/dvb/frontends/or51211.c
@@ -69,7 +69,7 @@ struct or51211_state {
 	u32 current_frequency;
 };
 
-static int i2c_writebytes (struct or51211_state* state, u8 reg, u8 *buf,
+static int i2c_writebytes (struct or51211_state* state, u8 reg, const u8 *buf,
 			   int len)
 {
 	int err;
@@ -77,7 +77,7 @@ static int i2c_writebytes (struct or51211_state* state, u8 reg, u8 *buf,
 	msg.addr	= reg;
 	msg.flags	= 0;
 	msg.len		= len;
-	msg.buf		= buf;
+	msg.buf		= (u8 *)buf;
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
 		printk(KERN_WARNING "or51211: i2c_writebytes error "
diff --git a/drivers/media/dvb/frontends/sp8870.c b/drivers/media/dvb/frontends/sp8870.c
index aa78aa1..1c9a9b4 100644
--- a/drivers/media/dvb/frontends/sp8870.c
+++ b/drivers/media/dvb/frontends/sp8870.c
@@ -98,7 +98,7 @@ static int sp8870_readreg (struct sp8870_state* state, u16 reg)
 static int sp8870_firmware_upload (struct sp8870_state* state, const struct firmware *fw)
 {
 	struct i2c_msg msg;
-	char *fw_buf = fw->data;
+	const char *fw_buf = fw->data;
 	int fw_pos;
 	u8 tx_buf[255];
 	int tx_len;
diff --git a/drivers/media/dvb/frontends/sp887x.c b/drivers/media/dvb/frontends/sp887x.c
index 49f5587..4543609 100644
--- a/drivers/media/dvb/frontends/sp887x.c
+++ b/drivers/media/dvb/frontends/sp887x.c
@@ -140,7 +140,7 @@ static int sp887x_initial_setup (struct dvb_frontend* fe, const struct firmware
 	u8 buf [BLOCKSIZE+2];
 	int i;
 	int fw_size = fw->size;
-	unsigned char *mem = fw->data;
+	const unsigned char *mem = fw->data;
 
 	dprintk("%s\n", __func__);
 
diff --git a/drivers/media/dvb/frontends/tda10048.c b/drivers/media/dvb/frontends/tda10048.c
index 090fb7d..0ab8d86 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -233,7 +233,7 @@ static u8 tda10048_readreg(struct tda10048_state *state, u8 reg)
 }
 
 static int tda10048_writeregbulk(struct tda10048_state *state, u8 reg,
-	u8 *data, u16 len)
+				 const u8 *data, u16 len)
 {
 	int ret = -EREMOTEIO;
 	struct i2c_msg msg;
diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb/frontends/tda1004x.c
index 4997384..ff6b427 100644
--- a/drivers/media/dvb/frontends/tda1004x.c
+++ b/drivers/media/dvb/frontends/tda1004x.c
@@ -317,7 +317,7 @@ static int tda10046h_set_bandwidth(struct tda1004x_state *state,
 }
 
 static int tda1004x_do_upload(struct tda1004x_state *state,
-			      unsigned char *mem, unsigned int len,
+			      const unsigned char *mem, unsigned int len,
 			      u8 dspCodeCounterReg, u8 dspCodeInReg)
 {
 	u8 buf[65];
-- 
1.5.4.5

