Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbZFQVn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbZFQVn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZFQVnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:43:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:48904 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZFQVnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:43:51 -0400
Message-ID: <4A396361.2000302@kernel.org>
Date: Wed, 17 Jun 2009 14:42:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use zalloc_cpumask_var for mce_devinitialized
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


to make MAXSMP happy

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

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
