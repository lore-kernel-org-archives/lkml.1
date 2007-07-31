Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbXGaRsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbXGaRsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbXGaRsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:48:13 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1030 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbXGaRsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:48:12 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 27] drivers/input/serio/gscps2.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:48:11 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Helge Deller <deller@gmx.de>, linux-input@atrey.karlin.mff.cuni.cz
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311948.11520.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/input/serio/gscps2.c | 11696 -> 11607 (-89 bytes)

 drivers/input/serio/gscps2.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/input/serio/gscps2.c	2007-07-26 13:07:44.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/input/serio/gscps2.c	2007-07-30 00:12:31.000000000 +0200
@@ -340,8 +340,8 @@ static int __init gscps2_probe(struct pa
 	if (dev->id.sversion == 0x96)
 		hpa += GSC_DINO_OFFSET;

-	ps2port = kmalloc(sizeof(struct gscps2port), GFP_KERNEL);
-	serio = kmalloc(sizeof(struct serio), GFP_KERNEL);
+	ps2port = kzalloc(sizeof(struct gscps2port), GFP_KERNEL);
+	serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
 	if (!ps2port || !serio) {
 		ret = -ENOMEM;
 		goto fail_nomem;
@@ -349,8 +349,6 @@ static int __init gscps2_probe(struct pa

 	dev_set_drvdata(&dev->dev, ps2port);

-	memset(ps2port, 0, sizeof(struct gscps2port));
-	memset(serio, 0, sizeof(struct serio));
 	ps2port->port = serio;
 	ps2port->padev = dev;
 	ps2port->addr = ioremap_nocache(hpa, GSC_STATUS + 4);
