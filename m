Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbZAVNeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbZAVNeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbZAVNdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:33:36 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:23575 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZAVNde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:33:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LL3ccAQYrU4yKfXp6YqlKToBNpVoSITjdB2PbBNXV0qrEupblpLdp/WvJw6otmZjlC
         xLpQG6xCyBdjUwm+qdlbJckNIPicU/EHtwH790aFRS3+TGKHv6PpVPSa44huBE91QVh3
         mNaMFq1t5Hu2z1hLxyASUaFajGufUanho44dw=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 2/5] x86-64: Remove include of apic.h from hardirq_64.h
Date: Thu, 22 Jan 2009 08:33:35 -0500
Message-Id: <1232631218-5092-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
References: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APIC definitions aren't needed here.  Remove the include and fix
up the fallout.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/hardirq_64.h |    1 -
 arch/x86/kernel/efi_64.c          |    1 +
 arch/x86/kernel/irq_64.c          |    1 +
 3 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/hardirq_64.h b/arch/x86/include/asm/hardirq_64.h
index a65bab2..873c3c7 100644
--- a/arch/x86/include/asm/hardirq_64.h
+++ b/arch/x86/include/asm/hardirq_64.h
@@ -3,7 +3,6 @@
 
 #include <linux/threads.h>
 #include <linux/irq.h>
-#include <asm/apic.h>
 
 typedef struct {
 	unsigned int __softirq_pending;
diff --git a/arch/x86/kernel/efi_64.c b/arch/x86/kernel/efi_64.c
index 652c528..a4ee291 100644
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -36,6 +36,7 @@
 #include <asm/proto.h>
 #include <asm/efi.h>
 #include <asm/cacheflush.h>
+#include <asm/fixmap.h>
 
 static pgd_t save_pgd __initdata;
 static unsigned long efi_flags __initdata;
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 0b254de..018963a 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -18,6 +18,7 @@
 #include <linux/smp.h>
 #include <asm/io_apic.h>
 #include <asm/idle.h>
+#include <asm/apic.h>
 
 DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
-- 
1.6.1

