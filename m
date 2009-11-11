Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbZKKWJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbZKKWJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbZKKWJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:09:15 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:10520 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759443AbZKKWJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:09:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=BwEyOTaXxeBepwibl43TRHOZ+VYbf9Jonr3m1zVzgj+PfCBRWAq5qMpi8dRLFPNkvl
         bjlJtu8gW6sVupuEu2wQYGqmV6qAuc68oBPsUsLLCy6KkG3KOypesQnwWk6yJKZnfILn
         WiFlm63qYbTWI0noLkhojekTTBTuw1NsZZy+o=
Message-ID: <4AFB38DE.6040408@gmail.com>
Date: Wed, 11 Nov 2009 23:21:18 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: sudhakar.raj@ti.com, linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] video: Fix error return
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return should be negative on errors

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/video/da8xx-fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index d065894..035d568 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -704,7 +704,7 @@ static int __init fb_probe(struct platform_device *device)
 
 	if (i == ARRAY_SIZE(known_lcd_panels)) {
 		dev_err(&device->dev, "GLCD: No valid panel found\n");
-		ret = ENODEV;
+		ret = -ENODEV;
 		goto err_clk_disable;
 	} else
 		dev_info(&device->dev, "GLCD: Found %s panel\n",
