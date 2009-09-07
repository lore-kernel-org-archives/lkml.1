Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbZIGFht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbZIGFht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 01:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbZIGFhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 01:37:48 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46723 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758823AbZIGFhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 01:37:48 -0400
Date: Mon, 7 Sep 2009 01:37:33 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Greg Ungerer <gerg@snapgear.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH] m68knommu: Clean up linker script using new linker script
 macros.
In-Reply-To: <4AA49946.2000804@snapgear.com>
Message-ID: <alpine.DEB.1.10.0909070135040.17860@dr-wily.mit.edu>
References: <1252293044-13102-1-git-send-email-tabbott@ksplice.com> <4AA49946.2000804@snapgear.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Greg Ungerer wrote:

> This fails for me with:
> 
>   LD      vmlinux
> /usr/local/bin/m68k-uclinux-ld:arch/m68knommu/kernel/vmlinux.lds:287: syntax
> error
> 
> due to PAGE_SIZE evaluating to:
> 
>   . = ALIGN((1UL << (12)));
> 
> The linker doesn't like the 'UL' suffix.

Yeah, sorry, I didn't have a cross-compiler for this one to test.  The fix 
is to use _AC(1,UL), like most of the other architectures (including m68k 
with an mmu) do.

	-Tim Abbott

m68knommu: Make PAGE_SIZE available to assembly files.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/m68k/include/asm/page_no.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index 9aa3f90..1f31b06 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -1,10 +1,12 @@
 #ifndef _M68KNOMMU_PAGE_H
 #define _M68KNOMMU_PAGE_H
 
+#include <linux/const.h>
+
 /* PAGE_SHIFT determines the page size */
 
 #define PAGE_SHIFT	(12)
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #include <asm/setup.h>
-- 
1.6.3.3

