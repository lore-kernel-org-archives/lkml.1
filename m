Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbYDXSfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbYDXSfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbYDXSeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:34:18 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:54896 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbYDXSeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:34:14 -0400
Message-Id: <20080424183240.800543888@mail.of.borg>
References: <20080424182940.424312704@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 20:29:41 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 01/15] m68k: Convert access_ok() to an inline function
Content-Disposition: inline; filename=m68k-convert-access_ok-to-inline-func.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

Convert access_ok() from a macro to an inline function, so the compiler no
longer complains about unused variables:

    fs/read_write.c: In function 'rw_copy_check_uvector':
    fs/read_write.c:556: warning: unused variable 'buf'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/uaccess.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/asm-m68k/uaccess.h
+++ b/include/asm-m68k/uaccess.h
@@ -14,7 +14,11 @@
 #define VERIFY_WRITE	1
 
 /* We let the MMU do all checking */
-#define access_ok(type,addr,size) 1
+static inline int access_ok(int type, const void __user *addr,
+			    unsigned long size)
+{
+	return 1;
+}
 
 /*
  * The exception table consists of pairs of addresses: the first is the

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

