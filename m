Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbYBQN5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbYBQN5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbYBQN5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:57:01 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:16417 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520AbYBQN47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:56:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=UqBC/NFhJxpPoN3oHYib49x+WREJ0nuYQvP2+G20HNWZPnMMt3w9D6Xp4iTa3CUI3S4p7mPjV9AgzDYBqwSNOhzotKOtzmZ9Rppd+Powxe9f4qmKbEg1sr93wPyi50pvXmLLINZV3LdvajWPMep/7oqC3+saE53Xn0R8Eu7cH1I=
Date: Sun, 17 Feb 2008 14:56:50 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86: whitespaces fixes in
 arch/x86/lib/csum-wrappers_64.c
Message-ID: <20080217145650.43831c43@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/2] x86: whitespaces fixes in arch/x86/lib/csum-wrappers_64.c

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/lib/csum-wrappers_64.c |   77 ++++++++++++++++++++-------------------
 1 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/arch/x86/lib/csum-wrappers_64.c b/arch/x86/lib/csum-wrappers_64.c
index fd42a4a..a8ce791 100644
--- a/arch/x86/lib/csum-wrappers_64.c
+++ b/arch/x86/lib/csum-wrappers_64.c
@@ -1,117 +1,118 @@
 /* Copyright 2002,2003 Andi Kleen, SuSE Labs.
  * Subject to the GNU Public License v.2
- * 
+ *
  * Wrappers of assembly checksum functions for x86-64.
  */
 
 #include <asm/checksum.h>
 #include <linux/module.h>
 
-/** 
- * csum_partial_copy_from_user - Copy and checksum from user space. 
- * @src: source address (user space) 
+/**
+ * csum_partial_copy_from_user - Copy and checksum from user space.
+ * @src: source address (user space)
  * @dst: destination address
  * @len: number of bytes to be copied.
  * @isum: initial sum that is added into the result (32bit unfolded)
  * @errp: set to -EFAULT for an bad source address.
- * 
+ *
  * Returns an 32bit unfolded checksum of the buffer.
- * src and dst are best aligned to 64bits. 
- */ 
+ * src and dst are best aligned to 64bits.
+ */
 __wsum
 csum_partial_copy_from_user(const void __user *src, void *dst,
 			    int len, __wsum isum, int *errp)
-{ 
+{
 	might_sleep();
 	*errp = 0;
-	if (likely(access_ok(VERIFY_READ,src, len))) { 
+	if (likely(access_ok(VERIFY_READ,src, len))) {
 		/* Why 6, not 7? To handle odd addresses aligned we
 		   would need to do considerable complications to fix the
 		   checksum which is defined as an 16bit accumulator. The
 		   fix alignment code is primarily for performance
 		   compatibility with 32bit and that will handle odd
 		   addresses slowly too. */
-		if (unlikely((unsigned long)src & 6)) {			
-			while (((unsigned long)src & 6) && len >= 2) { 
-				__u16 val16;			
+		if (unlikely((unsigned long)src & 6)) {
+			while (((unsigned long)src & 6) && len >= 2) {
+				__u16 val16;
 				*errp = __get_user(val16, (const __u16 __user *)src);
 				if (*errp)
 					return isum;
 				*(__u16 *)dst = val16;
 				isum = (__force __wsum)add32_with_carry(
 						(__force unsigned)isum, val16);
-				src += 2; 
-				dst += 2; 
+				src += 2;
+				dst += 2;
 				len -= 2;
 			}
 		}
 		isum = csum_partial_copy_generic((__force const void *)src,
 					dst, len, isum, errp, NULL);
-		if (likely(*errp == 0)) 
+		if (likely(*errp == 0))
 			return isum;
-	} 
+	}
 	*errp = -EFAULT;
-	memset(dst,0,len); 
-	return isum;		
-} 
+	memset(dst,0,len);
+	return isum;
+}
 
 EXPORT_SYMBOL(csum_partial_copy_from_user);
 
-/** 
- * csum_partial_copy_to_user - Copy and checksum to user space. 
+/**
+ * csum_partial_copy_to_user - Copy and checksum to user space.
  * @src: source address
  * @dst: destination address (user space)
  * @len: number of bytes to be copied.
  * @isum: initial sum that is added into the result (32bit unfolded)
  * @errp: set to -EFAULT for an bad destination address.
- * 
+ *
  * Returns an 32bit unfolded checksum of the buffer.
  * src and dst are best aligned to 64bits.
- */ 
+ */
 __wsum
 csum_partial_copy_to_user(const void *src, void __user *dst,
 			  int len, __wsum isum, int *errp)
-{ 
+{
 	might_sleep();
 	if (unlikely(!access_ok(VERIFY_WRITE, dst, len))) {
 		*errp = -EFAULT;
-		return 0; 
+		return 0;
 	}
 
 	if (unlikely((unsigned long)dst & 6)) {
-		while (((unsigned long)dst & 6) && len >= 2) { 
+		while (((unsigned long)dst & 6) && len >= 2) {
 			__u16 val16 = *(__u16 *)src;
 			isum = (__force __wsum)add32_with_carry(
 					(__force unsigned)isum, val16);
 			*errp = __put_user(val16, (__u16 __user *)dst);
 			if (*errp)
 				return isum;
-			src += 2; 
-			dst += 2; 
+			src += 2;
+			dst += 2;
 			len -= 2;
 		}
 	}
 
 	*errp = 0;
-	return csum_partial_copy_generic(src, (void __force *)dst,len,isum,NULL,errp); 
-} 
+	return csum_partial_copy_generic(src, (void __force *)dst, len, isum, NULL, errp);
+
+}
 
 EXPORT_SYMBOL(csum_partial_copy_to_user);
 
-/** 
+/**
  * csum_partial_copy_nocheck - Copy and checksum.
  * @src: source address
  * @dst: destination address
  * @len: number of bytes to be copied.
  * @isum: initial sum that is added into the result (32bit unfolded)
- * 
+ *
  * Returns an 32bit unfolded checksum of the buffer.
- */ 
+ */
 __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum)
-{ 
+{
 	return csum_partial_copy_generic(src,dst,len,sum,NULL,NULL);
-} 
+}
 EXPORT_SYMBOL(csum_partial_copy_nocheck);
 
 __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
@@ -119,15 +120,15 @@ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 			__u32 len, unsigned short proto, __wsum sum)
 {
 	__u64 rest, sum64;
-     
+
 	rest = (__force __u64)htonl(len) + (__force __u64)htons(proto) +
 		(__force __u64)sum;
 	asm("  addq (%[saddr]),%[sum]\n"
 	    "  adcq 8(%[saddr]),%[sum]\n"
-	    "  adcq (%[daddr]),%[sum]\n" 
+	    "  adcq (%[daddr]),%[sum]\n"
 	    "  adcq 8(%[daddr]),%[sum]\n"
 	    "  adcq $0,%[sum]\n"
-	    : [sum] "=r" (sum64) 
+	    : [sum] "=r" (sum64)
 	    : "[sum]" (rest),[saddr] "r" (saddr), [daddr] "r" (daddr));
 	return csum_fold((__force __wsum)add32_with_carry(sum64 & 0xffffffff, sum64>>32));
 }
-- 
1.5.4.1.183.gf873

