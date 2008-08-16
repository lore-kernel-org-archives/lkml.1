Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYHPKIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYHPKIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYHPKIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:08:00 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:40822 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYHPKH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:07:59 -0400
Date: Sat, 16 Aug 2008 11:07:21 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] VMA comment fixes
In-Reply-To: <200808160934.m7G9YgWs028953@hs20-bc2-1.build.redhat.com>
Message-ID: <Pine.LNX.4.64.0808161056520.17894@blonde.site>
References: <200808160934.m7G9YgWs028953@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008, Ulrich Drepper wrote:

> These seem to be two tiny problems in comments related to VMA data
> structures.  Am I correct?

Not on this occasion - fixed patch at the bottom.
I suspect you of having a wicked sense of humour.

(Once upon a time some types got separated out from mm.h to mm_types.h:
probably mm.h's VM_flags should have travelled with vm_area_struct,
even though they're not types.  And on another occasion, a forward
declaration of vm_area_struct was put in vmalloc.h, home of vm_struct.)

> 
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 386edbe..5ceb830 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -113,7 +113,7 @@ struct vm_area_struct {
>  	struct vm_area_struct *vm_next;
>  
>  	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
> -	unsigned long vm_flags;		/* Flags, listed below. */
> +	unsigned long vm_flags;		/* Flags, see vmalloc.h. */
>  
>  	struct rb_node vm_rb;
>  
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 364789a..39fc8d7 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -6,7 +6,7 @@
>  
>  struct vm_area_struct;
>  
> -/* bits in vm_struct->flags */
> +/* bits in vm_area_struct->flags */
>  #define VM_IOREMAP	0x00000001	/* ioremap() and friends */
>  #define VM_ALLOC	0x00000002	/* vmalloc() */
>  #define VM_MAP		0x00000004	/* vmap()ed pages */

[PATCH] mm: VM_flags comment fixes

Try to comment away a little of the confusion between mm's vm_area_struct
vm_flags and vmalloc's vm_struct flags: based on an idea by Ulrich Drepper.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/linux/mm.h       |    2 +-
 include/linux/mm_types.h |    2 +-
 include/linux/vmalloc.h  |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- 2.6.27-rc3/include/linux/mm.h	2008-08-13 04:14:50.000000000 +0100
+++ linux/include/linux/mm.h	2008-08-16 10:51:58.000000000 +0100
@@ -73,7 +73,7 @@ extern unsigned int kobjsize(const void 
 #endif
 
 /*
- * vm_flags..
+ * vm_flags in vm_area_struct, see mm_types.h.
  */
 #define VM_READ		0x00000001	/* currently active flags */
 #define VM_WRITE	0x00000002
--- 2.6.27-rc3/include/linux/mm_types.h	2008-07-29 04:24:55.000000000 +0100
+++ linux/include/linux/mm_types.h	2008-08-16 10:44:34.000000000 +0100
@@ -113,7 +113,7 @@ struct vm_area_struct {
 	struct vm_area_struct *vm_next;
 
 	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
-	unsigned long vm_flags;		/* Flags, listed below. */
+	unsigned long vm_flags;		/* Flags, see mm.h. */
 
 	struct rb_node vm_rb;
 
--- 2.6.27-rc3/include/linux/vmalloc.h	2008-07-13 22:51:29.000000000 +0100
+++ linux/include/linux/vmalloc.h	2008-08-16 10:51:58.000000000 +0100
@@ -4,9 +4,9 @@
 #include <linux/spinlock.h>
 #include <asm/page.h>		/* pgprot_t */
 
-struct vm_area_struct;
+struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 
-/* bits in vm_struct->flags */
+/* bits in flags of vmalloc's vm_struct below */
 #define VM_IOREMAP	0x00000001	/* ioremap() and friends */
 #define VM_ALLOC	0x00000002	/* vmalloc() */
 #define VM_MAP		0x00000004	/* vmap()ed pages */
