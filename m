Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbXHKOit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbXHKOit (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 10:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbXHKOil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 10:38:41 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:52085 "EHLO spock.one.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbXHKOik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 10:38:40 -0400
Date: Sat, 11 Aug 2007 16:38:16 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] uvesafb: set the refresh rate to 60Hz if nocrtc is used
Message-ID: <20070811143816.GB13632@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the nocrtc flag is set, make sure the timings in fb_var are set to
60Hz and thus reflect the default BIOS refresh rate that is being
used.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 9c21791..aa5a9c3 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -903,7 +903,7 @@ gotmode:
 	 * If we are not VBE3.0+ compliant, we're done -- the BIOS will
 	 * ignore our timings anyway.
 	 */
-	if (par->vbe_ib.vbe_version < 0x0300)
+	if (par->vbe_ib.vbe_version < 0x0300 || par->nocrtc)
 		fb_get_mode(FB_VSYNCTIMINGS | FB_IGNOREMON, 60,
 					&info->var, info);


