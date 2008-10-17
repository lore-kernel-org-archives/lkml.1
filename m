Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYJQLSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYJQLSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYJQLS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:18:29 -0400
Received: from smtp.zeuux.org ([210.51.160.52]:53513 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbYJQLS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:18:29 -0400
Date: Fri, 17 Oct 2008 19:18:29 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: mingo@elte.hu
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/x86: Fix waring when build on x86_32
Message-ID: <20081017111829.GA20328@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the waring When I buile the Linux-2.6 kernel on x86_32.
arch/x86/kernel/io_apic_32.c: In function 'print_local_APIC':
arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 arch/x86/kernel/io_apic_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index e710289..f678d12 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1536,8 +1536,8 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	}
 
 	icr = apic_icr_read();
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
+	printk(KERN_DEBUG "... APIC ICR: %08x\n", (unsigned int)icr);
+	printk(KERN_DEBUG "... APIC ICR2: %08x\n", (unsigned int)(icr >> 32));
 
 	v = apic_read(APIC_LVTT);
 	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
-- 
1.5.2.5

-- 
Jianjun Kong | Happy Hacking
HomePage: http://kongove.cn
Gtalk: kongjianjun@gmail.com
