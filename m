Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbXKERJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbXKERJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757387AbXKERHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:07:01 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59480 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757381AbXKERGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:06:54 -0500
Date: Mon, 5 Nov 2007 18:06:31 +0100
From: Adrian Bunk <bunk@kernel.org>
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb/bt8xx/dst.c: make code static
Message-ID: <20071105170631.GA12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global code static:
- dst_gpio_outb()
- dst_gpio_inb()
- rdc_8820_reset()
- dst_pio_enable()
- dst_command()
- struct tuner_list[]

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/dvb/bt8xx/dst.c        |   19 ++++++++-----------
 drivers/media/dvb/bt8xx/dst_common.h |    5 -----
 2 files changed, 8 insertions(+), 16 deletions(-)

--- linux-2.6.17-rc1-mm3-full/drivers/media/dvb/bt8xx/dst_common.h.old	2006-04-19 21:44:07.000000000 +0200
+++ linux-2.6.17-rc1-mm3-full/drivers/media/dvb/bt8xx/dst_common.h	2006-04-19 21:46:25.000000000 +0200
@@ -140,10 +140,8 @@
 };
 
 int rdc_reset_state(struct dst_state *state);
-int rdc_8820_reset(struct dst_state *state);
 
 int dst_wait_dst_ready(struct dst_state *state, u8 delay_mode);
-int dst_pio_enable(struct dst_state *state);
 int dst_pio_disable(struct dst_state *state);
 int dst_error_recovery(struct dst_state* state);
 int dst_error_bailout(struct dst_state *state);
@@ -154,3 +152,0 @@
-int dst_gpio_outb(struct dst_state* state, u32 mask, u32 enbb, u32 outhigh, int delay);
-
-int dst_command(struct dst_state* state, u8 * data, u8 len);
--- linux-2.6.17-rc1-mm3-full/drivers/media/dvb/bt8xx/dst.c.old	2006-04-19 21:44:21.000000000 +0200
+++ linux-2.6.17-rc1-mm3-full/drivers/media/dvb/bt8xx/dst.c	2006-04-19 21:46:51.000000000 +0200
@@ -63,4 +63,5 @@
 } while(0)
 
+static int dst_command(struct dst_state *state, u8 *data, u8 len);
 
 static void dst_packsize(struct dst_state *state, int psize)
@@ -72,7 +73,8 @@
 	bt878_device_control(state->bt, DST_IG_TS, &bits);
 }
 
-int dst_gpio_outb(struct dst_state *state, u32 mask, u32 enbb, u32 outhigh, int delay)
+static int dst_gpio_outb(struct dst_state *state, u32 mask, u32 enbb,
+			 u32 outhigh, int delay)
 {
 	union dst_gpio_packet enb;
 	union dst_gpio_packet bits;
@@ -101,9 +103,8 @@
 
 	return 0;
 }
-EXPORT_SYMBOL(dst_gpio_outb);
 
-int dst_gpio_inb(struct dst_state *state, u8 *result)
+static int dst_gpio_inb(struct dst_state *state, u8 *result)
 {
 	union dst_gpio_packet rd_packet;
 	int err;
@@ -117,7 +118,6 @@
 
 	return 0;
 }
-EXPORT_SYMBOL(dst_gpio_inb);
 
 int rdc_reset_state(struct dst_state *state)
 {
@@ -137,7 +137,7 @@
 }
 EXPORT_SYMBOL(rdc_reset_state);
 
-int rdc_8820_reset(struct dst_state *state)
+static int rdc_8820_reset(struct dst_state *state)
 {
 	dprintk(verbose, DST_DEBUG, 1, "Resetting DST");
 	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, 0, NO_DELAY) < 0) {
@@ -152,9 +152,8 @@
 
 	return 0;
 }
-EXPORT_SYMBOL(rdc_8820_reset);
 
-int dst_pio_enable(struct dst_state *state)
+static int dst_pio_enable(struct dst_state *state)
 {
 	if (dst_gpio_outb(state, ~0, RDC_8820_PIO_0_ENABLE, 0, NO_DELAY) < 0) {
 		dprintk(verbose, DST_ERROR, 1, "dst_gpio_outb ERROR !");
@@ -164,7 +163,6 @@
 
 	return 0;
 }
-EXPORT_SYMBOL(dst_pio_enable);
 
 int dst_pio_disable(struct dst_state *state)
 {
@@ -958,7 +956,7 @@
 	return 0;
 }
 
-int dst_command(struct dst_state *state, u8 *data, u8 len)
+static int dst_command(struct dst_state *state, u8 *data, u8 len)
 {
 	u8 reply;
 

e525c676f3a21db66c08f903b7d3397792b03aee 
diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
index b7a17e6..7f854ee 100644
--- a/drivers/media/dvb/bt8xx/dst.c
+++ b/drivers/media/dvb/bt8xx/dst.c
@@ -611,7 +611,7 @@ static int dst_type_print(struct dst_state *state, u8 type)
 	return 0;
 }
 
-struct tuner_types tuner_list[] = {
+static struct tuner_types tuner_list[] = {
 	{
 		.tuner_type = TUNER_TYPE_L64724,
 		.tuner_name = "L 64724",
@@ -1287,7 +1287,6 @@ error:
 	return -EIO;
 
 }
-EXPORT_SYMBOL(dst_command);
 
 static int dst_get_signal(struct dst_state *state)
 {
