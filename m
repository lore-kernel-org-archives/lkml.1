Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbXCTRqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbXCTRqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXCTRqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:46:53 -0400
Received: from honk1.physik.uni-konstanz.de ([134.34.140.224]:38274 "EHLO
	honk1.physik.uni-konstanz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895AbXCTRqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:46:52 -0400
X-Greylist: delayed 1240 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 13:46:52 EDT
Date: Tue, 20 Mar 2007 18:21:40 +0100
From: Guido Guenther <agx@sigxcpu.org>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>
Subject: [patch] rivafb: fix initial brightness
Message-ID: <20070320172140.GA28000@bogon.ms20.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this is the rivafb equivalent of
238576e12fef1d52751c6e08db2d0bdb0e248caf. It fixes rivafb having a
default backlight brightness of 0 (no picture at all) on a PBook 6,1.
Since this is a regression over 2.6.20, can this go into 2.6.21?
Cheers,
 -- Guido

Signed-Off-By: Guido Guenther <agx@sigxcpu.org>

diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index 1d1c7c6..d7ece8d 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -285,8 +285,6 @@ static const struct riva_regs reg_template = {
 #define MAX_LEVEL 0x534
 #define LEVEL_STEP ((MAX_LEVEL - MIN_LEVEL) / FB_BACKLIGHT_MAX)
 
-static struct backlight_properties riva_bl_data;
-
 static int riva_bl_get_level_brightness(struct riva_par *par,
 		int level)
 {
@@ -372,7 +370,7 @@ static void riva_bl_init(struct riva_par *par)
 		FB_BACKLIGHT_MAX);
 
 	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
-	bd->props.brightness = riva_bl_data.max_brightness;
+	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
 	backlight_update_status(bd);
 

