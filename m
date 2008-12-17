Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759465AbYLQAIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYLQAIs (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbYLQAGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:06:09 -0500
Received: from kroah.org ([198.145.64.141]:41314 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759687AbYLQAGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:06:06 -0500
Date: Tue, 16 Dec 2008 16:04:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ingo Brueckl <ib@wupperonline.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Egmont Koblinger <egmont@uhulinux.hu>
Subject: [patch 13/22] console ASCII glyph 1:1 mapping
Message-ID: <20081217000425.GN4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="console-ascii-glyph-1-1-mapping.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ingo Brueckl <ib@wupperonline.de>

commit 1c55f18717304100a5f624c923f7cb6511b4116d upstream.

For the console, there is a 1:1 mapping of glyphs which cannot be found
in the current font.  This seems to be meant as a kind of 'emergency
fallback' for fonts without unicode mapping which otherwise would
display nothing readable on the screen.

At the moment it affects all chars for which no substitution character
is defined.  In particular this means that for all chars (>= 128) where
there is no iso88591-1/unicode character (e.g.  control character area)
you'll get the very strange 1:1 mapping of the (cp437) graphics card
glyphs.

I'm pretty sure that the 1:1 mapping should only affect strict ASCII
code characters, i.e.  chars < 128.

The patch limits the mapping as it probably was meant anyway.

Signed-off-by: Ingo Brueckl <ib@wupperonline.de>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Egmont Koblinger <egmont@uhulinux.hu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2287,7 +2287,7 @@ rescan_last_byte:
 				    continue; /* nothing to display */
 				}
 				/* Glyph not found */
-				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) || c < 128) && !(c & ~charmask)) {
+				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) && c < 128) && !(c & ~charmask)) {
 				    /* In legacy mode use the glyph we get by a 1:1 mapping.
 				       This would make absolutely no sense with Unicode in mind,
 				       but do this for ASCII characters since a font may lack

