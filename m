Return-Path: <linux-kernel-owner+w=401wt.eu-S1764291AbYBFX4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764291AbYBFX4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764044AbYBFXyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:13 -0500
Received: from mx1.suse.de ([195.135.220.2]:45007 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763157AbYBFXyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:11 -0500
Date: Wed, 6 Feb 2008 15:51:04 -0800
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
       Henrique Holschuh <hmh@hmh.eng.br>, Len Brown <len.brown@intel.com>
Subject: [patch 06/73] ACPI: thinkpad-acpi: fix lenovo keymap for brightness
Message-ID: <20080206235104.GG13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-thinkpad-acpi-fix-lenovo-keymap-for-brightness.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

upstream  commit 56a185b43be05e48da7428e6a1d3e2585b232b1d

Starting in 2.6.23...

Several reports from X60 users complained that the default Lenovo keymap
issuing EV_KEY KEY_BRIGHTNESS_UP/DOWN input events caused major issues when
the proper brightness support through ACPI video.c was loaded.

Therefore, remove the generation of these events by default, which is the
right thing for T60, X60, R60, T61, X61 and R61 with their latest BIOSes.

Distros that want to misuse these events into OSD reporting (which requires
an ugly hack from hell in HAL) are welcome to set up the key map they need
through HAL.  That way, we don't break everyone else's systems.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/thinkpad_acpi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -968,9 +968,9 @@ static int __init hotkey_init(struct ibm
 		KEY_UNKNOWN,	/* 0x0C: FN+BACKSPACE */
 		KEY_UNKNOWN,	/* 0x0D: FN+INSERT */
 		KEY_UNKNOWN,	/* 0x0E: FN+DELETE */
-		KEY_BRIGHTNESSUP,	/* 0x0F: FN+HOME (brightness up) */
+		KEY_RESERVED,	/* 0x0F: FN+HOME (brightness up) */
 		/* Scan codes 0x10 to 0x1F: Extended ACPI HKEY hot keys */
-		KEY_BRIGHTNESSDOWN,	/* 0x10: FN+END (brightness down) */
+		KEY_RESERVED,	/* 0x10: FN+END (brightness down) */
 		KEY_RESERVED,	/* 0x11: FN+PGUP (thinklight toggle) */
 		KEY_UNKNOWN,	/* 0x12: FN+PGDOWN */
 		KEY_ZOOM,	/* 0x13: FN+SPACE (zoom) */

-- 
