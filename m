Return-Path: <linux-kernel-owner+w=401wt.eu-S934265AbXK2W3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265AbXK2W3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934183AbXK2W3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:29:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939AbXK2W3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:29:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 05/11] x86 ptrace getreg/putreg merge
In-Reply-To: Andrew Morton's message of  Thursday, 29 November 2007 09:27:15 -0800 <20071129092715.2674bfe1.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
	<20071129115954.12D3126F8E7@magilla.localdomain>
	<20071129092715.2674bfe1.akpm@linux-foundation.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071129222842.9613826F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 14:28:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This didn't need to be implemented as a macro hence it shouldn't have been.

Ok.


diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index b3433e1..0000000 100644  
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -45,8 +45,10 @@
 /*
  * Determines whether a value may be installed in a segment register.
  */
-#define invalid_selector(value) \
-	((value) != 0 && ((value) & SEGMENT_RPL_MASK) != USER_RPL)
+static inline bool invalid_selector(u16 value)
+{
+	return unlikely(value != 0 && (value & SEGMENT_RPL_MASK) != USER_RPL);
+}
 
 #ifdef CONFIG_X86_32
 
