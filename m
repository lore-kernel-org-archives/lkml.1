Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYKET6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYKET6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYKET57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:57:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41389 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbYKET56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:57:58 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 03/15] x86 kdump: Create kdump_nmi_shootdown_cpus()
Date: Wed,  5 Nov 2008 17:56:46 -0200
Message-Id: <1225915018-6548-4-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the kdump-specific code that was living on nmi_shootdown_cpus().

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/crash.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index a70c1c6..d6a8085 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -119,10 +119,17 @@ static void nmi_shootdown_cpus(void)
 	}
 
 	/* Leave the nmi callback set */
+}
+
+static void kdump_nmi_shootdown_cpus(void)
+{
+	nmi_shootdown_cpus();
+
 	disable_local_APIC();
 }
+
 #else
-static void nmi_shootdown_cpus(void)
+static void kdump_nmi_shootdown_cpus(void)
 {
 	/* There are no cpus to shootdown */
 }
@@ -141,7 +148,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	/* The kernel is broken so disable interrupts */
 	local_irq_disable();
 
-	nmi_shootdown_cpus();
+	kdump_nmi_shootdown_cpus();
 	lapic_shutdown();
 #if defined(CONFIG_X86_IO_APIC)
 	disable_IO_APIC();
-- 
1.5.5.GIT

