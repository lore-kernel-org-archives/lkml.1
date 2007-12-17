Return-Path: <linux-kernel-owner+w=401wt.eu-S934310AbXLQAzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbXLQAzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934274AbXLQAyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:54:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:13168 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934214AbXLQAyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:54:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UZoPQPdc1dsYofjQUW+p4Ps8NO58cl8Alu5Bd2NQs+AHBO/tm2wh311pyq1/GK8h1i8PCSQ6kkMr5RqccnfwhEgPj8mf0ZVlGZ/dd/EtJ5uiPbDNv7ayYCTYrHCCxZK7H6j3ERZTiPM9rHN6BCs7OeBivqS6WYCMlJWmY0+EFQI=
Subject: [PATCH 2/4] x86: fix asm memory constraints in local_64.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 16:54:41 -0800
Message-Id: <1197852881.3749.96.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the shorter +m form rather than =m and m.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/local_64.h |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/include/asm-x86/local_64.h b/include/asm-x86/local_64.h
index da61076..7808f53 100644
--- a/include/asm-x86/local_64.h
+++ b/include/asm-x86/local_64.h
@@ -5,32 +5,30 @@ static inline void local_inc(local_t *l)
 {
 	__asm__ __volatile__(
 		"incq %0"
-		:"=m" (l->a.counter)
-		:"m" (l->a.counter));
+		:"+m" (l->a.counter));
 }
 
 static inline void local_dec(local_t *l)
 {
 	__asm__ __volatile__(
 		"decq %0"
-		:"=m" (l->a.counter)
-		:"m" (l->a.counter));
+		:"+m" (l->a.counter));
 }
 
 static inline void local_add(long i, local_t *l)
 {
 	__asm__ __volatile__(
 		"addq %1,%0"
-		:"=m" (l->a.counter)
-		:"ir" (i), "m" (l->a.counter));
+		:"+m" (l->a.counter)
+		:"ir" (i));
 }
 
 static inline void local_sub(long i, local_t *l)
 {
 	__asm__ __volatile__(
 		"subq %1,%0"
-		:"=m" (l->a.counter)
-		:"ir" (i), "m" (l->a.counter));
+		:"+m" (l->a.counter)
+		:"ir" (i));
 }
 
 /**
@@ -48,8 +46,8 @@ static inline int local_sub_and_test(long i, local_t *l)
 
 	__asm__ __volatile__(
 		"subq %2,%0; sete %1"
-		:"=m" (l->a.counter), "=qm" (c)
-		:"ir" (i), "m" (l->a.counter) : "memory");
+		:"+m" (l->a.counter), "=qm" (c)
+		:"ir" (i) : "memory");
 	return c;
 }
 
@@ -67,8 +65,8 @@ static inline int local_dec_and_test(local_t *l)
 
 	__asm__ __volatile__(
 		"decq %0; sete %1"
-		:"=m" (l->a.counter), "=qm" (c)
-		:"m" (l->a.counter) : "memory");
+		:"+m" (l->a.counter), "=qm" (c)
+		: : "memory");
 	return c != 0;
 }
 
@@ -86,8 +84,8 @@ static inline int local_inc_and_test(local_t *l)
 
 	__asm__ __volatile__(
 		"incq %0; sete %1"
-		:"=m" (l->a.counter), "=qm" (c)
-		:"m" (l->a.counter) : "memory");
+		:"+m" (l->a.counter), "=qm" (c)
+		: : "memory");
 	return c != 0;
 }
 
@@ -106,8 +104,8 @@ static inline int local_add_negative(long i, local_t *l)
 
 	__asm__ __volatile__(
 		"addq %2,%0; sets %1"
-		:"=m" (l->a.counter), "=qm" (c)
-		:"ir" (i), "m" (l->a.counter) : "memory");
+		:"+m" (l->a.counter), "=qm" (c)
+		:"ir" (i) : "memory");
 	return c;
 }
 
-- 
1.5.4.rc0.1083.gf568


