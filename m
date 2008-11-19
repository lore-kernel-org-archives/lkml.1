Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYKSWDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYKSWDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYKSWD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:03:28 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:45140 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbYKSWD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:03:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oO02EpzCPOnaM0fPG8QDcudShTf9GQIK8QU2xveK/Bos70rn9jfHjn9wsPR/HdFdw/
         CyfDt/4uiZjlmwswyKVnk+Lagl7wHW7NQsSuDm2e17iyj+5ndDthWULe7bfRtL7J8sUQ
         z9DoTuOftMI5S31YrQc/bMZQkA5bfManR1jJI=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Fix arch/x86/kernel/setup.c build warning when !CONFIG_X86_RESERVE_LOW_64K
Date: Wed, 19 Nov 2008 16:05:15 -0700
Message-Id: <1227135915-32628-2-git-send-email-aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227135915-32628-1-git-send-email-aciddeath@gmail.com>
References: <1227135915-32628-1-git-send-email-aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix
arch/x86/kernel/setup.c:592: warning: 'dmi_low_memory_corruption' defined but not used

this is only used if CONFIG_X86_RESERVE_LOW_64K is defined.

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/setup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 598435b..e417308 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -588,6 +588,7 @@ static struct x86_quirks default_x86_quirks __initdata;
 
 struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -599,6 +600,7 @@ static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 
 	return 0;
 }
+#endif
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
-- 
1.5.6.4

