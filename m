Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbXKUF4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbXKUF4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 00:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbXKUF4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 00:56:11 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35014 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbXKUF4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 00:56:10 -0500
Date: Wed, 21 Nov 2007 14:58:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1
Message-Id: <20071121145838.c66a6393.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071120204525.ff27ac98.akpm@linux-foundation.org>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I met.

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
<stdin>:1389:2: warning: #warning syscall revokeat not implemented
<stdin>:1393:2: warning: #warning syscall frevoke not implemented
  CHK     include/linux/compile.h
make[1]: *** No rule to make target `arch/ia64/lib/copy_page-export.o', needed by `arch/ia64/lib/built-in.o'.  Stop.
make: *** [arch/ia64/lib] Error 2

fix (for my config ?) is attached.

=
This was necessary to build.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 arch/ia64/lib/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.24-rc3-mm1/arch/ia64/lib/Makefile
===================================================================
--- linux-2.6.24-rc3-mm1.orig/arch/ia64/lib/Makefile
+++ linux-2.6.24-rc3-mm1/arch/ia64/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile for ia64-specific library routines..
 #
 
-obj-y := io.o copy_page-export.o
+obj-y := io.o
 
 lib-y := __divsi3.o __udivsi3.o __modsi3.o __umodsi3.o			\
 	__divdi3.o __udivdi3.o __moddi3.o __umoddi3.o			\

