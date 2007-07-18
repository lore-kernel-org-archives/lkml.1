Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbXGRJTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbXGRJTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbXGRJTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:19:11 -0400
Received: from mail.atmel.fr ([81.80.104.162]:57453 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbXGRJTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:19:10 -0400
Message-ID: <469DDAE0.4010106@rfo.atmel.com>
Date: Wed, 18 Jul 2007 11:18:24 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] atmel_lcdfb: Use spare bits in 32bpp mode as alpha channel
References: <11826149894079-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <11826149894079-git-send-email-hskinnemoen@atmel.com>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Set var->transp.offset and var->transp.length in 32bpp mode to
indicate that the 8 otherwise unused bits can be used for
transparency.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
---
  drivers/video/atmel_lcdfb.c |    5 ++++-
  1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index a05491f..bb361ab 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -221,8 +221,11 @@ static int atmel_lcdfb_check_var(struct 
fb_var_screeninfo *var,
  		var->blue.offset = 10;
  		var->red.length = var->green.length = var->blue.length = 5;
  		break;
-	case 24:
  	case 32:
+		var->transp.offset = 24;
+		var->transp.length = 8;
+		/* fall through */
+	case 24:
  		var->red.offset = 0;
  		var->green.offset = 8;
  		var->blue.offset = 16;


