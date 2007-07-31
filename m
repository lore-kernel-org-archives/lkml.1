Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbXGaQ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbXGaQ4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763391AbXGaQ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:56:09 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4088 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764243AbXGaQ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:56:08 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 03] drivers/sbus/char/bbc_envctrl.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 18:56:07 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       davem@davemloft.net
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311856.07368.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/sbus/char/bbc_envctrl.c | 16622 -> 16580 (-42 bytes)

 drivers/sbus/char/bbc_envctrl.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/sbus/char/bbc_envctrl.c	2007-07-26 13:07:43.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/sbus/char/bbc_envctrl.c	2007-07-31 13:58:44.000000000 +0200
@@ -479,11 +479,12 @@ static int kenvctrld(void *__unused)

 static void attach_one_temp(struct linux_ebus_child *echild, int temp_idx)
 {
-	struct bbc_cpu_temperature *tp = kmalloc(sizeof(*tp), GFP_KERNEL);
-
+	struct bbc_cpu_temperature *tp;
+
+	tp = kzalloc(sizeof(*tp), GFP_KERNEL);
 	if (!tp)
 		return;
-	memset(tp, 0, sizeof(*tp));
+
 	tp->client = bbc_i2c_attach(echild);
 	if (!tp->client) {
 		kfree(tp);
@@ -525,11 +526,12 @@ static void attach_one_temp(struct linux

 static void attach_one_fan(struct linux_ebus_child *echild, int fan_idx)
 {
-	struct bbc_fan_control *fp = kmalloc(sizeof(*fp), GFP_KERNEL);
-
+	struct bbc_fan_control *fp;
+
+	fp = kzalloc(sizeof(*fp), GFP_KERNEL);
 	if (!fp)
 		return;
-	memset(fp, 0, sizeof(*fp));
+
 	fp->client = bbc_i2c_attach(echild);
 	if (!fp->client) {
 		kfree(fp);
