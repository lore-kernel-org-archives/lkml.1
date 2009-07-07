Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbZGGUYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbZGGUYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbZGGUY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:24:29 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:45320 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290AbZGGUY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:24:28 -0400
Date: Tue, 7 Jul 2009 22:34:13 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, rjw@sisk.pl, stable@kernel.org
Subject: matroxfb: fix regression with uninitalized fb_info->mm_lock mutex
 (second head)
Message-Id: <20090707223413.d56c6a7f.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: cec0b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove redundant locking by the mm_lock mutex before a second head of matrox 
framebuffer is registered.

This fixes a problem with uninitialized the fb_info->mm_lock mutex introduced 
by the commit 537a1bf059f " fbdev: add mutex for fb_mmap locking"

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>

---

diff --git a/drivers/video/matrox/matroxfb_crtc2.c b/drivers/video/matrox/matroxfb_crtc2.c
index 909e10a..6caa369 100644
--- a/drivers/video/matrox/matroxfb_crtc2.c
+++ b/drivers/video/matrox/matroxfb_crtc2.c
@@ -289,16 +289,18 @@ static int matroxfb_dh_release(struct fb_info* info, int user) {
 #undef m2info
 }
 
+/*
+ * This function is called before the register_framebuffer so
+ * no locking is needed.
+ */
 static void matroxfb_dh_init_fix(struct matroxfb_dh_fb_info *m2info)
 {
 	struct fb_fix_screeninfo *fix = &m2info->fbcon.fix;
 
 	strcpy(fix->id, "MATROX DH");
 
-	mutex_lock(&m2info->fbcon.mm_lock);
 	fix->smem_start = m2info->video.base;
 	fix->smem_len = m2info->video.len_usable;
-	mutex_unlock(&m2info->fbcon.mm_lock);
 	fix->ypanstep = 1;
 	fix->ywrapstep = 0;
 	fix->xpanstep = 8;	/* TBD */

----------------------------------------------------------------------
Sprawdz promocje ubezpieczen komunikacyjnych w Ergo  Hestia
http://link.interia.pl/f222c

