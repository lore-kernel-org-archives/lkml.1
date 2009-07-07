Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZGGQ60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZGGQ60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZGGQ6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:58:19 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:45436 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbZGGQ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:58:18 -0400
Date: Tue, 7 Jul 2009 19:07:57 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       daniel@caiaq.de, a.p.zijlstra@chello.nl, rjw@sisk.pl, stable@kernel.org
Subject: i810fb: fix regression with uninitalized fb_info->mm_lock mutex
Message-Id: <20090707190757.5c9bed6e.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 34c0b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove redundant call to the encode_fix() before i810 frambuffer is registered.

This fixes a problem with uninitialized the fb_info->mm_lock mutex introduced 
by the commit 537a1bf059f " fbdev: add mutex for fb_mmap locking"

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>

---

diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.c
index 7196067..5743ea2 100644
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -2060,8 +2060,7 @@ static int __devinit i810fb_init_pci (struct pci_dev *dev,
 
 	fb_var_to_videomode(&mode, &info->var);
 	fb_add_videomode(&mode, &info->modelist);
-	encode_fix(&info->fix, info); 
-	 	    
+
 	i810fb_init_ringbuffer(info);
 	err = register_framebuffer(info);
 


----------------------------------------------------------------------
Najlepsze OC i AC tylko w Ergo Hestia
http://link.interia.pl/f222

