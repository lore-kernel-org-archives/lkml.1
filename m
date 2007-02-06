Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbXBFQDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbXBFQDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXBFQDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:03:38 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:57604 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbXBFQDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:03:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=o2kGHJ1zRtXe8GOQ5Syd2qmOWe9KNf54ldxw5unDT5ELREbOM76SK2nrCwqg6t5nEnlx2enzoRDIyLy05lf7bcrp4CexCd57Nnwk/kVARXRo7XDxzOoUS0+igumQ5Ua8npIn8NuNacsC4tH6D5qkj0o+6HBTiQBPJt9LBshwK5Q=
Date: Tue, 6 Feb 2007 18:03:23 +0200
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] DVB: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160323.GB8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Patch is compile-tested.

diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
index 9f72b70..0393a3d 100644
--- a/drivers/media/dvb/bt8xx/dst.c
+++ b/drivers/media/dvb/bt8xx/dst.c
@@ -1161,7 +1161,7 @@ static int dst_get_device_id(struct dst_state *state)
 		}
 	}
 
-	if (i >= sizeof (dst_tlist) / sizeof (dst_tlist [0])) {
+	if (i >= ARRAY_SIZE(dst_tlist)) {
 		dprintk(verbose, DST_ERROR, 1, "Unable to recognize %s or %s", &state->rxbuffer[0], &state->rxbuffer[1]);
 		dprintk(verbose, DST_ERROR, 1, "please email linux-dvb@linuxtv.org with this type in");
 		use_dst_type = DST_TYPE_IS_SAT;
diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
index 3e35931..5185a3c 100644
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
@@ -213,7 +214,7 @@ static int cx24108_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend
 		freq = 2150000; /* satellite IF is 950..2150MHz */
 
 	/* decide which VCO to use for the input frequency */
-	for(i=1;(i<sizeof(osci)/sizeof(osci[0]))&&(osci[i]<freq);i++);
+	for(i=1;(i<ARRAY_SIZE(osci))&&(osci[i]<freq);i++);
 	printk("cx24108 debug: select vco #%d (f=%d)\n",i,freq);
 	band=bandsel[i];
 	/* the gain values must be set by SetSymbolrate */
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index ae96395..96ae6b1 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -254,7 +254,7 @@ static int cx24110_set_symbolrate (struct cx24110_state* state, u32 srate)
 	if (srate<500000)
 		srate=500000;
 
-	for(i=0;(i<sizeof(bands)/sizeof(bands[0]))&&(srate>bands[i]);i++)
+	for(i=0;(i<ARRAY_SIZE(bands))&&(srate>bands[i]);i++)
 		;
 	/* first, check which sample rate is appropriate: 45, 60 80 or 90 MHz,
 	   and set the PLL accordingly (R07[1:0] Fclk, R06[7:4] PLLmult,
@@ -361,7 +361,7 @@ static int cx24110_initfe(struct dvb_frontend* fe)
 
 	dprintk("%s: init chip\n", __FUNCTION__);
 
-	for(i=0;i<sizeof(cx24110_regdata)/sizeof(cx24110_regdata[0]);i++) {
+	for(i=0;i<ARRAY_SIZE(cx24110_regdata);i++) {
 		cx24110_writereg(state, cx24110_regdata[i].reg, cx24110_regdata[i].data);
 	};
 
diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/frontends/cx24123.c
index a356d28..732e94a 100644
--- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -507,7 +507,7 @@ static int cx24123_pll_calculate(struct dvb_frontend* fe, struct dvb_frontend_pa
 	int i = 0;
 	int pump = 2;
 	int band = 0;
-	int num_bands = sizeof(cx24123_bandselect_vals) / sizeof(cx24123_bandselect_vals[0]);
+	int num_bands = ARRAY_SIZE(cx24123_bandselect_vals);
 
 	/* Defaults for low freq, low rate */
 	state->VCAarg = cx24123_AGC_vals[0].VCAprogdata;
@@ -516,7 +516,7 @@ static int cx24123_pll_calculate(struct dvb_frontend* fe, struct dvb_frontend_pa
 	vco_div = cx24123_bandselect_vals[0].VCOdivider;
 
 	/* For the given symbol rate, determine the VCA, VGA and FILTUNE programming bits */
-	for (i = 0; i < sizeof(cx24123_AGC_vals) / sizeof(cx24123_AGC_vals[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(cx24123_AGC_vals); i++)
 	{
 		if ((cx24123_AGC_vals[i].symbolrate_low <= p->u.qpsk.symbol_rate) &&
 		    (cx24123_AGC_vals[i].symbolrate_high >= p->u.qpsk.symbol_rate) ) {
@@ -658,7 +658,7 @@ static int cx24123_initfe(struct dvb_frontend* fe)
 	dprintk("%s:  init frontend\n",__FUNCTION__);
 
 	/* Configure the demod to a good set of defaults */
-	for (i = 0; i < sizeof(cx24123_regdata) / sizeof(cx24123_regdata[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(cx24123_regdata); i++)
 		cx24123_writereg(state, cx24123_regdata[i].reg, cx24123_regdata[i].data);
 
 	/* Set the LNB polarity */
diff --git a/drivers/media/dvb/ttpci/av7110_ir.c b/drivers/media/dvb/ttpci/av7110_ir.c
index e4544ea..c281d78 100644
--- a/drivers/media/dvb/ttpci/av7110_ir.c
+++ b/drivers/media/dvb/ttpci/av7110_ir.c
@@ -4,6 +4,7 @@
 #include <linux/moduleparam.h>
 #include <linux/input.h>
 #include <linux/proc_fs.h>
+#include <linux/kernel.h>
 #include <asm/bitops.h>
 
 #include "av7110.h"
@@ -217,7 +218,7 @@ int __devinit av7110_ir_init(struct av7110 *av7110)
 	static struct proc_dir_entry *e;
 	int err;
 
-	if (av_cnt >= sizeof av_list/sizeof av_list[0])
+	if (av_cnt >= ARRAY_SIZE(av_list))
 		return -ENOSPC;
 
 	av7110_setup_irc_config(av7110, 0x0001);

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
