Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYLIS4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYLIS4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYLIS4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:56:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:43712 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbYLIS4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:56:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=mYNLryZR7fnWvAei4L5Nt4YHU1QpPj29j2Bso/Uf/luNVTvcxMg7yvEy10q9vUOm3W
         tzXs71Q+heIVHLYHZ16pwJRU/a2cnUzJFM56txu2MqnSK4YaxwWui7fh7BzLniTj0CmG
         nfbweWmrRT2WF7hR3FBqoLnkeimBXAvghynz0=
Message-ID: <493EBF48.7020701@gmail.com>
Date: Tue, 09 Dec 2008 19:56:08 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: v4l-dvb-maintainer@linuxtv.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/33] DVB: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/media/dvb/dm1105/dm1105.c          |    4 ++--
 drivers/media/dvb/dvb-core/dvb_frontend.c  |   25 ++++++++++++++-----------
 drivers/media/dvb/dvb-usb/anysee.c         |    2 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c |    4 ++--
 drivers/media/dvb/frontends/cx24116.c      |    2 +-
 5 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index c1d92f8..a0bc379 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -507,7 +507,7 @@ static void input_register_keys(struct infrared *ir)
 	ir->input_dev->keycodemax = ARRAY_SIZE(ir->key_map);
 }
 
-int __devinit dm1105_ir_init(struct dm1105dvb *dm1105)
+static int __devinit dm1105_ir_init(struct dm1105dvb *dm1105)
 {
 	struct input_dev *input_dev;
 	int err;
@@ -551,7 +551,7 @@ int __devinit dm1105_ir_init(struct dm1105dvb *dm1105)
 }
 
 
-void __devexit dm1105_ir_exit(struct dm1105dvb *dm1105)
+static void __devexit dm1105_ir_exit(struct dm1105dvb *dm1105)
 {
 	tasklet_kill(&dm1105->ir.ir_tasklet);
 	input_unregister_device(dm1105->ir.input_dev);
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 7a421e9..a432c1a 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -764,7 +764,7 @@ static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
 	return 0;
 }
 
-struct dtv_cmds_h dtv_cmds[] = {
+static struct dtv_cmds_h dtv_cmds[] = {
 	[DTV_TUNE] = {
 		.name	= "DTV_TUNE",
 		.cmd	= DTV_TUNE,
@@ -902,7 +902,7 @@ struct dtv_cmds_h dtv_cmds[] = {
 	},
 };
 
-void dtv_property_dump(struct dtv_property *tvp)
+static void dtv_property_dump(struct dtv_property *tvp)
 {
 	int i;
 
@@ -933,7 +933,7 @@ void dtv_property_dump(struct dtv_property *tvp)
 		dprintk("%s() tvp.u.data = 0x%08x\n", __func__, tvp->u.data);
 }
 
-int is_legacy_delivery_system(fe_delivery_system_t s)
+static int is_legacy_delivery_system(fe_delivery_system_t s)
 {
 	if((s == SYS_UNDEFINED) || (s == SYS_DVBC_ANNEX_AC) ||
 	   (s == SYS_DVBC_ANNEX_B) || (s == SYS_DVBT) || (s == SYS_DVBS) ||
@@ -947,7 +947,8 @@ int is_legacy_delivery_system(fe_delivery_system_t s)
  * drivers can use a single set_frontend tuning function, regardless of whether
  * it's being used for the legacy or new API, reducing code and complexity.
  */
-void dtv_property_cache_sync(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+static void dtv_property_cache_sync(struct dvb_frontend *fe,
+		struct dvb_frontend_parameters *p)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
@@ -999,7 +1000,7 @@ void dtv_property_cache_sync(struct dvb_frontend *fe, struct dvb_frontend_parame
 /* Ensure the cached values are set correctly in the frontend
  * legacy tuning structures, for the advanced tuning API.
  */
-void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
+static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -1054,7 +1055,7 @@ void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
 /* Ensure the cached values are set correctly in the frontend
  * legacy tuning structures, for the legacy tuning API.
  */
-void dtv_property_adv_params_sync(struct dvb_frontend *fe)
+static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -1089,7 +1090,7 @@ void dtv_property_adv_params_sync(struct dvb_frontend *fe)
 	}
 }
 
-void dtv_property_cache_submit(struct dvb_frontend *fe)
+static void dtv_property_cache_submit(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
@@ -1120,8 +1121,9 @@ static int dvb_frontend_ioctl_legacy(struct inode *inode, struct file *file,
 static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
 			unsigned int cmd, void *parg);
 
-int dtv_property_process_get(struct dvb_frontend *fe, struct dtv_property *tvp,
-	struct inode *inode, struct file *file)
+static int dtv_property_process_get(struct dvb_frontend *fe,
+		struct dtv_property *tvp, struct inode *inode,
+		struct file *file)
 {
 	int r = 0;
 
@@ -1193,8 +1195,9 @@ int dtv_property_process_get(struct dvb_frontend *fe, struct dtv_property *tvp,
 	return r;
 }
 
-int dtv_property_process_set(struct dvb_frontend *fe, struct dtv_property *tvp,
-	struct inode *inode, struct file *file)
+static int dtv_property_process_set(struct dvb_frontend *fe,
+		struct dtv_property *tvp, struct inode *inode,
+		struct file *file)
 {
 	int r = 0;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index cd2edbc..c9eda4e 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -41,7 +41,7 @@
 static int dvb_usb_anysee_debug;
 module_param_named(debug, dvb_usb_anysee_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level" DVB_USB_DEBUG_STATUS);
-int dvb_usb_anysee_delsys;
+static int dvb_usb_anysee_delsys;
 module_param_named(delsys, dvb_usb_anysee_delsys, int, 0644);
 MODULE_PARM_DESC(delsys, "select delivery mode (0=DVB-C, 1=DVB-T)");
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-core.c b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
index 3ac9f74..ef23719 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
@@ -32,7 +32,7 @@
 
 /* debug */
 int dvb_usb_cinergyt2_debug;
-int disable_remote;
+static int disable_remote;
 
 module_param_named(debug, dvb_usb_cinergyt2_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info, xfer=2, rc=4 "
@@ -45,7 +45,7 @@ struct cinergyt2_state {
 };
 
 /* We are missing a release hook with usb_device data */
-struct dvb_usb_device *cinergyt2_usb_device;
+static struct dvb_usb_device *cinergyt2_usb_device;
 
 static struct dvb_usb_device_properties cinergyt2_properties;
 
diff --git a/drivers/media/dvb/frontends/cx24116.c b/drivers/media/dvb/frontends/cx24116.c
index b144b30..74f9750 100644
--- a/drivers/media/dvb/frontends/cx24116.c
+++ b/drivers/media/dvb/frontends/cx24116.c
@@ -368,7 +368,7 @@ static int cx24116_set_inversion(struct cx24116_state *state,
  * Not all S2 mmodulation schemes are support and not all rates with
  * a scheme are support. Especially, no auto detect when in S2 mode.
  */
-struct cx24116_modfec {
+static struct cx24116_modfec {
 	fe_delivery_system_t delivery_system;
 	fe_modulation_t modulation;
 	fe_code_rate_t fec;

