Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbYC0LdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbYC0LdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYC0Lcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:32:52 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:51146 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755138AbYC0Lcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:32:51 -0400
X-Greylist: delayed 6607 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2008 07:32:51 EDT
Date: Thu, 27 Mar 2008 12:32:26 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 27
Message-ID: <20080327123226.452f0a3f@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080327104745.GA1686@cs181133002.pp.htv.fi>
References: <20080327183357.7c637aed.sfr@canb.auug.org.au>
	<20080327104224.2b98b561@hskinnemo-gx620.norway.atmel.com>
	<20080327104745.GA1686@cs181133002.pp.htv.fi>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2008 11:32:26.0361 (UTC) FILETIME=[3B8CD690:01C88FFE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 12:47:45 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> According to Jan's page, there's still a build error with the defconfig:
>   http://l4x.org/k/?d=40450#err

Hmm...that must be a pretty ancient toolchain. In any case, the patch
below should fix it. The commit being reverted is not in mainline, so
I'll probably just drop both of them next time I rebase.

FWIW, a more recent toolchain is available here:

http://avr32linux.org/twiki/bin/view/Main/BinutilsPatches
http://avr32linux.org/twiki/bin/view/Main/GccPatches

Haavard

From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Date: Thu, 27 Mar 2008 12:23:07 +0100
Subject: [PATCH] Revert "avr32: Use better asm constraint in prefetch()"

This reverts commit e153fa1406b68460e0a8e498a2b83d50584cc40a.

This commit caused build breakage with some old 4.0.2-based gcc.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 include/asm-avr32/processor.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-avr32/processor.h b/include/asm-avr32/processor.h
index 2abd3de..49a88f5 100644
--- a/include/asm-avr32/processor.h
+++ b/include/asm-avr32/processor.h
@@ -169,7 +169,7 @@ extern void show_stack_log_lvl(struct task_struct *tsk, unsigned long sp,
 static inline void prefetch(const void *x)
 {
 	const char *c = x;
-	asm volatile("pref %0" : : "RKs16"(*c));
+	asm volatile("pref %0" : : "r"(c));
 }
 #define PREFETCH_STRIDE	L1_CACHE_BYTES
 
-- 
1.5.4.3

