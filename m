Return-Path: <linux-kernel-owner+w=401wt.eu-S1761773AbXKTS1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761773AbXKTS1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbXKTS0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60131 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760887AbXKTSZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:25:57 -0500
Date: Tue, 20 Nov 2007 10:23:14 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Geert.Uytterhoeven@sonycom.com,
       lizf@cn.fujitsu.com
Subject: [patch 04/29] drivers/video/ps3fb: fix memset size error
Message-ID: <20071120182314.GE28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drivers-video-ps3fb-fix-memset-size-error.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Li Zefan <lizf@cn.fujitsu.com>

patch 3cc2c17700c98b0af778566b0af6292b23b01430 in mainline.

The size passing to memset is wrong.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/video/ps3fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -659,7 +659,7 @@ static int ps3fb_blank(int blank, struct
 
 static int ps3fb_get_vblank(struct fb_vblank *vblank)
 {
-	memset(vblank, 0, sizeof(&vblank));
+	memset(vblank, 0, sizeof(*vblank));
 	vblank->flags = FB_VBLANK_HAVE_VSYNC;
 	return 0;
 }

-- 
