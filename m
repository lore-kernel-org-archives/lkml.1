Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbYJKXlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbYJKXlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 19:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbYJKXll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 19:41:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:11664 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbYJKXlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 19:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GTG9YJX4/xgVdY70p6REgm8w5o9DpQZtPvpwIwr0sMH6j8r8aB2U9rlVG/VwFpvquY
         vD1tpkU5t5ioFpeZQ7IW9CGK5ZHl8Y5JeEenqmRyScPXyCjd90Y2pvmMVa4AcKLWuMcu
         /+/csfY+6ItWLRmIe9fjaP1ig9DnzqZ3oW+bA=
Date: Sun, 12 Oct 2008 03:41:30 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: h-shimamoto@ct.jp.nec.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/io_apic_32: fix printk format warning
Message-ID: <20081011234130.GE25563@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/io_apic_32.c: In function 'print_local_APIC':
arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
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
