Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYGVLBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYGVLBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYGVLBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:01:01 -0400
Received: from ozlabs.org ([203.10.76.45]:36682 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbYGVLBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:01:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] x86: rename PTE_MASK to PTE_PFN_MASK
Date: Tue, 22 Jul 2008 20:58:36 +1000
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
References: <200807221431.58991.rusty@rustcorp.com.au> <4885774E.3000909@goop.org> <20080722083626.GC2065@elte.hu>
In-Reply-To: <20080722083626.GC2065@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807222058.37130.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 18:36:26 Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > Rusty, in his peevish way, complained that macros defining constants
> > should have a name which somewhat accurately reflects the actual
> > purpose of the constant.
>
> Applied to tip/x86/cleanups anyway. Rusty will find out himself how bad
> this whole concept of clean and understandable code is, soon enough!

I am disgusted with this inappropriate emphasis on clarity over obscurity.  It
should be pretty clear to everyone here that we can't have both!

Fortunately, there is a way to partially rectify the situation. Ingo, please
apply.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/asm-x86/page.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index 6c84622..4207518 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -10,6 +10,7 @@
 
 #ifdef __KERNEL__
 
+/* There's something suspicious about this line: see PTE_PFN_MASK comment. */
 #define __PHYSICAL_MASK		((phys_addr_t)(1ULL << __PHYSICAL_MASK_SHIFT) - 1)
 #define __VIRTUAL_MASK		((1UL << __VIRTUAL_MASK_SHIFT) - 1)
 
@@ -19,6 +20,7 @@
 #define PHYSICAL_PAGE_MASK	(((signed long)PAGE_MASK) & __PHYSICAL_MASK)
 
 /* PTE_PFN_MASK extracts the PFN from a (pte|pmd|pud|pgd)val_t */
+/* This line is quite subtle.  See __PHYSICAL_MASK comment above. */
 #define PTE_PFN_MASK		((pteval_t)PHYSICAL_PAGE_MASK)
 
 /* PTE_FLAGS_MASK extracts the flags from a (pte|pmd|pud|pgd)val_t */
