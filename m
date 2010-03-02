Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0CBMxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 07:53:19 -0500
Received: from fe02x03-cgp.akado.ru ([77.232.31.165]:53468 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753044Ab0CBMxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 07:53:18 -0500
X-Greylist: delayed 3611 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Mar 2010 07:53:17 EST
From: Arseniy Lartsev <arseniy@fizlesh.ru>
To: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] usbaudio: Fix wrong bitrate for Creative Creative VF0470 Live Cam
Date: Tue, 2 Mar 2010 14:52:28 +0300
User-Agent: KMail/1.12.2 (Linux/2.6.31.12-0.1-default; KDE/4.3.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003021452.28716.arseniy@fizlesh.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch works around misbehaviour of Creative Creative VF0470 Live Cam
which reports 16 kHz sample rate for audio capture while actually producing
8 kHz stream.

Signed-off-by: Arseniy Lartsev <arseniy@fizlesh.ru>

--
diff -rup linux-2.6.33-rc8-orig/sound/usb/usbaudio.c linux-2.6.33-
rc8/sound/usb/usbaudio.c
--- linux-2.6.33-rc8-orig/sound/usb/usbaudio.c
+++ linux-2.6.33-rc8/sound/usb/usbaudio.c
@@ -2513,6 +2513,9 @@ static int parse_audio_format_rates(stru
 			     chip->usb_id == USB_ID(0x0d8c, 0x0102)) &&
 			    fp->altsetting == 5 && fp->maxpacksize == 392)
 				rate = 96000;
+			/* Creative VF0470 Live Cam reports 16 kHz instead of 8 */
+			if ((rate == 16000) && (chip->usb_id == USB_ID(0x041e, 0x4068)))
+				rate = 8000;
 			fp->rate_table[fp->nr_rates] = rate;
 			if (!fp->rate_min || rate < fp->rate_min)
 				fp->rate_min = rate;
