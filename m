Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbYC2W5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbYC2W5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 18:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYC2W5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 18:57:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58413 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYC2W5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 18:57:13 -0400
Date: Sat, 29 Mar 2008 23:32:41 +0100
From: Pavel Machek <pavel@suse.cz>
To: perex@perex.cz, kernel list <linux-kernel@vger.kernel.org>, tiwai@suse.de
Subject: usb audio: Fix another Dallas quirk
Message-ID: <20080329223241.GA5348@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dallas USB speakers are buggy in more than one way. One of configs
they offer does not work at all.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index 257a4e1..b6b2490 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
 	int format;
 	struct audioformat *fp;
 	unsigned char *fmt, *csep;
+	int num;
 
 	dev = chip->dev;
 
 	/* parse the interface's altsettings */
 	iface = usb_ifnum_to_if(dev, iface_no);
-	for (i = 0; i < iface->num_altsetting; i++) {
+	num = iface->num_altsetting;
+
+	/* Dallas DS4201 workaround: It presents 5 altsettings, but the last
+	   one misses syncpipe, and does not produce any sound. */
+	if (chip->usb_id == USB_ID(0x04fa, 0x4201))
+		num = 4;
+	
+	for (i = 0; i < num; i++) {
 		alts = &iface->altsetting[i];
 		altsd = get_iface_desc(alts);
 		/* skip invalid one */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
