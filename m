Return-Path: <linux-kernel-owner+w=401wt.eu-S1762163AbYGBDDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163AbYGBDDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 23:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759267AbYGBDCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 23:02:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:24241 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758828AbYGBDCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 23:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Xy9QNG/ohG66t2LewUQfVfZZYuaISXWLlR5lUNfu0+Y6Qd5HYOtqygHJ2pgZq4JKuX
         HDOoqyC9H4N+X9X/f3yJ2Px5zI4RufN7s36vUEqBFfMZwjsGTOTtMFBPSxMQzh7Zcf07
         wXzVyIMvmY+Mzl/Cs6ce/pVgI8g9XOdiG5D3E=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: make early_res_to_bootmem print out less 80 width chars
Date: Tue, 1 Jul 2008 20:03:11 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200806301834.59156.yhlu.kernel@gmail.com>
In-Reply-To: <200806301834.59156.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807012003.11765.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |   15 ++++++++-------
 include/asm-x86/e820.h |    1 -
 2 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -839,7 +839,7 @@ void __init early_res_to_bootmem(u64 sta
 	printk(KERN_INFO "(%d early reservations) ==> bootmem\n", count);
 	for (i = 0; i < count; i++) {
 		struct early_res *r = &early_res[i];
-		printk(KERN_INFO "  #%d [ %010llx - %010llx ] %16s", i,
+		printk(KERN_INFO "  #%d [%010llx - %010llx] %16s", i,
 			r->start, r->end, r->name);
 		final_start = max(start, r->start);
 		final_end = min(end, r->end);
@@ -847,7 +847,7 @@ void __init early_res_to_bootmem(u64 sta
 			printk(KERN_CONT "\n");
 			continue;
 		}
-		printk(KERN_CONT " ===> [ %010llx - %010llx ]\n",
+		printk(KERN_CONT " ==> [%010llx - %010llx]\n",
 			final_start, final_end);
 		reserve_bootmem_generic(final_start, final_end - final_start,
 				BOOTMEM_DEFAULT);
