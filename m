Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbZLRIt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbZLRIt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 03:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZLRItA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 03:49:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:47813 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbZLRIs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 03:48:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,417,1257148800"; 
   d="scan'208";a="477313935"
From: Sheng Yang <sheng@linux.intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] x86: Raise vsyscall priority on hotplug notifier chain
Date: Fri, 18 Dec 2009 16:48:45 +0800
Message-Id: <1261126127-9603-5-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1261126127-9603-1-git-send-email-sheng@linux.intel.com>
References: <1261126127-9603-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM need vsyscall_init() to initialize MSR_TSC_AUX before it read the value.
Per Avi's suggestion, this patch raised vsyscall priority on hotplug notifier
chain, to 30.

CC: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/kernel/vsyscall_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 8cb4974..971bbc9 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -300,7 +300,8 @@ static int __init vsyscall_init(void)
 	register_sysctl_table(kernel_root_table2);
 #endif
 	on_each_cpu(cpu_vsyscall_init, NULL, 1);
-	hotcpu_notifier(cpu_vsyscall_notifier, 0);
+	/* notifier priority > KVM */
+	hotcpu_notifier(cpu_vsyscall_notifier, 30);
 	return 0;
 }
 
-- 
1.5.4.5

