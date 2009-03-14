Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbZCNAbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbZCNAbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZCNATF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:05 -0400
Received: from kroah.org ([198.145.64.141]:46940 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753196AbZCNASw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:52 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:43 2009
Message-Id: <20090314000743.808810669@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Joris van Rantwijk <jorispubl@xs4all.nl>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 32/96] ALSA: usb-audio - Workaround for misdetected sample rate with CM6207
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=alsa-usb-audio-workaround-for-misdetected-sample-rate-with-cm6207.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joris van Rantwijk <jorispubl@xs4all.nl>

commit 3b03cc5b86e2052295b9b484f37226ee15c87924 upstream.

The CM6207 incorrectly advertises its 96 kHz playback setting as 48 kHz
in its USB device descriptor. This patch extends an existing workaround
in usbaudio.c to also cover the CM6207.

This resolves issue 0004249 in the ALSA bug tracker.

Signed-off-by: Joris van Rantwijk <jorispubl@xs4all.nl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbaudio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -2531,7 +2531,8 @@ static int parse_audio_format_rates(stru
 				continue;
 			/* C-Media CM6501 mislabels its 96 kHz altsetting */
 			if (rate == 48000 && nr_rates == 1 &&
-			    chip->usb_id == USB_ID(0x0d8c, 0x0201) &&
+			    (chip->usb_id == USB_ID(0x0d8c, 0x0201) ||
+			     chip->usb_id == USB_ID(0x0d8c, 0x0102)) &&
 			    fp->altsetting == 5 && fp->maxpacksize == 392)
 				rate = 96000;
 			fp->rate_table[fp->nr_rates] = rate;


