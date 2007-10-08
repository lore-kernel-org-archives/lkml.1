Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbXJHWlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbXJHWlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXJHWl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:41:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:38175 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbXJHWl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:41:28 -0400
From: Maarten Bressers <mbres@gentoo.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp
Cc: dsd@gentoo.org
Subject: [PATCH] Correct Makefile rule for generating custom keymap.
Message-Id: <20071008224128.2EAAB65008@smtp.gentoo.org>
Date: Mon,  8 Oct 2007 22:41:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When building a custom keymap, after setting GENERATE_KEYMAP := 1 in
drivers/char/Makefile, the kernel build fails like this:

  CC      drivers/char/vt.o
make[2]: *** No rule to make target `drivers/char/%.map', needed by
`drivers/char/defkeymap.c'.  Stop.
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2

This was caused by commit af8b128719f5248e542036ea994610a29d0642a6,
which deleted a necessary colon from the Makefile rule that generates
the keymap, since that rule contains both a target and a target-pattern.
The following patch puts the colon back:

Signed-off by: Maarten Bressers <mbres@gentoo.org>


--- a/drivers/char/Makefile	2007-10-08 23:46:47.000000000 +0200
+++ b/drivers/char/Makefile	2007-10-08 23:46:57.000000000 +0200
@@ -129,7 +129,7 @@ $(obj)/defkeymap.o:  $(obj)/defkeymap.c
 
 ifdef GENERATE_KEYMAP
 
-$(obj)/defkeymap.c $(obj)/%.c: $(src)/%.map
+$(obj)/defkeymap.c: $(obj)/%.c: $(src)/%.map
 	loadkeys --mktable $< > $@.tmp
 	sed -e 's/^static *//' $@.tmp > $@
 	rm $@.tmp
