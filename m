Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYEJDIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYEJDIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 23:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYEJDH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 23:07:56 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54117 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750978AbYEJDHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 23:07:55 -0400
Date: Fri, 9 May 2008 20:07:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [patch 6/6] x86: Add checks for virtual addresses in __phys_addr()
In-Reply-To: <Pine.LNX.4.64.0805091927450.32224@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0805092007110.24814@schroedinger.engr.sgi.com>
References: <20080510020947.803480649@sgi.com> <20080510021021.472932504@sgi.com>
 <20080510022325.GA25712@uranus.ravnborg.org>
 <Pine.LNX.4.64.0805091927450.32224@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We also need to address this issue with __pa expected to be a constant in 
32 bit code. Sigh.


---
 arch/x86/kernel/doublefault_32.c |    2 +-
 include/asm-x86/page_32.h        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/include/asm-x86/page_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/page_32.h	2008-05-09 19:32:47.000000000 -0700
+++ linux-2.6/include/asm-x86/page_32.h	2008-05-09 19:32:55.000000000 -0700
@@ -65,7 +65,7 @@ typedef struct page *pgtable_t;
 
 #ifndef __ASSEMBLY__
 #ifdef CONFIG_DEBUG_VM
-unsigned long __phys_addr(unsigned long x)
+extern unsigned long __phys_addr(unsigned long x);
 #else
 #define __phys_addr(x)	((x) - PAGE_OFFSET)
 #endif
Index: linux-2.6/arch/x86/kernel/doublefault_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/doublefault_32.c	2008-05-09 19:40:08.000000000 -0700
+++ linux-2.6/arch/x86/kernel/doublefault_32.c	2008-05-09 19:40:45.000000000 -0700
@@ -66,6 +66,6 @@ struct tss_struct doublefault_tss __cach
 		.ds		= __USER_DS,
 		.fs		= __KERNEL_PERCPU,
 
-		.__cr3		= __pa(swapper_pg_dir)
+		.__cr3		= (unsigned long)swapper_pg_dir - PAGE_OFFSET
 	}
 };

