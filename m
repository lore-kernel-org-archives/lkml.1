Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbXKYWAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbXKYWAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbXKYWAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:00:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756275AbXKYWAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:00:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 07/27] x86: single_step 0xf0
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Zippy-Says: How many retired bricklayers from FLORIDA are out purchasing PENCIL
    SHARPENERS right NOW??
Message-Id: <20071125220006.74EAB26F8E1@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:00:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes the 64-bit single-step handling code's instruction
decoder to grok the 0xf0 (lock) prefix, which the 32-bit code
already does correctly.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/step.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 3b70f20..6a93b93 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -66,7 +66,7 @@ static int is_setting_trap_flag(struct task_struct *child, struct pt_regs *regs)
 		case 0x26: case 0x2e:
 		case 0x36: case 0x3e:
 		case 0x64: case 0x65:
-		case 0xf2: case 0xf3:
+		case 0xf0: case 0xf2: case 0xf3:
 			continue;
 
 		case 0x40 ... 0x4f:
