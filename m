Return-Path: <linux-kernel-owner+w=401wt.eu-S1763375AbZEFWOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375AbZEFWOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761529AbZEFVzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:08 -0400
Received: from kroah.org ([198.145.64.141]:57365 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761162AbZEFVy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:01 2009
Message-Id: <20090506214801.673805228@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:14 -0700
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
       alan@lxorguk.ukuu.org.uk, Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 46/58] ath5k: fix buffer overrun in rate debug code
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=ath5k-fix-buffer-overrun-in-rate-debug-code.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Copeland <me@bobcopeland.com>

commit b7fcb5c4a4c27da2f6d86cb03d18687e537442cf upstream.

char bname[5] is too small for the string "X GHz" when the null
terminator is taken into account.  Thus, turning on rate debugging
can crash unless we have lucky stack alignment.

Cc: stable@kernel.org
Reported-by: Paride Legovini <legovini@spiro.fisica.unipd.it>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath5k/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -465,7 +465,7 @@ ath5k_debug_dump_bands(struct ath5k_soft
 
 	for (b = 0; b < IEEE80211_NUM_BANDS; b++) {
 		struct ieee80211_supported_band *band = &sc->sbands[b];
-		char bname[5];
+		char bname[6];
 		switch (band->band) {
 		case IEEE80211_BAND_2GHZ:
 			strcpy(bname, "2 GHz");


