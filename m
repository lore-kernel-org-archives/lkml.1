Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbXLHAIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbXLHAIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 19:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXLHAIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 19:08:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57993 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723AbXLHAIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 19:08:06 -0500
Date: Fri, 7 Dec 2007 16:08:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc4-mm1: undefined reference to `compat_sys_timerfd' on
 sparc64
Message-Id: <20071207160800.77e7e907.akpm@linux-foundation.org>
In-Reply-To: <200712080104.55619.m.kozlowski@tuxland.pl>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<200712080104.55619.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 01:04:55 +0100
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	I tried it on sun ultra 60 (dual sparc64) station. Unfortunately it failed
> to compile.
> 
>   AS      arch/sparc64/lib/xor.o
>   AR      arch/sparc64/lib/lib.a
>   GEN     .version
>   CHK     include/linux/compile.h
> dnsdomainname: Unknown host
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/sparc64/kernel/head.o: In function `sys_call_table32':
> arch/sparc64/kernel/head.S:(.text+0x224e0): undefined reference to `compat_sys_timerfd'
> make: *** [.tmp_vmlinux1] Error 1

argh, sorry, I am soooooo fed up with fixing that patch.

--- a/arch/sparc64/kernel/systbls.S~timerfd-v3-new-timerfd-api-sparc64-fix
+++ a/arch/sparc64/kernel/systbls.S
@@ -80,7 +80,7 @@ sys_call_table32:
 	.word sys_fchmodat, sys_faccessat, compat_sys_pselect6, compat_sys_ppoll, sys_unshare
 /*300*/	.word compat_sys_set_robust_list, compat_sys_get_robust_list, compat_sys_migrate_pages, compat_sys_mbind, compat_sys_get_mempolicy
 	.word compat_sys_set_mempolicy, compat_sys_kexec_load, compat_sys_move_pages, sys_getcpu, compat_sys_epoll_pwait
-/*310*/	.word compat_sys_utimensat, compat_sys_signalfd, compat_sys_timerfd, sys_eventfd, compat_sys_fallocate
+/*310*/	.word compat_sys_utimensat, compat_sys_signalfd, sys_ni_syscall, sys_eventfd, compat_sys_fallocate
 
 #endif /* CONFIG_COMPAT */
 
_

Or should this have been sys_nis_syscall()?


I should have picked this up in cross-build testing but iirc
sparc64 broke for other reasons.  Let me check on that.
