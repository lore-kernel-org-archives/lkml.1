Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYHJPuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYHJPuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYHJPty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:49:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:7475 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbYHJPtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:49:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Z130RCd6RsmlBlB8I+WV+KCn8eusPTohgmPtImCBckgaJzmjNBWzZlmXa/79jxHxK2
         qmVKt416hOIlubHOksAz7koX6QgPo9t4+SL0czUD+BZIJMhOllTJ6Sgt7FOCrsTphVVY
         YJiArdBP3/doCpkoQZyfzNBtMYX5wwtZKZZr8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove M68K_IDE_SWAPW define from <asm-m68k/ide.h>
Date: Sun, 10 Aug 2008 17:46:12 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808101746.12697.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we solved this by overriding default ->{in,out}put_data
methods in {q40,falcon}ide M68K_IDE_SWAP define can go away.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/asm-m68k/ide.h |    9 ---------
 1 file changed, 9 deletions(-)

Index: b/include/asm-m68k/ide.h
===================================================================
--- a/include/asm-m68k/ide.h
+++ b/include/asm-m68k/ide.h
@@ -92,15 +92,6 @@
 #define outsw_swapw(port, addr, n)	raw_outsw_swapw((u16 *)port, addr, n)
 #endif
 
-
-/* Q40 and Atari have byteswapped IDE busses and since many interesting
- * values in the identification string are text, chars and words they
- * happened to be almost correct without swapping.. However *_capacity
- * is needed for drives over 8 GB. RZ */
-#if defined(CONFIG_Q40) || defined(CONFIG_ATARI)
-#define M68K_IDE_SWAPW  (MACH_IS_Q40 || MACH_IS_ATARI)
-#endif
-
 #ifdef CONFIG_BLK_DEV_FALCON_IDE
 #define IDE_ARCH_LOCK
 
