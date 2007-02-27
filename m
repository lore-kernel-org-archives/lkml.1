Return-Path: <linux-kernel-owner+w=401wt.eu-S1161460AbXB0AJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161460AbXB0AJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161474AbXB0AH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:07:59 -0500
Received: from mail.kroah.org ([69.55.234.183]:44828 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161457AbXB0AHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:07:18 -0500
Date: Mon, 26 Feb 2007 16:06:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>
Subject: [patch 5/9] hda-intel - Dont try to probe invalid codecs
Message-ID: <20070227000631.GF6283@kroah.com>
References: <20070226235248.438556696@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hda-intel-don-t-try-to-probe-invalid-codecs.patch"
In-Reply-To: <20070227000538.GA6283@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Takashi Iwai <tiwai@suse.de>

[ALSA] hda-intel - Don't try to probe invalid codecs

Fix the max number of codecs detected by HD-intel (and compatible)
controllers to 3.  Some hardware reports extra bits as if
connected, and the driver gets confused to probe unexisting codecs.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19.5.orig/sound/pci/hda/hda_intel.c
+++ linux-2.6.19.5/sound/pci/hda/hda_intel.c
@@ -198,7 +198,7 @@ enum { SDI0, SDI1, SDI2, SDI3, SDO0, SDO
 
 /* STATESTS int mask: SD2,SD1,SD0 */
 #define STATESTS_INT_MASK	0x07
-#define AZX_MAX_CODECS		4
+#define AZX_MAX_CODECS		3
 
 /* SD_CTL bits */
 #define SD_CTL_STREAM_RESET	0x01	/* stream reset bit */

--
