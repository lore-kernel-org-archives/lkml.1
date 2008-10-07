Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYJGLnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYJGLnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYJGLnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:43:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38021 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbYJGLnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:43:15 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20081007143.793379346@firstfloor.org>
In-Reply-To: <20081007143.793379346@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/3] Use the fancy DECLARE_EAX_EDX macros for rdtscp too
Message-Id: <20081007114313.CB5F23E6A0D@basil.firstfloor.org>
Date: Tue,  7 Oct 2008 13:43:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rdtscp was the only function to not use them.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.27-rc4-misc/include/asm-x86/msr.h
===================================================================
--- linux-2.6.27-rc4-misc.orig/include/asm-x86/msr.h
+++ linux-2.6.27-rc4-misc/include/asm-x86/msr.h
@@ -34,10 +34,10 @@
 
 static inline unsigned long long native_read_tscp(unsigned int *aux)
 {
-	unsigned long low, high;
-	asm volatile(".byte 0x0f,0x01,0xf9"
-		     : "=a" (low), "=d" (high), "=c" (*aux));
-	return low | ((u64)high << 32);
+	DECLARE_ARGS(val, low, high);
+	asm volatile(".byte 0x0f,0x01,0xf9" :
+			EAX_EDX_RET(val, low, high), "=c" (*aux));
+	return EAX_EDX_VAL(val, low, high);
 }
 
 static inline unsigned long long native_read_msr(unsigned int msr)
