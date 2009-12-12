Return-Path: <linux-kernel-owner+w=401wt.eu-S1762858AbZLLAQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762858AbZLLAQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762841AbZLLAQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:16:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:53813 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762839AbZLLAP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:15:59 -0500
Date: Sat, 12 Dec 2009 00:15:37 GMT
From: tip-bot for Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, travis@sgi.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, travis@sgi.com, tglx@linutronix.de
In-Reply-To: <4B226E92.5080904@sgi.com>
References: <4B226E92.5080904@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Remove enabling x2apic message for every CPU
Message-ID: <tip-450b1e8dd10f41b5adad73f48ce8f6707d17c5c4@git.kernel.org>
Git-Commit-ID: 450b1e8dd10f41b5adad73f48ce8f6707d17c5c4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  450b1e8dd10f41b5adad73f48ce8f6707d17c5c4
Gitweb:     http://git.kernel.org/tip/450b1e8dd10f41b5adad73f48ce8f6707d17c5c4
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Fri, 11 Dec 2009 08:08:50 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 11 Dec 2009 14:32:31 -0800

x86: Remove enabling x2apic message for every CPU

Print only once that the system is supporting x2apic mode.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <4B226E92.5080904@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index efb2b9c..aa57c07 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1341,7 +1341,7 @@ void enable_x2apic(void)
 
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 	if (!(msr & X2APIC_ENABLE)) {
-		pr_info("Enabling x2apic\n");
+		printk_once(KERN_INFO "Enabling x2apic\n");
 		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
 	}
 }
