Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbYDNOTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbYDNOTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760772AbYDNOR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:17:56 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:33480 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822AbYDNORz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:17:55 -0400
Date: Mon, 14 Apr 2008 17:16:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: hskinnemoen@atmel.com, bzolnier@gmail.com, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] avr32 mustn't select HAVE_IDE
Message-ID: <20080414141650.GD6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a libata based PATA driver for avr32, but no support for 
drivers/ide/ on avr32.

This patch fixes the following compile error:

<--  snip  -->

...
  CC [M]  drivers/ide/ide-cd.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/ide-cd.c:37:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/ide.h:209:21: error: asm/ide.h: No such file or directory
make[3]: *** [drivers/ide/ide-cd.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
275f6bec75800cd1a7ba7e89c63a10ae43f0a50c diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index c75d708..28e0caf 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -10,7 +10,6 @@ config AVR32
 	# With EMBEDDED=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
 	select EMBEDDED
-	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	help

