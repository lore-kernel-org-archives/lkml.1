Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbZEKPtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbZEKPtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZEKPtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:49:33 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:13562 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbZEKPtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:49:32 -0400
Message-Id: <4A08652802000078000004F8@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 11 May 2009 16:49:28 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix percpu_{to,from}_op()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- the byte operand constraints were wrong for 32-bit
- the to-op's input operands weren't properly parenthesized

[ Impact: compilation problem fix ]

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/percpu.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.30-rc5/arch/x86/include/asm/percpu.h	2009-05-11 17:28:25.000000000 +0200
+++ 2.6.30-rc5-x86-percpu-accessors/arch/x86/include/asm/percpu.h	2009-05-07 16:40:11.000000000 +0200
@@ -82,22 +82,22 @@ do {							\
 	case 1:						\
 		asm(op "b %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "ri" ((T__)val));			\
+		    : "qi" ((T__)(val)));		\
 		break;					\
 	case 2:						\
 		asm(op "w %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "ri" ((T__)val));			\
+		    : "ri" ((T__)(val)));		\
 		break;					\
 	case 4:						\
 		asm(op "l %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "ri" ((T__)val));			\
+		    : "ri" ((T__)(val)));		\
 		break;					\
 	case 8:						\
 		asm(op "q %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "re" ((T__)val));			\
+		    : "re" ((T__)(val)));		\
 		break;					\
 	default: __bad_percpu_size();			\
 	}						\
@@ -109,7 +109,7 @@ do {							\
 	switch (sizeof(var)) {				\
 	case 1:						\
 		asm(op "b "__percpu_arg(1)",%0"		\
-		    : "=r" (ret__)			\
+		    : "=q" (ret__)			\
 		    : "m" (var));			\
 		break;					\
 	case 2:						\



