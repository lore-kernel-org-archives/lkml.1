Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZIJCW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZIJCW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 22:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZIJCW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 22:22:27 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36235 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751631AbZIJCW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 22:22:26 -0400
Date: Wed, 9 Sep 2009 21:22:26 -0500
From: Jack Steiner <steiner@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Daniel Walker <dwalker@fifo99.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH V2] x86: SGU UV Add volatile semantics to macros that access chipset registers
Message-ID: <20090910022226.GB10038@sgi.com>
References: <20090909154246.GA26716@sgi.com> <1252512600.14793.125.camel@desktop> <20090909180110.GA10311@sgi.com> <1252519885.14793.135.camel@desktop> <4AA7F9E5.4070506@nortel.com> <20090909193829.GB10530@sgi.com> <4AA84BE7.9010304@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA84BE7.9010304@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add volatile-semantics to the SGI UV read/write macros that are
used to access chipset memory mapped registers. No direct
references to volatile are made. Instead the readq/writeq
macros are used.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/include/asm/uv/uv_hub.h |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-09-09 01:34:02.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-09-09 20:51:53.000000000 -0500
@@ -15,6 +15,7 @@
 #include <linux/numa.h>
 #include <linux/percpu.h>
 #include <linux/timer.h>
+#include <linux/io.h>
 #include <asm/types.h>
 #include <asm/percpu.h>
 #include <asm/uv/uv_mmrs.h>
@@ -258,13 +259,13 @@ static inline unsigned long *uv_global_m
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
@@ -281,13 +282,13 @@ static inline unsigned long *uv_global_m
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
@@ -301,22 +302,22 @@ static inline unsigned long *uv_local_mm
 
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
+	return readq(uv_local_mmr_address(offset));
 }
 
 static inline void uv_write_local_mmr8(unsigned long offset, unsigned char val)
 {
-	*((unsigned char *)uv_local_mmr_address(offset)) = val;
+	writeq(val, uv_local_mmr_address(offset));
 }
 
 /*
