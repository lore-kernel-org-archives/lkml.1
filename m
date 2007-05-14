Return-Path: <linux-kernel-owner+w=401wt.eu-S1760539AbXENU0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539AbXENU0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761190AbXENUZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:25:55 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:58864 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761148AbXENUZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:25:53 -0400
Date: Mon, 14 May 2007 22:25:50 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH] m68k: implement __clear_user()
In-Reply-To: <20070513034442.52f81fff.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705142224380.21397@anakin>
References: <Pine.LNX.4.64.0704021555430.26489@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0705131222410.2271@anakin> <20070513034442.52f81fff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

m68k: implement __clear_user(), which is needed by fs/signalfd.c

Since we always let the MMU do all checking, clear_user() and __clear_user()
are identical. The old clear_user() is renamed to __clear_user() for
consistency.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/lib/uaccess.c    |    4 ++--
 include/asm-m68k/uaccess.h |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/arch/m68k/lib/uaccess.c
+++ b/arch/m68k/lib/uaccess.c
@@ -181,7 +181,7 @@ EXPORT_SYMBOL(strnlen_user);
  * Zero Userspace
  */
 
-unsigned long clear_user(void __user *to, unsigned long n)
+unsigned long __clear_user(void __user *to, unsigned long n)
 {
 	unsigned long res;
 
@@ -219,4 +219,4 @@ unsigned long clear_user(void __user *to
 
     return res;
 }
-EXPORT_SYMBOL(clear_user);
+EXPORT_SYMBOL(__clear_user);
--- a/include/asm-m68k/uaccess.h
+++ b/include/asm-m68k/uaccess.h
@@ -361,7 +361,9 @@ __constant_copy_to_user(void __user *to,
 
 long strncpy_from_user(char *dst, const char __user *src, long count);
 long strnlen_user(const char __user *src, long n);
-unsigned long clear_user(void __user *to, unsigned long n);
+unsigned long __clear_user(void __user *to, unsigned long n);
+
+#define clear_user	__clear_user
 
 #define strlen_user(str) strnlen_user(str, 32767)
 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
