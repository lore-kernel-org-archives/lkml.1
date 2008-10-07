Return-Path: <linux-kernel-owner+w=401wt.eu-S1761014AbYJGBFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761014AbYJGBFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbYJGAqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:46:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:47309 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758060AbYJGAqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:46:38 -0400
Date: Mon, 6 Oct 2008 17:40:24 -0700
From: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, Harvey Harrison <harvey.harrison@gmail.com>,
       "Antonino A. Daplas" <adaplas@pol.net>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: [patch 68/71] fbcon: fix monochrome color value calculation
Message-ID: <20081007004024.GQ3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fbcon-fix-monochrome-color-value-calculation.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Winn <q-newsgroup@qypea.com>

commit 08650869e0ec581f8d88cfdb563d37f5383abfe2 upstream

Commit 22af89aa0c0b4012a7431114a340efd3665a7617 ("fbcon: replace mono_col
macro with static inline") changed the order of operations for computing
monochrome color values.  This generates 0xffff000f instead of 0x0000000f
for a 4 bit monochrome color, leading to image corruption if it is passed
to cfb_imageblit or other similar functions.  Fix it up.

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/console/fbcon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -110,7 +110,7 @@ static inline int mono_col(const struct 
 	__u32 max_len;
 	max_len = max(info->var.green.length, info->var.red.length);
 	max_len = max(info->var.blue.length, max_len);
-	return ~(0xfff << (max_len & 0xff));
+	return (~(0xfff << max_len)) & 0xff;
 }
 
 static inline int attr_col_ec(int shift, struct vc_data *vc,

-- 
