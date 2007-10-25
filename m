Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbXJYFd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbXJYFd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXJYFdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:33:19 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:35528 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbXJYFdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:33:18 -0400
X-Greylist: delayed 1527 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 01:33:17 EDT
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200710250508.l9P58exp003251@turbo.physics.adelaide.edu.au>
Subject: Re: [2.6 patch] fujitsu-laptop.c: remove dead code
To: bunk@kernel.org (Adrian Bunk)
Date: Thu, 25 Oct 2007 14:38:40 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org
In-Reply-To: <20071024162549.GB30533@stusta.de> from "Adrian Bunk" at Oct 24, 2007 06:25:49 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch removes dead code spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Ack.

Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

jonathan

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
 
