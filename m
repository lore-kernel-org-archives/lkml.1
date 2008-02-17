Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbYBQN55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbYBQN55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbYBQN5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:57:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:24662 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842AbYBQN5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:57:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ttg4qdteURA7+4avOUz6eTRKk/YS6tniKCmxNWaMKo4RApNCTILYwU22BBflNudelPAyPt246rEFZiW/YiaAySaBNFolEh4CuBmqWX+ZHFaWX6QIx3w2XU9TZvHOB0bC9aes/jDhFhi5tC/6uBAytiyHHNaI2C3MR8/drOUaM7Y=
Date: Sun, 17 Feb 2008 14:57:28 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] x86: coding style fixes arch/x86/lib/csum-wrappers_64.c
Message-ID: <20080217145728.46ecdaa5@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/2] x86: coding style fixes arch/x86/lib/csum-wrappers_64.c

On top of the previous patch makes the file errors free according to checkpatch.pl

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/lib/csum-wrappers_64.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/csum-wrappers_64.c b/arch/x86/lib/csum-wrappers_64.c
index a8ce791..95e45dc 100644
--- a/arch/x86/lib/csum-wrappers_64.c
+++ b/arch/x86/lib/csum-wrappers_64.c
@@ -24,7 +24,7 @@ csum_partial_copy_from_user(const void __user *src, void *dst,
 {
 	might_sleep();
 	*errp = 0;
-	if (likely(access_ok(VERIFY_READ,src, len))) {
+	if (likely(access_ok(VERIFY_READ, src, len))) {
 		/* Why 6, not 7? To handle odd addresses aligned we
 		   would need to do considerable complications to fix the
 		   checksum which is defined as an 16bit accumulator. The
@@ -51,7 +51,7 @@ csum_partial_copy_from_user(const void __user *src, void *dst,
 			return isum;
 	}
 	*errp = -EFAULT;
-	memset(dst,0,len);
+	memset(dst, 0, len);
 	return isum;
 }
 
@@ -94,7 +94,6 @@ csum_partial_copy_to_user(const void *src, void __user *dst,
 
 	*errp = 0;
 	return csum_partial_copy_generic(src, (void __force *)dst, len, isum, NULL, errp);
-
 }
 
 EXPORT_SYMBOL(csum_partial_copy_to_user);
@@ -111,7 +110,7 @@ EXPORT_SYMBOL(csum_partial_copy_to_user);
 __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum)
 {
-	return csum_partial_copy_generic(src,dst,len,sum,NULL,NULL);
+	return csum_partial_copy_generic(src, dst, len, sum, NULL, NULL);
 }
 EXPORT_SYMBOL(csum_partial_copy_nocheck);
 
@@ -129,7 +128,7 @@ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 	    "  adcq 8(%[daddr]),%[sum]\n"
 	    "  adcq $0,%[sum]\n"
 	    : [sum] "=r" (sum64)
-	    : "[sum]" (rest),[saddr] "r" (saddr), [daddr] "r" (daddr));
+	    : "[sum]" (rest), [saddr] "r" (saddr), [daddr] "r" (daddr));
 	return csum_fold((__force __wsum)add32_with_carry(sum64 & 0xffffffff, sum64>>32));
 }
 
-- 
1.5.4.1.183.gf873

