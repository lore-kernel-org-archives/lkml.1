Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYKDO4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYKDO4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYKDOxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:53:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60527 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbYKDOxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:53:39 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 03/16] x86 kdump: Create kdump_nmi_shootdown_cpus()
Date: Tue,  4 Nov 2008 12:52:31 -0200
Message-Id: <1225810364-8990-4-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the kdump-specific code that was living on nmi_shootdown_cpus().

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/crash.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 0e77fe9..7f6e2b2 100644
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

