Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbYB0VCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbYB0VCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbYB0VAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:00:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:11803 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbYB0VAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:00:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=xZnnRzQQiZZv3ATqSQ5qfzQbHBDjsIR9fNR90v5gwt/s2UPImBuqlj7TVw1btugnfmZxoBb+QpQYcMCTHOo2Ka5ZitHjyj/L1Zi1WWlOcaD/QWfN/2WWx0MdpLkNtDJpcwaZl9CKRGsxYB6yrPgeO+xs916Vtdkym+E7jk71P1Q=
Message-Id: <20080227210003.720942920@gmail.com>
References: <20080227205831.150784453@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 Feb 2008 23:58:37 +0300
From: gorcunov@gmail.com
To: rth@twiddle.net, chris@zankel.net, jdike@addtoit.com,
       linuxppc-dev@ozlabs.org, paulus@samba.org, dhowells@redhat.com,
       zippel@linux-m68k.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org,
       linux-kernel@vger.kernel.org
Cc: gorcunov@gmail.com, sam@ravnborg.org
Subject: [RFC 06/10] powerpc: vmlinux.lds.S cleanup - use PERCPU, THREAD_SIZE macroses
Content-Disposition: inline; filename=powerpc-vmlinux
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes  thread_info.h header into liker script that
allow us to use THREAD_SIZE macro instead of numeric constant

Also PERCPU macro is used instead of explicit section definition

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

WARNING: COMPLETELY UNTESTED !!!

 vmlinux.lds.S |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

Index: linux-2.6.git/arch/powerpc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.git.orig/arch/powerpc/kernel/vmlinux.lds.S	2008-01-29 18:03:46.000000000 +0300
+++ linux-2.6.git/arch/powerpc/kernel/vmlinux.lds.S	2008-02-27 21:33:53.000000000 +0300
@@ -8,6 +8,7 @@
 #endif
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/cache.h>
+#include <asm/thread_info.h>
 
 ENTRY(_stext)
 
@@ -145,13 +146,8 @@ SECTIONS
 		__initramfs_end = .;
 	}
 #endif
-	. = ALIGN(PAGE_SIZE);
-	.data.percpu : {
-		__per_cpu_start = .;
-		*(.data.percpu)
-		*(.data.percpu.shared_aligned)
-		__per_cpu_end = .;
-	}
+
+	PERCPU(PAGE_SIZE)
 
 	. = ALIGN(8);
 	.machine.desc : {
@@ -202,11 +198,7 @@ SECTIONS
 	PROVIDE32 (edata = .);
 
 	/* The initial task and kernel stack */
-#ifdef CONFIG_PPC32
-	. = ALIGN(8192);
-#else
-	. = ALIGN(16384);
-#endif
+	. = ALIGN(THREAD_SIZE);
 	.data.init_task : {
 		*(.data.init_task)
 	}

-- 
