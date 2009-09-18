Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbZIRMH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbZIRMH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbZIRMH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:07:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:55440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbZIRMHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:07:23 -0400
Date: Fri, 18 Sep 2009 12:06:54 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090910143149.GA14273@sgi.com>
References: <20090910143149.GA14273@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: SGI UV: Add volatile semantics to macros that access chipset registers
Message-ID: <tip-8dc579e868addafd24c0a015c12f0e536b1084b1@git.kernel.org>
Git-Commit-ID: 8dc579e868addafd24c0a015c12f0e536b1084b1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 18 Sep 2009 12:06:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8dc579e868addafd24c0a015c12f0e536b1084b1
Gitweb:     http://git.kernel.org/tip/8dc579e868addafd24c0a015c12f0e536b1084b1
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Thu, 10 Sep 2009 09:31:49 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 14:05:32 +0200

x86: SGI UV: Add volatile semantics to macros that access chipset registers

Add volatile-semantics to the SGI UV read/write macros that are
used to access chipset memory mapped registers. No direct
references to volatile are made. Instead the readq/writeq macros
are used.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: linux-mm@kvack.org
Cc: dwalker@fifo99.com
Cc: cfriesen@nortel.com
LKML-Reference: <20090910143149.GA14273@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/uv/uv_hub.h |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 03a0cbd..04eb6c9 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -15,6 +15,7 @@
 #include <linux/numa.h>
 #include <linux/percpu.h>
 #include <linux/timer.h>
+#include <linux/io.h>
 #include <asm/types.h>
 #include <asm/percpu.h>
 #include <asm/uv/uv_mmrs.h>
@@ -258,13 +259,13 @@ static inline unsigned long *uv_global_mmr32_address(int pnode,
 static inline void uv_write_global_mmr32(int pnode, unsigned long offset,
 				 unsigned long val)
 {
-	*uv_global_mmr32_address(pnode, offset) = val;
+	writeq(val, uv_global_mmr32_address(pnode, offset));
 }
 
 static inline unsigned long uv_read_global_mmr32(int pnode,
 						 unsigned long offset)
 {
-	return *uv_global_mmr32_address(pnode, offset);
+	return readq(uv_global_mmr32_address(pnode, offset));
 }
 
 /*
@@ -281,13 +282,13 @@ static inline unsigned long *uv_global_mmr64_address(int pnode,
 static inline void uv_write_global_mmr64(int pnode, unsigned long offset,
 				unsigned long val)
 {
-	*uv_global_mmr64_address(pnode, offset) = val;
+	writeq(val, uv_global_mmr64_address(pnode, offset));
 }
 
 static inline unsigned long uv_read_global_mmr64(int pnode,
 						 unsigned long offset)
 {
-	return *uv_global_mmr64_address(pnode, offset);
+	return readq(uv_global_mmr64_address(pnode, offset));
 }
 
 /*
@@ -301,22 +302,22 @@ static inline unsigned long *uv_local_mmr_address(unsigned long offset)
 
 static inline unsigned long uv_read_local_mmr(unsigned long offset)
 {
-	return *uv_local_mmr_address(offset);
+	return readq(uv_local_mmr_address(offset));
 }
 
 static inline void uv_write_local_mmr(unsigned long offset, unsigned long val)
 {
-	*uv_local_mmr_address(offset) = val;
+	writeq(val, uv_local_mmr_address(offset));
 }
 
 static inline unsigned char uv_read_local_mmr8(unsigned long offset)
 {
-	return *((unsigned char *)uv_local_mmr_address(offset));
+	return readb(uv_local_mmr_address(offset));
 }
 
 static inline void uv_write_local_mmr8(unsigned long offset, unsigned char val)
 {
-	*((unsigned char *)uv_local_mmr_address(offset)) = val;
+	writeb(val, uv_local_mmr_address(offset));
 }
 
 /*
