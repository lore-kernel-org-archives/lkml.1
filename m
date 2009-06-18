Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbZFRNLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbZFRNLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 09:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbZFRNLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 09:11:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:53930 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZFRNLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 09:11:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5 -tip] x86: move common typedefs to asm/posix_types.h
Date: Thu, 18 Jun 2009 15:10:26 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1245314365.31204.7.camel@ht.satnam> <1245314484.31204.10.camel@ht.satnam> <20090618115101.GA1671@infradead.org>
In-Reply-To: <20090618115101.GA1671@infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906181510.27464.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18uhpaKLRZQNEjNb3at/k0CAJBouzVI0zDvpn/
 oauDw9m18aSoVOAJuzdXxeu5mCCHbiI9p8BYWH1fS01IwvhyVk
 DiXk0LQEhvDxHLsdmeUw7utuJO6qITL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 June 2009, Christoph Hellwig wrote:
> 
> On Thu, Jun 18, 2009 at 02:11:24PM +0530, Jaswinder Singh Rajput wrote:
> > 
> > Move common typedefs to asm/posix_types.h for easy maintenance
> 
> I think at this point it would be cleaner to also move the differing
> ones into asm/posix_types.h so that there's just one file to look at for
> the types.

Agreed.

Because of the new asm-gneeric headers, you can also
#include <asm-generic/posix_types.h> for any of the default types and
only override the ones that are x86-specific.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/x86/include/asm/posix_types.h b/arch/x86/include/asm/posix_types.h
dissimilarity index 94%
index bb7133d..980736c 100644
--- a/arch/x86/include/asm/posix_types.h
+++ b/arch/x86/include/asm/posix_types.h
@@ -1,13 +1,88 @@
-#ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "posix_types_32.h"
-# else
-#  include "posix_types_64.h"
-# endif
-#else
-# ifdef __i386__
-#  include "posix_types_32.h"
-# else
-#  include "posix_types_64.h"
-# endif
-#endif
+#ifndef _ASM_X86_POSIX_TYPES_H
+#define _ASM_X86_POSIX_TYPES_H
+
+#ifdef __x86_64__
+/*
+ * These types are different on x86_64 from the asm-generic version
+ */
+#define __kernel_old_uid_t __kernel_old_uid_t
+typedef unsigned short	__kernel_old_uid_t;
+typedef unsigned short	__kernel_old_gid_t;
+
+#define __kernel_old_dev_t __kernel_old_dev_t
+typedef unsigned long	__kernel_old_dev_t;
+
+#else
+/*
+ * These types are different on x86_32 from the asm-generic version
+ */
+#define __kernel_mode_t __kernel_mode_t
+typedef unsigned short	__kernel_mode_t;
+
+#define __kernel_nlink_t __kernel_nlink_t
+typedef unsigned short	__kernel_nlink_t;
+
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+typedef unsigned short	__kernel_ipc_pid_t;
+
+#define __kernel_uid_t __kernel_uid_t
+typedef unsigned short	__kernel_uid_t;
+typedef unsigned short	__kernel_gid_t;
+
+#define __kernel_uid32_t __kernel_uid32_t
+typedef unsigned int	__kernel_uid32_t;
+typedef unsigned int	__kernel_gid32_t;
+
+#define __kernel_old_uid_t __kernel_old_uid_t
+typedef unsigned short	__kernel_old_uid_t;
+typedef unsigned short	__kernel_old_gid_t;
+
+#define __kernel_old_dev_t __kernel_old_dev_t
+typedef unsigned short	__kernel_old_dev_t;
+
+#endif
+
+#include <asm-generic/posix_types.h>
+
+#if defined(__KERNEL__)
+#ifndef CONFIG_X86_64
+
+#undef	__FD_SET
+#define __FD_SET(fd,fdsetp)					\
+	asm volatile("btsl %1,%0":				\
+		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
+		     : "r" ((int)(fd)))
+
+#undef	__FD_CLR
+#define __FD_CLR(fd,fdsetp)					\
+	asm volatile("btrl %1,%0":				\
+		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
+		     : "r" ((int) (fd)))
+
+#undef	__FD_ISSET
+#define __FD_ISSET(fd,fdsetp)					\
+	(__extension__						\
+	 ({							\
+	 unsigned char __result;				\
+	 asm volatile("btl %1,%2 ; setb %0"			\
+		      : "=q" (__result)				\
+		      : "r" ((int)(fd)),			\
+			"m" (*(__kernel_fd_set *)(fdsetp)));	\
+	 __result;						\
+}))
+
+#undef	__FD_ZERO
+#define __FD_ZERO(fdsetp)					\
+do {								\
+	int __d0, __d1;						\
+	asm volatile("cld ; rep ; stosl"			\
+		     : "=m" (*(__kernel_fd_set *)(fdsetp)),	\
+		       "=&c" (__d0), "=&D" (__d1)		\
+		     : "a" (0), "1" (__FDSET_LONGS),		\
+		       "2" ((__kernel_fd_set *)(fdsetp))	\
+		     : "memory");				\
+} while (0)
+#endif /* CONFIG_X86_64 */
+#endif /* defined(__KERNEL__) */
+
+#endif /* _ASM_X86_POSIX_TYPES_H */
