Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbXKUGIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbXKUGIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 01:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbXKUGIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 01:08:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60226 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861AbXKUGIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 01:08:46 -0500
Date: Tue, 20 Nov 2007 22:08:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1
Message-Id: <20071120220841.218dac46.akpm@linux-foundation.org>
In-Reply-To: <20071121145838.c66a6393.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<20071121145838.c66a6393.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 14:58:38 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> I met.
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
> <stdin>:1389:2: warning: #warning syscall revokeat not implemented
> <stdin>:1393:2: warning: #warning syscall frevoke not implemented
>   CHK     include/linux/compile.h
> make[1]: *** No rule to make target `arch/ia64/lib/copy_page-export.o', needed by `arch/ia64/lib/built-in.o'.  Stop.
> make: *** [arch/ia64/lib] Error 2
> 
> fix (for my config ?) is attached.
> 
> =
> This was necessary to build.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
>  arch/ia64/lib/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.24-rc3-mm1/arch/ia64/lib/Makefile
> ===================================================================
> --- linux-2.6.24-rc3-mm1.orig/arch/ia64/lib/Makefile
> +++ linux-2.6.24-rc3-mm1/arch/ia64/lib/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for ia64-specific library routines..
>  #
>  
> -obj-y := io.o copy_page-export.o
> +obj-y := io.o
>  
>  lib-y := __divsi3.o __udivsi3.o __modsi3.o __umodsi3.o			\
>  	__divdi3.o __udivdi3.o __moddi3.o __umoddi3.o			\

erp.  Actually, it should be this:

--- a/arch/ia64/lib/Makefile~ia64-export-copy_page-to-modules-fix-fix
+++ a/arch/ia64/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile for ia64-specific library routines..
 #
 
-obj-y := io.o copy_page-export.o
+obj-y := io.o
 
 lib-y := __divsi3.o __udivsi3.o __modsi3.o __umodsi3.o			\
 	__divdi3.o __udivdi3.o __moddi3.o __umoddi3.o			\
_

