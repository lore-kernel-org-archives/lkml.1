Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYG2GDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYG2GDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbYG2GB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:01:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:29879 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbYG2GBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=GQ2SM+ITVDEY751il1o141VbQeH8Xq4H/uKMnLHrFSe+m6dUdPfB60uzxVhy/4EQtp
         MO+E1u3A9mlsa2wMpghJ6z3fTz4k11ho4OVwL8O11wp/csWNydxfhrP0BFxA8o21X6fy
         jbTHzeqPze0RHPCkNcMKjTR/o78KhUCtbijWk=
Subject: [PATCH 5/8] media: drx397xD replace __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 23:01:35 -0700
Message-Id: <1217311296.23389.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/dvb/frontends/drx397xD.c |   34 ++++++++++++++++----------------
 drivers/media/dvb/frontends/drx397xD.h |    2 +-
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/frontends/drx397xD.c b/drivers/media/dvb/frontends/drx397xD.c
index 3cbed87..e19147b 100644
--- a/drivers/media/dvb/frontends/drx397xD.c
+++ b/drivers/media/dvb/frontends/drx397xD.c
@@ -96,7 +96,7 @@ static void drx_release_fw(struct drx397xD_state *s)
 {
 	fw_ix_t ix = s->chip_rev;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	write_lock(&fw[ix].lock);
 	if (fw[ix].refcnt) {
@@ -113,7 +113,7 @@ static int drx_load_fw(struct drx397xD_state *s, fw_ix_t ix)
 	size_t size, len;
 	int i = 0, j, rc = -EINVAL;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	if (ix < 0 || ix >= ARRAY_SIZE(fw))
 		return -EINVAL;
@@ -197,10 +197,10 @@ static int write_fw(struct drx397xD_state *s, blob_ix_t ix)
 	int len, rc = 0, i = 0;
 
 	if (ix < 0 || ix >= ARRAY_SIZE(blob_name)) {
-		pr_debug("%s drx_fw_ix_t out of range\n", __FUNCTION__);
+		pr_debug("%s drx_fw_ix_t out of range\n", __func__);
 		return -EINVAL;
 	}
-	pr_debug("%s %s\n", __FUNCTION__, blob_name[ix]);
+	pr_debug("%s %s\n", __func__, blob_name[ix]);
 
 	read_lock(&fw[s->chip_rev].lock);
 	data = fw[s->chip_rev].data[ix];
@@ -305,7 +305,7 @@ static int PLL_Set(struct drx397xD_state *s,
 	u32 f_tuner, f = fep->frequency;
 	int rc;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	if ((f > s->frontend.ops.tuner_ops.info.frequency_max) ||
 	    (f < s->frontend.ops.tuner_ops.info.frequency_min))
@@ -325,7 +325,7 @@ static int PLL_Set(struct drx397xD_state *s,
 		return rc;
 
 	*df_tuner = f_tuner - f;
-	pr_debug("%s requested %d [Hz] tuner %d [Hz]\n", __FUNCTION__, f,
+	pr_debug("%s requested %d [Hz] tuner %d [Hz]\n", __func__, f,
 		 f_tuner);
 
 	return 0;
@@ -340,7 +340,7 @@ static int SC_WaitForReady(struct drx397xD_state *s)
 	int cnt = 1000;
 	int rc;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	while (cnt--) {
 		rc = RD16(s, 0x820043);
@@ -354,7 +354,7 @@ static int SC_SendCommand(struct drx397xD_state *s, int cmd)
 {
 	int rc;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	WR16(s, 0x820043, cmd);
 	SC_WaitForReady(s);
@@ -368,7 +368,7 @@ static int HI_Command(struct drx397xD_state *s, u16 cmd)
 {
 	int rc, cnt = 1000;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	rc = WR16(s, 0x420032, cmd);
 	if (rc < 0)
@@ -389,7 +389,7 @@ static int HI_Command(struct drx397xD_state *s, u16 cmd)
 static int HI_CfgCommand(struct drx397xD_state *s)
 {
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	WR16(s, 0x420033, 0x3973);
 	WR16(s, 0x420034, s->config.w50);	// code 4, log 4
@@ -419,7 +419,7 @@ static int SetCfgIfAgc(struct drx397xD_state *s, struct drx397xD_CfgIfAgc *agc)
 	u16 w0C = agc->w0C;
 	int quot, rem, i, rc = -EINVAL;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	if (agc->w04 > 0x3ff)
 		goto exit_rc;
@@ -478,7 +478,7 @@ static int SetCfgRfAgc(struct drx397xD_state *s, struct drx397xD_CfgRfAgc *agc)
 	u16 w06 = agc->w06;
 	int rc = -1;
 
-	pr_debug("%s %d 0x%x 0x%x\n", __FUNCTION__, agc->d00, w04, w06);
+	pr_debug("%s %d 0x%x 0x%x\n", __func__, agc->d00, w04, w06);
 
 	if (w04 > 0x3ff)
 		goto exit_rc;
@@ -554,7 +554,7 @@ static int CorrectSysClockDeviation(struct drx397xD_state *s)
 	int lockstat;
 	u32 clk, clk_limit;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	if (s->config.d5C == 0) {
 		EXIT_RC(WR16(s, 0x08200e8, 0x010));
@@ -598,7 +598,7 @@ static int CorrectSysClockDeviation(struct drx397xD_state *s)
 
 	if (clk - s->config.f_osc * 1000 + clk_limit <= 2 * clk_limit) {
 		s->f_osc = clk;
-		pr_debug("%s: osc %d %d [Hz]\n", __FUNCTION__,
+		pr_debug("%s: osc %d %d [Hz]\n", __func__,
 			 s->config.f_osc * 1000, clk - s->config.f_osc * 1000);
 	}
 	rc = WR16(s, 0x08200e8, 0);
@@ -610,7 +610,7 @@ static int ConfigureMPEGOutput(struct drx397xD_state *s, int type)
 {
 	int rc, si, bp;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	si = s->config.wA0;
 	if (s->config.w98 == 0) {
@@ -646,7 +646,7 @@ static int drx_tune(struct drx397xD_state *s,
 
 	int rc, df_tuner;
 	int a, b, c, d;
-	pr_debug("%s %d\n", __FUNCTION__, s->config.d60);
+	pr_debug("%s %d\n", __func__, s->config.d60);
 
 	if (s->config.d60 != 2)
 		goto set_tuner;
@@ -1082,7 +1082,7 @@ static int drx397x_init(struct dvb_frontend *fe)
 	struct drx397xD_state *s = fe->demodulator_priv;
 	int rc;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	s->config.rfagc.d00 = 2;	/* 0x7c */
 	s->config.rfagc.w04 = 0;
diff --git a/drivers/media/dvb/frontends/drx397xD.h b/drivers/media/dvb/frontends/drx397xD.h
index ddc7a07..2ad1ea0 100644
--- a/drivers/media/dvb/frontends/drx397xD.h
+++ b/drivers/media/dvb/frontends/drx397xD.h
@@ -122,7 +122,7 @@ extern struct dvb_frontend* drx397xD_attach(const struct drx397xD_config *config
 static inline struct dvb_frontend* drx397xD_attach(const struct drx397xD_config *config,
 					   struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif /* CONFIG_DVB_DRX397XD */
-- 
1.6.0.rc1.154.ge3fc


