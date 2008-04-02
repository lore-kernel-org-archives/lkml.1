Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbYDBBic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbYDBBic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 21:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYDBBiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 21:38:24 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:49855 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbYDBBiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 21:38:24 -0400
Date: Tue, 1 Apr 2008 21:38:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Drop an empty byteorder/generic.h from being exported to
 userspace.
Message-ID: <alpine.LFD.1.00.0804012134300.10852@localhost.localdomain>
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


Since the entire meaningful contents of generic.h is wrapped by the
__KERNEL__ test, drop it from being passed to userspace, and remove
the now superfluous __KERNEL__ test.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  is there some value in allowing an effectively empty header file to
be exported to userspace?

 include/linux/byteorder/Kbuild    |    1 -
 include/linux/byteorder/generic.h |    8 --------
 2 files changed, 9 deletions(-)

diff --git a/include/linux/byteorder/Kbuild b/include/linux/byteorder/Kbuild
index 79beddd..a50614c 100644
--- a/include/linux/byteorder/Kbuild
+++ b/include/linux/byteorder/Kbuild
@@ -1,5 +1,4 @@
 header-y += big_endian.h
 header-y += little_endian.h

-unifdef-y += generic.h
 unifdef-y += swab.h
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
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
