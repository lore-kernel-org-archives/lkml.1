Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbYJRTXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbYJRTXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYJRTGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:06:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:38879 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbYJRTGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:06:38 -0400
Date: Sat, 18 Oct 2008 11:57:41 -0700
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
       alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 12/14] V4L: zr36067: Fix RGBR pixel format
Message-ID: <20081018185741.GM17196@suse.de>
References: <20081018185031.236868964@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-zr36067-fix-rgbr-pixel-format.patch"
In-Reply-To: <20081018185658.GA17196@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jean Delvare <khali@linux-fr.org>

(cherry picked from commit a30ee3c747728f9151664118ffcbdeefd202c332)

The zr36067 driver is improperly declaring pixel format RGBP twice,
once as "16-bit RGB LE" and once as "16-bit RGB BE". The latter is
actually RGBR. Fix the code to properly map both pixel formats.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/zoran_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/zoran_driver.c
+++ b/drivers/media/video/zoran_driver.c
@@ -139,7 +139,7 @@ const struct zoran_format zoran_formats[
 	}, {
 		.name = "16-bit RGB BE",
 		ZFMT(-1,
-		     V4L2_PIX_FMT_RGB565, V4L2_COLORSPACE_SRGB),
+		     V4L2_PIX_FMT_RGB565X, V4L2_COLORSPACE_SRGB),
 		.depth = 16,
 		.flags = ZORAN_FORMAT_CAPTURE |
 			 ZORAN_FORMAT_OVERLAY,

-- 
