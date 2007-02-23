Return-Path: <linux-kernel-owner+w=401wt.eu-S933111AbXBWQD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111AbXBWQD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 11:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932949AbXBWQD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 11:03:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933111AbXBWQD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 11:03:57 -0500
Message-ID: <45DF103B.3000104@redhat.com>
Date: Fri, 23 Feb 2007 17:03:07 +0100
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compilation of drivers with -O0
References: <45DF0EFA.3070706@redhat.com>
In-Reply-To: <45DF0EFA.3070706@redhat.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry, the patch was corrupted by the mailer. Hopefully it's ok this time.]

It is sometimes useful to compile individual drivers with optimization
disabled for easier debugging. Currently drivers which use htonl() and
similar functions don't compile with -O0. This patch fixes it.
It also removes obsolete and misleading comments. This header is not
for userspace, so we don't have to care about strange programs these
comments mention.


Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

diff --git a/include/linux/byteorder/generic.h
b/include/linux/byteorder/generic.h
index e86e4a9..3dc715b 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -124,19 +124,8 @@
 #define be32_to_cpus __be32_to_cpus
 #define cpu_to_be16s __cpu_to_be16s
 #define be16_to_cpus __be16_to_cpus
-#endif

-
-#if defined(__KERNEL__)
 /*
- * Handle ntohl and suches. These have various compatibility
- * issues - like we want to give the prototype even though we
- * also have a macro for them in case some strange program
- * wants to take the address of the thing or something..
- *
- * Note that these used to return a "long" in libc5, even though
- * long is often 64-bit these days.. Thus the casts.
- *
  * They have to be macros in order to do the constant folding
  * correctly - if the argument passed into a inline function
  * it is no longer constant according to gcc..
@@ -147,17 +136,6 @@
 #undef htonl
 #undef htons

-/*
- * Do the prototypes. Somebody might want to take the
- * address or some such sick thing..
- */
-extern __u32            ntohl(__be32);
-extern __be32            htonl(__u32);
-extern __u16            ntohs(__be16);
-extern __be16            htons(__u16);
-
-#if defined(__GNUC__) && defined(__OPTIMIZE__)
-
 #define ___htonl(x) __cpu_to_be32(x)
 #define ___htons(x) __cpu_to_be16(x)
 #define ___ntohl(x) __be32_to_cpu(x)
@@ -168,9 +146,6 @@ extern __be16            htons(__u16);
 #define htons(x) ___htons(x)
 #define ntohs(x) ___ntohs(x)

-#endif /* OPTIMIZE */
-
 #endif /* KERNEL */

-
 #endif /* _LINUX_BYTEORDER_GENERIC_H */


