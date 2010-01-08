Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904Ab0AHXGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0AHXGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 18:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273Ab0AHXGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 18:06:13 -0500
Received: from [206.15.93.42] ([206.15.93.42]:12339 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752219Ab0AHXGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 18:06:11 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] i2o_proc: remove unnecessary casts of void *
Date: Fri, 8 Jan 2010 16:06:09 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001081606.09314.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2o_proc: remove unnecessary casts of void *

void pointers do not need to be cast to other pointer types.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/message/i2o/i2o_proc.c b/drivers/message/i2o/i2o_proc.c
index 7045c45..93ff739 100644
--- a/drivers/message/i2o/i2o_proc.c
+++ b/drivers/message/i2o/i2o_proc.c
@@ -296,8 +296,8 @@ static char *bus_strings[] = {
 
 static int i2o_seq_show_hrt(struct seq_file *seq, void *v)
 {
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
-	i2o_hrt *hrt = (i2o_hrt *) c->hrt.virt;
+	struct i2o_controller *c = seq->private;
+	i2o_hrt *hrt = c->hrt.virt;
 	u32 bus;
 	int i;
 
@@ -397,8 +397,8 @@ static int i2o_seq_show_hrt(struct seq_file *seq, void *v)
 
 static int i2o_seq_show_lct(struct seq_file *seq, void *v)
 {
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
-	i2o_lct *lct = (i2o_lct *) c->lct;
+	struct i2o_controller *c = seq->private;
+	i2o_lct *lct = c->lct;
 	int entries;
 	int i;
 
@@ -527,7 +527,7 @@ static int i2o_seq_show_lct(struct seq_file *seq, void *v)
 
 static int i2o_seq_show_status(struct seq_file *seq, void *v)
 {
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
+	struct i2o_controller *c = seq->private;
 	char prodstr[25];
 	int version;
 	i2o_status_block *sb = c->status_block.virt;
@@ -724,7 +724,7 @@ static int i2o_seq_show_status(struct seq_file *seq, void *v)
 
 static int i2o_seq_show_hw(struct seq_file *seq, void *v)
 {
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
+	struct i2o_controller *c = seq->private;
 	static u32 work32[5];
 	static u8 *work8 = (u8 *) work32;
 	static u16 *work16 = (u16 *) work32;
@@ -781,7 +781,7 @@ static int i2o_seq_show_hw(struct seq_file *seq, void *v)
 /* Executive group 0003h - Executing DDM List (table) */
 static int i2o_seq_show_ddm_table(struct seq_file *seq, void *v)
 {
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
+	struct i2o_controller *c = seq->private;
 	int token;
 	int i;
 
@@ -857,7 +857,7 @@ static int i2o_seq_show_ddm_table(struct seq_file *seq, void *v)
 /* Executive group 0004h - Driver Store (scalar) */
 static int i2o_seq_show_driver_store(struct seq_file *seq, void *v)
 {
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
+	struct i2o_controller *c = seq->private;
 	u32 work32[8];
 	int token;
 
@@ -893,7 +893,7 @@ static int i2o_seq_show_drivers_stored(struct seq_file *seq, void *v)
 		u32 module_flags;
 	} i2o_driver_store_table;
 
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
+	struct i2o_controller *c = seq->private;
 	int token;
 	int i;
 
@@ -959,7 +959,7 @@ static int i2o_seq_show_drivers_stored(struct seq_file *seq, void *v)
 /* Generic group F000h - Params Descriptor (table) */
 static int i2o_seq_show_groups(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 	int i;
 	u8 properties;
@@ -1035,7 +1035,7 @@ static int i2o_seq_show_groups(struct seq_file *seq, void *v)
 /* Generic group F001h - Physical Device Table (table) */
 static int i2o_seq_show_phys_device(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 	int i;
 
@@ -1076,7 +1076,7 @@ static int i2o_seq_show_phys_device(struct seq_file *seq, void *v)
 /* Generic group F002h - Claimed Table (table) */
 static int i2o_seq_show_claimed(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 	int i;
 
@@ -1116,7 +1116,7 @@ static int i2o_seq_show_claimed(struct seq_file *seq, void *v)
 /* Generic group F003h - User Table (table) */
 static int i2o_seq_show_users(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 	int i;
 
@@ -1170,7 +1170,7 @@ static int i2o_seq_show_users(struct seq_file *seq, void *v)
 /* Generic group F005h - Private message extensions (table) (optional) */
 static int i2o_seq_show_priv_msgs(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 	int i;
 
@@ -1219,7 +1219,7 @@ static int i2o_seq_show_priv_msgs(struct seq_file *seq, void *v)
 /* Generic group F006h - Authorized User Table (table) */
 static int i2o_seq_show_authorized_users(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 	int i;
 
@@ -1260,7 +1260,7 @@ static int i2o_seq_show_authorized_users(struct seq_file *seq, void *v)
 /* Generic group F100h - Device Identity (scalar) */
 static int i2o_seq_show_dev_identity(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	static u32 work32[128];	// allow for "stuff" + up to 256 byte (max) serial number
 	// == (allow) 512d bytes (max)
 	static u16 *work16 = (u16 *) work32;
@@ -1298,7 +1298,7 @@ static int i2o_seq_show_dev_identity(struct seq_file *seq, void *v)
 
 static int i2o_seq_show_dev_name(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 
 	seq_printf(seq, "%s\n", dev_name(&d->device));
 
@@ -1308,7 +1308,7 @@ static int i2o_seq_show_dev_name(struct seq_file *seq, void *v)
 /* Generic group F101h - DDM Identity (scalar) */
 static int i2o_seq_show_ddm_identity(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 
 	struct {
@@ -1345,7 +1345,7 @@ static int i2o_seq_show_ddm_identity(struct seq_file *seq, void *v)
 /* Generic group F102h - User Information (scalar) */
 static int i2o_seq_show_uinfo(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 
 	struct {
@@ -1377,7 +1377,7 @@ static int i2o_seq_show_uinfo(struct seq_file *seq, void *v)
 /* Generic group F103h - SGL Operating Limits (scalar) */
 static int i2o_seq_show_sgl_limits(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	static u32 work32[12];
 	static u16 *work16 = (u16 *) work32;
 	static u8 *work8 = (u8 *) work32;
@@ -1424,7 +1424,7 @@ static int i2o_seq_show_sgl_limits(struct seq_file *seq, void *v)
 /* Generic group F200h - Sensors (scalar) */
 static int i2o_seq_show_sensors(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 
 	struct {
