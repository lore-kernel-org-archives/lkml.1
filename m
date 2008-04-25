Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYDYAyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYDYAyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 20:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYDYAyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 20:54:22 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37280 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbYDYAyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 20:54:21 -0400
Date: Fri, 25 Apr 2008 03:53:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] xc3028_{agc,bw}_config namespace fix
Message-ID: <20080425005334.GF18854@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  LD      drivers/media/built-in.o
drivers/media/dvb/built-in.o:(.data+0x1be6c): multiple definition of `xc3028_agc_config'
drivers/media/video/built-in.o:(.data+0x36500): first defined here
drivers/media/dvb/built-in.o:(.data+0x1be9c): multiple definition of `xc3028_bw_config'
drivers/media/video/built-in.o:(.data+0x36530): first defined here
make[3]: *** [drivers/media/built-in.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/dvb/dvb-usb/dib0700_devices.c |    4 ++--
 drivers/media/video/cx23885/cx23885-dvb.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

7c8ba386f39d5e17821e37999ce9d484878af751 diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 6477fc6..3462238 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -299,7 +299,7 @@ static int stk7700d_tuner_attach(struct dvb_usb_adapter *adap)
 }
 
 /* STK7700-PH: Digital/Analog Hybrid Tuner, e.h. Cinergy HT USB HE */
-struct dibx000_agc_config xc3028_agc_config = {
+static struct dibx000_agc_config xc3028_agc_config = {
 	BAND_VHF | BAND_UHF,       /* band_caps */
 
 	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=0,
@@ -342,7 +342,7 @@ struct dibx000_agc_config xc3028_agc_config = {
 };
 
 /* PLL Configuration for COFDM BW_MHz = 8.00 with external clock = 30.00 */
-struct dibx000_bandwidth_config xc3028_bw_config = {
+static struct dibx000_bandwidth_config xc3028_bw_config = {
 	60000, 30000, /* internal, sampling */
 	1, 8, 3, 1, 0, /* pll_cfg: prediv, ratio, range, reset, bypass */
 	0, 0, 1, 1, 0, /* misc: refdiv, bypclk_div, IO_CLK_en_core, ADClkSrc,
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 870d6e1..f056497 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -191,7 +191,7 @@ static struct tda18271_config hauppauge_hvr1200_tuner_config = {
 	.gate    = TDA18271_GATE_ANALOG,
 };
 
-struct dibx000_agc_config xc3028_agc_config = {
+static struct dibx000_agc_config xc3028_agc_config = {
 	BAND_VHF | BAND_UHF,	/* band_caps */
 
 	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=0,
@@ -237,7 +237,7 @@ struct dibx000_agc_config xc3028_agc_config = {
 
 /* PLL Configuration for COFDM BW_MHz = 8.000000
  * With external clock = 30.000000 */
-struct dibx000_bandwidth_config xc3028_bw_config = {
+static struct dibx000_bandwidth_config xc3028_bw_config = {
 	60000,	/* internal */
 	30000,	/* sampling */
 	1,	/* pll_cfg: prediv */

