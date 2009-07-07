Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbZGGT5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbZGGT5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 15:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbZGGT5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 15:57:08 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:10898 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbZGGT5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 15:57:07 -0400
Date: Tue, 7 Jul 2009 22:06:48 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, rjw@sisk.pl, stable@kernel.org
Subject: matroxfb: fix regression with uninitalized fb_info->mm_lock mutex
Message-Id: <20090707220648.4b2ee3d8.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: dec0b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove redundant call to the matroxfb_update_fix() before matrox frambuffer
is registered.

This fixes a problem with uninitialized the fb_info->mm_lock mutex introduced 
by the commit 537a1bf059f " fbdev: add mutex for fb_mmap locking"

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>

---

This one I have been able to test. It fixed regression with the mm_lock mutex.

It may not fix regression for a second head. I will investigate this issue.

diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index 76bc51b..721a87d 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -1876,7 +1876,6 @@ static int initMatrox2(WPMINFO struct board* b){
 	}
 	matroxfb_init_fix(PMINFO2);
 	ACCESS_FBINFO(fbcon.screen_base) = vaddr_va(ACCESS_FBINFO(video.vbase));
-	matroxfb_update_fix(PMINFO2);
 	/* Normalize values (namely yres_virtual) */
 	matroxfb_check_var(&vesafb_defined, &ACCESS_FBINFO(fbcon));
 	/* And put it into "current" var. Do NOT program hardware yet, or we'll not take over

----------------------------------------------------------------------
Promocja ubezpieczen komunikacyjnych Ergo Hestia. Sprawdz!
http://link.interia.pl/f222f

