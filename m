Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZJMFiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZJMFiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 01:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZJMFh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 01:37:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:59923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbZJMFh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 01:37:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,550,1249282800"; 
   d="scan'208";a="456901393"
From: "Shi, Alex" <alex.shi@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "Chen, Tim C" <tim.c.chen@intel.com>, "Shi, Alex" <alex.shi@intel.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>, "rjw@sisk.pl" <rjw@sisk.pl>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Tue, 13 Oct 2009 13:35:41 +0800
Subject: RE: [tip:x86/urgent] x86: fix kernel panic on 32 bits when profiling
Thread-Topic: [tip:x86/urgent] x86: fix kernel panic on 32 bits when
 profiling
Thread-Index: AcpLbmWT85PC0nVLQ12LYoMk2cAEIQAWGwKQ
Message-ID: <F7C8A4D3A9905B45A80E4C194793FA651553A456D1@PDSMSX501.ccr.corp.intel.com>
References: <tip-d1705c558c95418378b11a0be963fe1b3e2fa381@git.kernel.org>
In-Reply-To: <tip-d1705c558c95418378b11a0be963fe1b3e2fa381@git.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n9D5ex16002590

Yes, it seems better than mine. 

BRG
Alex 

-----Original Message-----
From: tip tree robot [mailto:bounces.tip@hpa.at.zytor.com] On Behalf Of tip-bot for H. Peter Anvin
Sent: 2009å¹´10æœˆ13æ—¥ 2:58
To: linux-tip-commits@vger.kernel.org
Cc: Chen, Tim C; hpa@zytor.com; mingo@redhat.com; akpm@linux-foundation.org; Shi, Alex; tglx@linutronix.de; rjw@sisk.pl
Subject: [tip:x86/urgent] x86: fix kernel panic on 32 bits when profiling

Commit-ID:  d1705c558c95418378b11a0be963fe1b3e2fa381
Gitweb:     http://git.kernel.org/tip/d1705c558c95418378b11a0be963fe1b3e2fa381
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 12 Oct 2009 11:32:31 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 12 Oct 2009 11:53:51 -0700

x86: fix kernel panic on 32 bits when profiling

Latest kernel has a kernel panic in booting on i386 machine when
profile=2 setting in cmdline.  It is due to 'sp' being incorrect in
profile_pc().

BUG: unable to handle kernel NULL pointer dereference at 00000246
IP: [<c01288b6>] profile_pc+0x2a/0x48
*pde = 00000000
Oops: 0000 [#1] SMP

This differs from the original version by Alex Shi in that we use the
kernel_stack_pointer() inline already defined in <asm/ptrace.h> for
this purpose, instead of #ifdef.

Originally-by: Alex Shi <alex.shi@intel.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/time.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index dcb00d2..be25734 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -38,7 +38,8 @@ unsigned long profile_pc(struct pt_regs *regs)
 #ifdef CONFIG_FRAME_POINTER
 		return *(unsigned long *)(regs->bp + sizeof(long));
 #else
-		unsigned long *sp = (unsigned long *)regs->sp;
+		unsigned long *sp =
+			(unsigned long *)kernel_stack_pointer(regs);
 		/*
 		 * Return address is either directly at stack pointer
 		 * or above a saved flags. Eflags has bits 22-31 zero,
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
