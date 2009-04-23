Return-Path: <linux-kernel-owner+w=401wt.eu-S1760503AbZDWH7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503AbZDWH7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbZDWHfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:35:15 -0400
Received: from sous-sol.org ([216.99.217.87]:47416 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757534AbZDWHfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:35:13 -0400
Message-Id: <20090423073049.509191798@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:52 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk,
       Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [patch 092/100] Revert "console ASCII glyph 1:1 mapping"
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=revert-console-ascii-glyph-1-1-mapping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

upstream commit: c0b7988200a82290287c6f4cd49585007f73175a

This reverts commit 1c55f18717304100a5f624c923f7cb6511b4116d.

Ingo Brueckl was assuming that reverting to 1:1 mapping for chars >= 128
was not useful, but it happens to be: due to the limitations of the
Linux console, when a blind user wants to read BIG5 on it, he has no
other way than loading a font without SFM and let the 1:1 mapping permit
the screen reader to get the BIG5 encoding.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/char/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2271,7 +2271,7 @@ rescan_last_byte:
 				    continue; /* nothing to display */
 				}
 				/* Glyph not found */
-				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) && c < 128) && !(c & ~charmask)) {
+				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) || c < 128) && !(c & ~charmask)) {
 				    /* In legacy mode use the glyph we get by a 1:1 mapping.
 				       This would make absolutely no sense with Unicode in mind,
 				       but do this for ASCII characters since a font may lack

