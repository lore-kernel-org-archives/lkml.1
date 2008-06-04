Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbYFDUVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbYFDUVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYFDUVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:21:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:2915 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYFDUVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:21:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=GLvHwlth8PHLDDNb6UxRo3L1tbVMzhBilxj4I8b1wXMT14fMNL/2bM773gtGkFjh+8
         bHDPW8vpuGo+o9LP76A0JLO+a1kXTXtx2W4ATugtMkU6FYpHqFuwjjHgf6sdFegG24Vt
         e3fcj1aDvF9N72xr9LKYm8NGUKzFJBlKfPa6w=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: e820 max_arch_pfn typo fix for 64 bit
Date: Wed, 4 Jun 2008 13:21:29 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031934.01198.yhlu.kernel@gmail.com> <200806031935.05202.yhlu.kernel@gmail.com>
In-Reply-To: <200806031935.05202.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041321.30083.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


should use right shift

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -771,7 +771,7 @@ u64 __init early_reserve_e820(u64 startt
 #  define MAX_ARCH_PFN		(1ULL<<(32-PAGE_SHIFT))
 # endif
 #else /* CONFIG_X86_32 */
-# define MAX_ARCH_PFN MAXMEM<<PAGE_SHIFT
+# define MAX_ARCH_PFN MAXMEM>>PAGE_SHIFT
 #endif
 
 /*
