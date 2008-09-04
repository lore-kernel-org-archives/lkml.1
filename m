Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYIDLqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYIDLqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYIDLqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:46:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37179 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbYIDLqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:46:13 -0400
Date: Thu, 4 Sep 2008 13:46:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Drop -funroll-loops for csum_partial_64.c
Message-ID: <20080904114611.GA18253@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop -funroll-loops for csum_partial_64.c

I did some rebenchmarking with modern compilers and dropping 
-funroll-loops makes the function consistently go faster by a few
percent.  So drop that flag.

Thanks to Richard Guenther for a hint.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/lib/Makefile |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.27-rc4-misc/arch/x86/lib/Makefile
===================================================================
--- linux-2.6.27-rc4-misc.orig/arch/x86/lib/Makefile
+++ linux-2.6.27-rc4-misc/arch/x86/lib/Makefile
@@ -17,9 +17,6 @@ ifeq ($(CONFIG_X86_32),y)
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
         obj-y += io_64.o iomap_copy_64.o
-
-        CFLAGS_csum-partial_64.o := -funroll-loops
-
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
