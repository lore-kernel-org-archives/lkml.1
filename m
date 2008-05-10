Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYEJCdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYEJCdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 22:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYEJCds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 22:33:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54646 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751992AbYEJCdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 22:33:47 -0400
Date: Fri, 9 May 2008 19:33:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [patch 6/6] x86: Add checks for virtual addresses in __phys_addr()
In-Reply-To: <20080510022325.GA25712@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0805091927450.32224@schroedinger.engr.sgi.com>
References: <20080510020947.803480649@sgi.com> <20080510021021.472932504@sgi.com>
 <20080510022325.GA25712@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2008, Sam Ravnborg wrote:

 > Should this have read:
> > +extern unsigned long __phys_addr(unsigned long x);
> ?
> 
> Looks like a prototype with a missing ';'.
> And x86 uses extern for prototypes in .h files (most of the time).
> 

Right. And this means that I did not test a 32 bit config with 
CONFIG_VM_DEBUG on this one. The run of the mill stuff did not do it. 
Sigh.

This patch fixes the compile:

---
 include/asm-x86/page_32.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

