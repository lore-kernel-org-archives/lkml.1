Return-Path: <linux-kernel-owner+w=401wt.eu-S1765381AbYD2Syf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765381AbYD2Syf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762316AbYD2SvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:51:22 -0400
Received: from ns2.suse.de ([195.135.220.15]:41411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762304AbYD2SvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:51:20 -0400
Date: Tue, 29 Apr 2008 11:50:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Steven Toth <stoth@hauppauge.com>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [11/12] V4L: cx88: enable radio GPIO correctly
Message-ID: <20080429185008.GM24199@suse.de>
References: <20080429184543.308594866@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-cx88-enable-radio-gpio-correctly.patch"
In-Reply-To: <20080429184911.GA24199@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Steven Toth <stoth@hauppauge.com>

This patch fixes an issue on the HVR1300, where GPIO is blown away due to
the radio input being undefined, breaking the functionality of the DVB
demodulator and MPEG2 encoder used on the cx8802 mpeg TS port.

This is a minimal patch for 2.6.26 and the -stable series.  This must be
fixed a better way for 2.6.27.

Signed-off-by: Steven Toth <stoth@hauppauge.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
(cherry picked from commit 6b92b3bd7ac91b7e255541f4be9bfd55b12dae41)
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx88/cx88-cards.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -1349,6 +1349,10 @@ static const struct cx88_board cx88_boar
 		}},
 		/* fixme: Add radio support */
 		.mpeg           = CX88_MPEG_DVB | CX88_MPEG_BLACKBIRD,
+		.radio = {
+			.type   = CX88_RADIO,
+			.gpio0	= 0xe780,
+		},
 	},
 	[CX88_BOARD_ADSTECH_PTV_390] = {
 		.name           = "ADS Tech Instant Video PCI",

-- 
