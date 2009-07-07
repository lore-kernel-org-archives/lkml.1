Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZGGRPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZGGRPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZGGRPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:15:12 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:5586 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbZGGRPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:15:11 -0400
Date: Tue, 7 Jul 2009 19:24:54 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, rjw@sisk.pl, stable@kernel.org
Subject: w100fb: fix regression with uninitalized fb_info->mm_lock mutex
Message-Id: <20090707192454.df7462a4.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 8ac0b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove redundant call to the w100fb_set_par() before w100 frambuffer is registered.

This fixes a problem with uninitialized the fb_info->mm_lock mutex introduced 
by the commit 537a1bf059f " fbdev: add mutex for fb_mmap locking"

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>

---

diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
index 8a141c2..2376f68 100644
--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -748,8 +748,6 @@ int __init w100fb_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	w100fb_set_par(info);
-
 	if (register_framebuffer(info) < 0) {
 		err = -EINVAL;
 		goto out;

----------------------------------------------------------------------
Promocja ubezpieczen komunikacyjnych Ergo Hestia. Sprawdz!
http://link.interia.pl/f222f

