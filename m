Return-Path: <linux-kernel-owner+w=401wt.eu-S1760872AbYBARI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872AbYBARI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760353AbYBARIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:08:38 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:19205 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760285AbYBARIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:08:37 -0500
From: Andi Kleen <ak@suse.de>
References: <20080201608.475239056@suse.de>
In-Reply-To: <20080201608.475239056@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org,
       mel@csn.ul.ie
Subject: [PATCH] [2/2] Remove NUMAQ support in io_32.h
Message-Id: <20080201170834.7D0281B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 18:08:34 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 17:02:17.0058 (UTC) FILETIME=[33014C20:01C864F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that the only user does it on its own remove the NUMAQ support macros in io_32.h

The next step would be to convert the preprocessor mess to actually readable
standard inlines.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/include/asm-x86/io_32.h
===================================================================
--- linux.orig/include/asm-x86/io_32.h
+++ linux/include/asm-x86/io_32.h
@@ -275,29 +275,6 @@ static inline void slow_down_io(void) {
 
 #endif
 
-#ifdef CONFIG_X86_NUMAQ
-extern void *xquad_portio;    /* Where the IO area was mapped */
-#define XQUAD_PORT_ADDR(port, quad) (xquad_portio + (XQUAD_PORTIO_QUAD*quad) + port)
-#define __BUILDIO(bwl,bw,type) \
-static inline void out##bwl##_quad(unsigned type value, int port, int quad) { \
-	if (xquad_portio) \
-		write##bwl(value, XQUAD_PORT_ADDR(port, quad)); \
-	else \
-		out##bwl##_local(value, port); \
-} \
-static inline void out##bwl(unsigned type value, int port) { \
-	out##bwl##_quad(value, port, 0); \
-} \
-static inline unsigned type in##bwl##_quad(int port, int quad) { \
-	if (xquad_portio) \
-		return read##bwl(XQUAD_PORT_ADDR(port, quad)); \
-	else \
-		return in##bwl##_local(port); \
-} \
-static inline unsigned type in##bwl(int port) { \
-	return in##bwl##_quad(port, 0); \
-}
-#else
 #define __BUILDIO(bwl,bw,type) \
 static inline void out##bwl(unsigned type value, int port) { \
 	out##bwl##_local(value, port); \
@@ -305,8 +282,6 @@ static inline void out##bwl(unsigned typ
 static inline unsigned type in##bwl(int port) { \
 	return in##bwl##_local(port); \
 }
-#endif
-
 
 #define BUILDIO(bwl,bw,type) \
 static inline void out##bwl##_local(unsigned type value, int port) { \
