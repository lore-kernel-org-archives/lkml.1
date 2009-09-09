Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZIIPmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZIIPmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZIIPmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:42:44 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58987 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752592AbZIIPmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:42:44 -0400
Date: Wed, 9 Sep 2009 10:42:46 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: SGU UV Add volatile to macros that access chipset registers
Message-ID: <20090909154246.GA26716@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "volatile" to the SGI UV read/write macros that are used to access chipset
memory mapped registers.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/include/asm/uv/uv_hub.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-08-10 01:45:42.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-08-10 11:43:39.000000000 -0500
@@ -248,7 +248,7 @@ static inline int uv_apicid_to_pnode(int
  * Access global MMRs using the low memory MMR32 space. This region supports
  * faster MMR access but not all MMRs are accessible in this space.
  */
-static inline unsigned long *uv_global_mmr32_address(int pnode,
+static inline volatile unsigned long *uv_global_mmr32_address(int pnode,
 				unsigned long offset)
 {
 	return __va(UV_GLOBAL_MMR32_BASE |
@@ -271,7 +271,7 @@ static inline unsigned long uv_read_glob
  * Access Global MMR space using the MMR space located at the top of physical
  * memory.
  */
-static inline unsigned long *uv_global_mmr64_address(int pnode,
+static inline volatile unsigned long *uv_global_mmr64_address(int pnode,
 				unsigned long offset)
 {
 	return __va(UV_GLOBAL_MMR64_BASE |
@@ -294,7 +294,7 @@ static inline unsigned long uv_read_glob
  * Access hub local MMRs. Faster than using global space but only local MMRs
  * are accessible.
  */
-static inline unsigned long *uv_local_mmr_address(unsigned long offset)
+static inline volatile unsigned long *uv_local_mmr_address(unsigned long offset)
 {
 	return __va(UV_LOCAL_MMR_BASE | offset);
 }
@@ -311,12 +311,12 @@ static inline void uv_write_local_mmr(un
 
 static inline unsigned char uv_read_local_mmr8(unsigned long offset)
 {
-	return *((unsigned char *)uv_local_mmr_address(offset));
+	return *((volatile unsigned char *)uv_local_mmr_address(offset));
 }
 
 static inline void uv_write_local_mmr8(unsigned long offset, unsigned char val)
 {
-	*((unsigned char *)uv_local_mmr_address(offset)) = val;
+	*((volatile unsigned char *)uv_local_mmr_address(offset)) = val;
 }
 
 /*
