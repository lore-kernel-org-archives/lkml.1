Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYB2LvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYB2LvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYB2LvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:51:06 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:63980 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbYB2LvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:51:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=p6vHAWyeMwLQfosmRsZ/DmA9GpFsSsCllC9w7LWllDt5oFXQh9Eczei+0u7DvVmh8yuU9VPxludDAgjPArOuGiDEBjUH8r6wgPp0j3dtCZIVDeuN6yZEft6d1y+owE8zyuwJTNIGXpldazx3ORsZ0JIBHfqPrXwEqToM023M0EQ=
Date: Fri, 29 Feb 2008 12:50:56 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86: coding style fixes to arch/x86/lib/usercopy_32.c
Message-ID: <20080229125056.21f76634@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
 total: 63 errors, 2 warnings, 878 lines checked
After:
 total: 0 errors, 2 warnings, 878 lines checked

Compile tested, no change in the binaty output:

text    data     bss     dec     hex filename
3231       0       0    3231     c9f usercopy_32.o.after
3231       0       0    3231     c9f usercopy_32.o.before

md5sum:
9f9a3eb43970359ae7cecfd1c9e7cf42  usercopy_32.o.after
9f9a3eb43970359ae7cecfd1c9e7cf42  usercopy_32.o.before


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/lib/usercopy_32.c |  122 ++++++++++++++++++++++----------------------
 1 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index e849b99..24e6094 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * User address space access functions.
  * The non inlined parts of asm-i386/uaccess.h are here.
  *
@@ -22,14 +22,14 @@ static inline int __movsl_is_ok(unsigned long a1, unsigned long a2, unsigned lon
 #endif
 	return 1;
 }
-#define movsl_is_ok(a1,a2,n) \
-	__movsl_is_ok((unsigned long)(a1),(unsigned long)(a2),(n))
+#define movsl_is_ok(a1, a2, n) \
+	__movsl_is_ok((unsigned long)(a1), (unsigned long)(a2), (n))
 
 /*
  * Copy a null terminated string from userspace.
  */
 
-#define __do_strncpy_from_user(dst,src,count,res)			   \
+#define __do_strncpy_from_user(dst, src, count, res)			   \
 do {									   \
 	int __d0, __d1, __d2;						   \
 	might_sleep();							   \
@@ -61,7 +61,7 @@ do {									   \
  *         least @count bytes long.
  * @src:   Source address, in user space.
  * @count: Maximum number of bytes to copy, including the trailing NUL.
- * 
+ *
  * Copies a NUL-terminated string from userspace to kernel space.
  * Caller must check the specified block with access_ok() before calling
  * this function.
@@ -90,7 +90,7 @@ EXPORT_SYMBOL(__strncpy_from_user);
  *         least @count bytes long.
  * @src:   Source address, in user space.
  * @count: Maximum number of bytes to copy, including the trailing NUL.
- * 
+ *
  * Copies a NUL-terminated string from userspace to kernel space.
  *
  * On success, returns the length of the string (not including the trailing
@@ -120,7 +120,7 @@ EXPORT_SYMBOL(strncpy_from_user);
 do {									\
 	int __d0;							\
 	might_sleep();							\
-  	__asm__ __volatile__(						\
+	__asm__ __volatile__(						\
 		"0:	rep; stosl\n"					\
 		"	movl %2,%0\n"					\
 		"1:	rep; stosb\n"					\
@@ -333,17 +333,17 @@ __copy_user_zeroing_intel(void *to, const void __user *from, unsigned long size)
 	__asm__ __volatile__(
 		       "        .align 2,0x90\n"
 		       "0:      movl 32(%4), %%eax\n"
-		       "        cmpl $67, %0\n"      
-		       "        jbe 2f\n"            
+		       "        cmpl $67, %0\n"
+		       "        jbe 2f\n"
 		       "1:      movl 64(%4), %%eax\n"
-		       "        .align 2,0x90\n"     
-		       "2:      movl 0(%4), %%eax\n" 
-		       "21:     movl 4(%4), %%edx\n" 
-		       "        movl %%eax, 0(%3)\n" 
-		       "        movl %%edx, 4(%3)\n" 
-		       "3:      movl 8(%4), %%eax\n" 
-		       "31:     movl 12(%4),%%edx\n" 
-		       "        movl %%eax, 8(%3)\n" 
+		       "        .align 2,0x90\n"
+		       "2:      movl 0(%4), %%eax\n"
+		       "21:     movl 4(%4), %%edx\n"
+		       "        movl %%eax, 0(%3)\n"
+		       "        movl %%edx, 4(%3)\n"
+		       "3:      movl 8(%4), %%eax\n"
+		       "31:     movl 12(%4),%%edx\n"
+		       "        movl %%eax, 8(%3)\n"
 		       "        movl %%edx, 12(%3)\n"
 		       "4:      movl 16(%4), %%eax\n"
 		       "41:     movl 20(%4), %%edx\n"
@@ -369,38 +369,38 @@ __copy_user_zeroing_intel(void *to, const void __user *from, unsigned long size)
 		       "91:     movl 60(%4), %%edx\n"
 		       "        movl %%eax, 56(%3)\n"
 		       "        movl %%edx, 60(%3)\n"
-		       "        addl $-64, %0\n"     
-		       "        addl $64, %4\n"      
-		       "        addl $64, %3\n"      
-		       "        cmpl $63, %0\n"      
-		       "        ja  0b\n"            
-		       "5:      movl  %0, %%eax\n"   
-		       "        shrl  $2, %0\n"      
-		       "        andl $3, %%eax\n"    
-		       "        cld\n"               
-		       "6:      rep; movsl\n"   
+		       "        addl $-64, %0\n"
+		       "        addl $64, %4\n"
+		       "        addl $64, %3\n"
+		       "        cmpl $63, %0\n"
+		       "        ja  0b\n"
+		       "5:      movl  %0, %%eax\n"
+		       "        shrl  $2, %0\n"
+		       "        andl $3, %%eax\n"
+		       "        cld\n"
+		       "6:      rep; movsl\n"
 		       "        movl %%eax,%0\n"
-		       "7:      rep; movsb\n"	
-		       "8:\n"			
+		       "7:      rep; movsb\n"
+		       "8:\n"
 		       ".section .fixup,\"ax\"\n"
-		       "9:      lea 0(%%eax,%0,4),%0\n"	
-		       "16:     pushl %0\n"	
-		       "        pushl %%eax\n"	
+		       "9:      lea 0(%%eax,%0,4),%0\n"
+		       "16:     pushl %0\n"
+		       "        pushl %%eax\n"
 		       "        xorl %%eax,%%eax\n"
-		       "        rep; stosb\n"	
-		       "        popl %%eax\n"	
-		       "        popl %0\n"	
-		       "        jmp 8b\n"	
-		       ".previous\n"		
+		       "        rep; stosb\n"
+		       "        popl %%eax\n"
+		       "        popl %0\n"
+		       "        jmp 8b\n"
+		       ".previous\n"
 		       ".section __ex_table,\"a\"\n"
-		       "	.align 4\n"	   
-		       "	.long 0b,16b\n"	 
+		       "	.align 4\n"
+		       "	.long 0b,16b\n"
 		       "	.long 1b,16b\n"
 		       "	.long 2b,16b\n"
 		       "	.long 21b,16b\n"
-		       "	.long 3b,16b\n"	
+		       "	.long 3b,16b\n"
 		       "	.long 31b,16b\n"
-		       "	.long 4b,16b\n"	
+		       "	.long 4b,16b\n"
 		       "	.long 41b,16b\n"
 		       "	.long 10b,16b\n"
 		       "	.long 51b,16b\n"
@@ -412,9 +412,9 @@ __copy_user_zeroing_intel(void *to, const void __user *from, unsigned long size)
 		       "	.long 81b,16b\n"
 		       "	.long 14b,16b\n"
 		       "	.long 91b,16b\n"
-		       "	.long 6b,9b\n"	
-		       "        .long 7b,16b\n" 
-		       ".previous"		
+		       "	.long 6b,9b\n"
+		       "        .long 7b,16b\n"
+		       ".previous"
 		       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 		       :  "1"(to), "2"(from), "0"(size)
 		       : "eax", "edx", "memory");
@@ -429,7 +429,7 @@ __copy_user_zeroing_intel(void *to, const void __user *from, unsigned long size)
 static unsigned long __copy_user_zeroing_intel_nocache(void *to,
 				const void __user *from, unsigned long size)
 {
-        int d0, d1;
+	int d0, d1;
 
 	__asm__ __volatile__(
 	       "        .align 2,0x90\n"
@@ -526,7 +526,7 @@ static unsigned long __copy_user_zeroing_intel_nocache(void *to,
 static unsigned long __copy_user_intel_nocache(void *to,
 				const void __user *from, unsigned long size)
 {
-        int d0, d1;
+	int d0, d1;
 
 	__asm__ __volatile__(
 	       "        .align 2,0x90\n"
@@ -629,7 +629,7 @@ unsigned long __copy_user_zeroing_intel_nocache(void *to,
 #endif /* CONFIG_X86_INTEL_USERCOPY */
 
 /* Generic arbitrary sized copy.  */
-#define __copy_user(to,from,size)					\
+#define __copy_user(to, from, size)					\
 do {									\
 	int __d0, __d1, __d2;						\
 	__asm__ __volatile__(						\
@@ -665,7 +665,7 @@ do {									\
 		: "memory");						\
 } while (0)
 
-#define __copy_user_zeroing(to,from,size)				\
+#define __copy_user_zeroing(to, from, size)				\
 do {									\
 	int __d0, __d1, __d2;						\
 	__asm__ __volatile__(						\
@@ -712,7 +712,7 @@ unsigned long __copy_to_user_ll(void __user *to, const void *from,
 {
 #ifndef CONFIG_X86_WP_WORKS_OK
 	if (unlikely(boot_cpu_data.wp_works_ok == 0) &&
-			((unsigned long )to) < TASK_SIZE) {
+			((unsigned long)to) < TASK_SIZE) {
 		/*
 		 * When we are in an atomic section (see
 		 * mm/filemap.c:file_read_actor), return the full
@@ -721,26 +721,26 @@ unsigned long __copy_to_user_ll(void __user *to, const void *from,
 		if (in_atomic())
 			return n;
 
-		/* 
+		/*
 		 * CPU does not honor the WP bit when writing
 		 * from supervisory mode, and due to preemption or SMP,
 		 * the page tables can change at any time.
 		 * Do it manually.	Manfred <manfred@colorfullife.com>
 		 */
 		while (n) {
-		      	unsigned long offset = ((unsigned long)to)%PAGE_SIZE;
+			unsigned long offset = ((unsigned long)to)%PAGE_SIZE;
 			unsigned long len = PAGE_SIZE - offset;
 			int retval;
 			struct page *pg;
 			void *maddr;
-			
+
 			if (len > n)
 				len = n;
 
 survive:
 			down_read(&current->mm->mmap_sem);
 			retval = get_user_pages(current, current->mm,
-					(unsigned long )to, 1, 1, 0, &pg, NULL);
+					(unsigned long)to, 1, 1, 0, &pg, NULL);
 
 			if (retval == -ENOMEM && is_global_init(current)) {
 				up_read(&current->mm->mmap_sem);
@@ -750,8 +750,8 @@ survive:
 
 			if (retval != 1) {
 				up_read(&current->mm->mmap_sem);
-		       		break;
-		       	}
+				break;
+			}
 
 			maddr = kmap_atomic(pg, KM_USER0);
 			memcpy(maddr + offset, from, len);
@@ -802,12 +802,12 @@ unsigned long __copy_from_user_ll_nocache(void *to, const void __user *from,
 					unsigned long n)
 {
 #ifdef CONFIG_X86_INTEL_USERCOPY
-	if ( n > 64 && cpu_has_xmm2)
-                n = __copy_user_zeroing_intel_nocache(to, from, n);
+	if (n > 64 && cpu_has_xmm2)
+		n = __copy_user_zeroing_intel_nocache(to, from, n);
 	else
 		__copy_user_zeroing(to, from, n);
 #else
-        __copy_user_zeroing(to, from, n);
+	__copy_user_zeroing(to, from, n);
 #endif
 	return n;
 }
@@ -817,12 +817,12 @@ unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *fr
 					unsigned long n)
 {
 #ifdef CONFIG_X86_INTEL_USERCOPY
-	if ( n > 64 && cpu_has_xmm2)
-                n = __copy_user_intel_nocache(to, from, n);
+	if (n > 64 && cpu_has_xmm2)
+		n = __copy_user_intel_nocache(to, from, n);
 	else
 		__copy_user(to, from, n);
 #else
-        __copy_user(to, from, n);
+	__copy_user(to, from, n);
 #endif
 	return n;
 }
-- 
1.5.4.2.316.gf7a7

