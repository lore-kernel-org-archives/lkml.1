Return-Path: <linux-kernel-owner+w=401wt.eu-S1765797AbXFRTr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765797AbXFRTr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763256AbXFRTrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:47:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44448 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763046AbXFRTrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:47:21 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Christoph Hellwig <hch@infradead.org>
Subject: [patch] dont export ia64 intrin headers and sanitize asm-ia64/byteorder.h
Date: Mon, 18 Jun 2007 15:47:34 -0400
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com
References: <200706180219.11164.vapier@gentoo.org> <20070618183754.GC17112@infradead.org>
In-Reply-To: <20070618183754.GC17112@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706181547.34793.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2007, Christoph Hellwig wrote:
> On Mon, Jun 18, 2007 at 02:19:10AM -0400, Mike Frysinger wrote:
> > Since asm-ia64/gcc_intrin.h gets exported to userspace, we need to make
> > sure to use __asm__() rather than asm() since the latter is not available
> > when compiling with gcc with GNU extensions turned off (like -std=c99).
>
> This header is only for kernel-internal use and should not be exported
> to userspace at all.

so like the following

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-ia64/Kbuild b/include/asm-ia64/Kbuild
index 4a1e48b..fc03b88 100644
--- a/include/asm-ia64/Kbuild
+++ b/include/asm-ia64/Kbuild
@@ -3,10 +3,7 @@ include include/asm-generic/Kbuild.asm
 header-y += break.h
 header-y += fpu.h
 header-y += fpswa.h
-header-y += gcc_intrin.h
 header-y += ia64regs.h
-header-y += intel_intrin.h
-header-y += intrinsics.h
 header-y += perfmon_default_smpl.h
 header-y += ptrace_offsets.h
 header-y += rse.h
diff --git a/include/asm-ia64/byteorder.h b/include/asm-ia64/byteorder.h
index 69bd41d..783e272 100644
--- a/include/asm-ia64/byteorder.h
+++ b/include/asm-ia64/byteorder.h
@@ -7,6 +7,9 @@
  */
 
 #include <asm/types.h>
+
+#ifdef __KERNEL__
+
 #include <asm/intrinsics.h>
 #include <linux/compiler.h>
 
@@ -35,6 +38,8 @@ __ia64_swab16(__u16 x)
 #define __arch__swab32(x) __ia64_swab32(x)
 #define __arch__swab16(x) __ia64_swab16(x)
 
+#endif
+
 #define __BYTEORDER_HAS_U64__
 
 #include <linux/byteorder/little_endian.h>

