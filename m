Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYDBMFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYDBMFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYDBMEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:04:53 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:48623 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbYDBMEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:04:52 -0400
Date: Wed, 2 Apr 2008 08:04:45 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Drop the exporting of empty <linux/byteorder/generic.h>.
Message-ID: <alpine.LFD.1.00.0804020757590.17773@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix up the contents of <linux/byteorder/> so that it doesn't export a
content-free generic.h to user space.  This involves:

* Removing the __KERNEL__ tests from generic.h and dropping it from
  Kbuild.
* Wrapping the inclusions of generic.h in both big_endian.h and
  little_endian.h in __KERNEL__ tests.
* Shifting big_endian.h and little_endian.h from header-y to
  unifdef-y in Kbuild.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  what kernel subsystem would stuff like this fall under?


 include/linux/byteorder/Kbuild          |    6 ++----
 include/linux/byteorder/big_endian.h    |    2 ++
 include/linux/byteorder/generic.h       |    8 --------
 include/linux/byteorder/little_endian.h |    2 ++
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/include/linux/byteorder/Kbuild b/include/linux/byteorder/Kbuild
index 79beddd..1133d5f 100644
--- a/include/linux/byteorder/Kbuild
+++ b/include/linux/byteorder/Kbuild
@@ -1,5 +1,3 @@
-header-y += big_endian.h
-header-y += little_endian.h
-
-unifdef-y += generic.h
+unifdef-y += big_endian.h
+unifdef-y += little_endian.h
 unifdef-y += swab.h
diff --git a/include/linux/byteorder/big_endian.h b/include/linux/byteorder/big_endian.h
index bef8789..961ed4b 100644
--- a/include/linux/byteorder/big_endian.h
+++ b/include/linux/byteorder/big_endian.h
@@ -101,6 +101,8 @@ static inline __u16 __be16_to_cpup(const __be16 *p)
 #define __cpu_to_be16s(x) do {} while (0)
 #define __be16_to_cpus(x) do {} while (0)

+#ifdef __KERNEL__
 #include <linux/byteorder/generic.h>
+#endif

 #endif /* _LINUX_BYTEORDER_BIG_ENDIAN_H */
diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
index d377155..0846e6b 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -82,12 +82,6 @@
  *
  */

-
-#if defined(__KERNEL__)
-/*
- * inside the kernel, we can use nicknames;
- * outside of it, we must avoid POSIX namespace pollution...
- */
 #define cpu_to_le64 __cpu_to_le64
 #define le64_to_cpu __le64_to_cpu
 #define cpu_to_le32 __cpu_to_le32
@@ -176,6 +170,4 @@ static inline void be64_add_cpu(__be64 *var, u64 val)
 	*var = cpu_to_be64(be64_to_cpu(*var) + val);
 }

-#endif /* KERNEL */
-
 #endif /* _LINUX_BYTEORDER_GENERIC_H */
diff --git a/include/linux/byteorder/little_endian.h b/include/linux/byteorder/little_endian.h
index 86e62b7..05dc7c3 100644
--- a/include/linux/byteorder/little_endian.h
+++ b/include/linux/byteorder/little_endian.h
@@ -101,6 +101,8 @@ static inline __u16 __be16_to_cpup(const __be16 *p)
 #define __cpu_to_be16s(x) __swab16s((x))
 #define __be16_to_cpus(x) __swab16s((x))

+#ifdef __KERNEL__
 #include <linux/byteorder/generic.h>
+#endif

 #endif /* _LINUX_BYTEORDER_LITTLE_ENDIAN_H */

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
