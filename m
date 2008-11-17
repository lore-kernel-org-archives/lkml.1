Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbYKQHbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbYKQHbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbYKQHVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:31 -0500
Received: from kroah.org ([198.145.64.141]:38536 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752485AbYKQHVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:22 -0500
Date: Sun, 16 Nov 2008 23:16:01 -0800
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
       alan@lxorguk.ukuu.org.uk, Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 28/46] m68k: Fix off-by-one in m68k_setup_user_interrupt()
Message-ID: <20081117071601.GC29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="m68k-fix-off-by-one-in-m68k_setup_user_interrupt.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 27123cbc264de89ce6951b1b4c84c223eb0f1702 upstream.

commit 69961c375288bdab7604e0bb1c8d22999bb8a347 ("[PATCH] m68k/Atari:
Interrupt updates") added a BUG_ON() with an incorrect upper bound
comparison, which causes an early crash on VME boards, where IRQ_USER is
8, cnt is 192 and NR_IRQS is 200.

Reported-by: Stephen N Chivers <schivers@csc.com.au>
Tested-by: Kars de Jong <jongk@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/m68k/kernel/ints.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -133,7 +133,7 @@ void __init m68k_setup_user_interrupt(un
 {
 	int i;
 
-	BUG_ON(IRQ_USER + cnt >= NR_IRQS);
+	BUG_ON(IRQ_USER + cnt > NR_IRQS);
 	m68k_first_user_vec = vec;
 	for (i = 0; i < cnt; i++)
 		irq_controller[IRQ_USER + i] = &user_irq_controller;

-- 
