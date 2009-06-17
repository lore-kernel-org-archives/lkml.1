Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbZFQXWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbZFQXWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbZFQXWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:22:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:34980 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbZFQXWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:22:06 -0400
Message-ID: <4A397A7D.5090608@kernel.org>
Date: Wed, 17 Jun 2009 16:21:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use zalloc_cpumask_var for mce_dev_initialized -v2
References: <4A396361.2000302@kernel.org>
In-Reply-To: <4A396361.2000302@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


need to get cleared cpu_mask about if mce device is initialized.
esp when MAXSMP is used.

used zalloc_... instead

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1969,7 +1969,7 @@ static __init int mce_init_device(void)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	alloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
+	zalloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
 
 	err = mce_init_banks();
 	if (err)
