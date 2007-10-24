Return-Path: <linux-kernel-owner+w=401wt.eu-S1763551AbXJXQlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763551AbXJXQlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbXJXQZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:25:45 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60960 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759401AbXJXQZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:25:20 -0400
Date: Wed, 24 Oct 2007 18:25:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fujitsu-laptop.c: remove dead code
Message-ID: <20071024162549.GB30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dead code spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/drivers/misc/fujitsu-laptop.c.old	2007-10-23 18:51:10.000000000 +0200
+++ linux-2.6/drivers/misc/fujitsu-laptop.c	2007-10-23 18:51:50.000000000 +0200
@@ -110,33 +110,30 @@ static int get_lcd_level(void)
 
 	// Get the Brightness
 	status =
 	    acpi_evaluate_integer(fujitsu->acpi_handle, "GBLL", NULL, &state);
 	if (status < 0)
 		return status;
 
 	fujitsu->fuj02b1_state = state;
 	fujitsu->brightness_level = state & 0x0fffffff;
 
 	if (state & 0x80000000)
 		fujitsu->brightness_changed = 1;
 	else
 		fujitsu->brightness_changed = 0;
 
-	if (status < 0)
-		return status;
-
 	return fujitsu->brightness_level;
 }
 
 /* Backlight device stuff */
 
 static int bl_get_brightness(struct backlight_device *b)
 {
 	return get_lcd_level();
 }
 
 static int bl_update_status(struct backlight_device *b)
 {
 	return set_lcd_level(b->props.brightness);
 }
 

