Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbYBRNJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbYBRNJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbYBRNJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:09:15 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:55217 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbYBRNJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:09:14 -0500
Message-ID: <47B98376.5040906@tiscali.nl>
Date: Mon, 18 Feb 2008 14:09:10 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/sh/drivers/heartbeat.c ioremap is expected to succeed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

!unlikely(hd->base) is equivalent to likely(!hd->base) (for instance see
comments with commit fd312561adcc90e924f35d3032d5493aeb4c3017), I think
the ioremap is expected to succeed? please confirm that's right.
The patch below was *not* tested.
---
ioremap is expected to succeed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/sh/drivers/heartbeat.c b/arch/sh/drivers/heartbeat.c
index b76a14f..ab77b0e 100644
--- a/arch/sh/drivers/heartbeat.c
+++ b/arch/sh/drivers/heartbeat.c
@@ -93,7 +93,7 @@ static int heartbeat_drv_probe(struct platform_device *pdev)
 	}
 
 	hd->base = ioremap_nocache(res->start, res->end - res->start + 1);
-	if (!unlikely(hd->base)) {
+	if (unlikely(!hd->base)) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 
 		if (!pdev->dev.platform_data)
